import numpy as np
from dataclasses import dataclass, field
from typing import Dict, Optional


def ecdf(x):
    """Return sorted values and ECDF F(t) for 1D array x."""
    x = np.asarray(x).ravel()
    x = x[np.isfinite(x)]
    x = x[x > 0]  # keep positive RTs only
    xs = np.sort(x)
    n = xs.size
    if n == 0:
        return np.array([]), np.array([])
    F = np.arange(1, n + 1) / n
    return xs, F


def miller_bound(Fa_t, Fv_t):
    """Race model (Miller) bound at time grid t: min(1, F_A(t) + F_V(t))."""
    return np.minimum(1.0, Fa_t + Fv_t)


def cdf_on_grid(xs, Fs, t_grid):
    """Interpolate a step ECDF at times in t_grid (right-continuous stairs)."""
    idx = np.searchsorted(xs, t_grid, side="right")
    n = xs.size
    if n == 0:
        return np.zeros_like(t_grid)
    return idx / n


def make_common_grid(a, v, av, n_points=400):
    """Build a common time grid covering the support of all RTs."""
    all_rts = np.concatenate([a, v, av])
    if all_rts.size == 0:
        return np.array([])
    lo = np.percentile(all_rts, 1)
    hi = np.percentile(all_rts, 99)
    lo = max(1e-6, lo)
    return np.linspace(lo, hi, n_points)


def independent_race_cdf(Fa_t: np.ndarray, Fv_t: np.ndarray) -> np.ndarray:
    """Probability-summation prediction under statistical independence (Raab 1962).

    F_race(t) = 1 - (1 - F_A(t)) * (1 - F_V(t))
    """
    return 1.0 - (1.0 - Fa_t) * (1.0 - Fv_t)


@dataclass
class ModelResult:
    """Result of a single model's prediction."""
    name: str
    predicted_cdf: np.ndarray
    rmse: float = 0.0
    r_squared: float = 0.0
    params: Dict[str, float] = field(default_factory=dict)


def compute_all_models(
    rt_A: np.ndarray,
    rt_V: np.ndarray,
    rt_AV: np.ndarray,
    t_grid: Optional[np.ndarray] = None,
    models: Optional[list] = None,
) -> Dict[str, ModelResult]:
    """Compute predictions for the Miller bound and Independent Race models.

    Parameters
    ----------
    rt_A, rt_V, rt_AV : array-like
        Reaction times for auditory, visual, and audiovisual conditions.
    t_grid : ndarray, optional
        Common time grid. Built automatically if None.
    models : list of str, optional
        Subset of model names. Default: both.
        Valid names: "miller_bound", "independent_race".

    Returns
    -------
    dict mapping model name → ModelResult.
    """
    all_models = {"miller_bound", "independent_race"}
    if models is None:
        models = list(all_models)
    models = [m for m in models if m in all_models]

    rt_A = np.asarray(rt_A).ravel()
    rt_V = np.asarray(rt_V).ravel()
    rt_AV = np.asarray(rt_AV).ravel()

    if t_grid is None:
        t_grid = make_common_grid(rt_A, rt_V, rt_AV)
    if t_grid.size == 0:
        return {}

    xa, Fa = ecdf(rt_A)
    xv, Fv = ecdf(rt_V)
    xav, Fav = ecdf(rt_AV)
    Fa_t = cdf_on_grid(xa, Fa, t_grid)
    Fv_t = cdf_on_grid(xv, Fv, t_grid)
    Fav_t = cdf_on_grid(xav, Fav, t_grid)

    def _gof(pred):
        rmse = float(np.sqrt(np.mean((Fav_t - pred) ** 2)))
        ss_res = float(np.sum((Fav_t - pred) ** 2))
        ss_tot = float(np.sum((Fav_t - np.mean(Fav_t)) ** 2))
        r2 = 1.0 - ss_res / max(ss_tot, 1e-12)
        return rmse, r2

    results: Dict[str, ModelResult] = {}

    if "miller_bound" in models:
        pred = miller_bound(Fa_t, Fv_t)
        rmse, r2 = _gof(pred)
        results["miller_bound"] = ModelResult(
            name="Miller Bound", predicted_cdf=pred, rmse=rmse, r_squared=r2,
        )

    if "independent_race" in models:
        pred = independent_race_cdf(Fa_t, Fv_t)
        rmse, r2 = _gof(pred)
        results["independent_race"] = ModelResult(
            name="Independent Race", predicted_cdf=pred, rmse=rmse, r_squared=r2,
        )

    return results
