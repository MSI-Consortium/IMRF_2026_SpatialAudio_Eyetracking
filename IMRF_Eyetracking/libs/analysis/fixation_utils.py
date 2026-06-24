"""
Fixation dispersion analysis with ellipse fitting.

Computes per-target accuracy (centroid bias, RMSE) and precision
(SD, 95 % confidence ellipse, BCEA, convex-hull area) from AOI-classified
fixation data.  All spatial metrics are returned in both **pixels** and
**degrees of visual angle**.

References
----------
* BCEA — Steinman (1965); Crossland & Rubin (2002).
* Confidence ellipse — chi² scaling of the covariance eigenvalues.
"""

from __future__ import annotations

import logging
import math
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Tuple

import numpy as np
import pandas as pd

logger = logging.getLogger(__name__)


# ====================================================================
# Dataclasses
# ====================================================================

@dataclass
class EllipseParams:
    """Parameters of a 2-D confidence ellipse."""
    center_x: float          # px
    center_y: float          # px
    semi_major: float        # px
    semi_minor: float        # px
    angle_deg: float         # orientation of semi-major axis (degrees, CCW from x-axis)
    area_px2: float          # pi * a * b  (px²)
    semi_major_deg: float = 0.0
    semi_minor_deg: float = 0.0
    area_deg2: float = 0.0


@dataclass
class DispersionMetrics:
    """Accuracy & precision metrics for fixations near one target."""
    target_name: str

    # --- Accuracy ---
    target_x: float             # true target centre (px)
    target_y: float             # true target centre (px)
    centroid_x: float           # mean fixation x (px)
    centroid_y: float           # mean fixation y (px)
    bias_x_px: float            # centroid_x - target_x
    bias_y_px: float            # centroid_y - target_y
    bias_x_deg: float = 0.0
    bias_y_deg: float = 0.0
    rmse_px: float = 0.0
    rmse_deg: float = 0.0

    # --- Precision ---
    sd_x_px: float = 0.0
    sd_y_px: float = 0.0
    sd_x_deg: float = 0.0
    sd_y_deg: float = 0.0
    ellipse: Optional[EllipseParams] = None
    bcea_px2: float = 0.0       # Bivariate Contour Ellipse Area
    bcea_deg2: float = 0.0
    hull_area_px2: float = 0.0
    hull_area_deg2: float = 0.0

    n_fixations: int = 0
    flagged: bool = False       # True when dispersion is notably high


# ====================================================================
# Core computation
# ====================================================================

def confidence_ellipse_params(
    xs: np.ndarray,
    ys: np.ndarray,
    confidence: float = 0.95,
) -> Optional[EllipseParams]:
    """Fit a 2-D confidence ellipse to (xs, ys) point cloud.

    Parameters
    ----------
    xs, ys : 1-D arrays of equal length (≥ 3 points required).
    confidence : float in (0, 1), probability level.

    Returns
    -------
    EllipseParams or None if fewer than 3 points.
    """
    if len(xs) < 3:
        return None

    from scipy.stats import chi2

    cx = float(np.mean(xs))
    cy = float(np.mean(ys))

    cov = np.cov(xs, ys)                # 2×2
    eigvals, eigvecs = np.linalg.eigh(cov)

    # eigh returns ascending order; largest eigenvalue is last
    order = eigvals.argsort()[::-1]
    eigvals = eigvals[order]
    eigvecs = eigvecs[:, order]

    # chi² quantile with 2 degrees of freedom
    chi2_val = chi2.ppf(confidence, df=2)

    semi_major = float(np.sqrt(eigvals[0] * chi2_val))
    semi_minor = float(np.sqrt(max(eigvals[1], 0.0) * chi2_val))

    # Angle of the semi-major axis (first eigenvector)
    angle_rad = float(np.arctan2(eigvecs[1, 0], eigvecs[0, 0]))
    angle_deg = float(np.degrees(angle_rad))

    area = math.pi * semi_major * semi_minor

    return EllipseParams(
        center_x=cx, center_y=cy,
        semi_major=semi_major, semi_minor=semi_minor,
        angle_deg=angle_deg,
        area_px2=area,
    )


def bcea(
    xs: np.ndarray,
    ys: np.ndarray,
    p: float = 0.68,
) -> float:
    """Bivariate Contour Ellipse Area (Crossland & Rubin 2002).

    BCEA = 2 * π * k * σ_x * σ_y * sqrt(1 − ρ²)

    where k = −ln(1 − P) and ρ is the Pearson correlation between x and y.

    A common choice is *P* = 0.68 (k ≈ 1.14), which gives the area
    enclosing ~68 % of fixations.  Use *P* = 0.95 (k ≈ 3.0) for a
    95 % contour.
    """
    if len(xs) < 3:
        return 0.0

    sx = float(np.std(xs, ddof=1))
    sy = float(np.std(ys, ddof=1))

    if sx == 0 or sy == 0:
        return 0.0

    rho = float(np.corrcoef(xs, ys)[0, 1])
    rho = np.clip(rho, -0.9999, 0.9999)

    k = -math.log(1.0 - p)
    return float(2.0 * math.pi * k * sx * sy * math.sqrt(1.0 - rho * rho))


def convex_hull_area(xs: np.ndarray, ys: np.ndarray) -> float:
    """Area of the convex hull of the point cloud (px²)."""
    if len(xs) < 3:
        return 0.0
    try:
        from scipy.spatial import ConvexHull
        pts = np.column_stack([xs, ys])
        hull = ConvexHull(pts)
        return float(hull.volume)       # 2-D volume == area
    except Exception:
        return 0.0


# ====================================================================
# Per-target computation
# ====================================================================

def compute_target_dispersion(
    fix_xs: np.ndarray,
    fix_ys: np.ndarray,
    target_x: float,
    target_y: float,
    target_name: str,
    ppd: float = 1.0,
    confidence: float = 0.95,
    bcea_p: float = 0.68,
) -> DispersionMetrics:
    """Compute accuracy + precision metrics for one target position.

    Parameters
    ----------
    fix_xs, fix_ys : fixation coordinates in pixels (only those already
        attributed to this target via ``nearest_target``).
    target_x, target_y : true target centre in pixels.
    ppd : pixels per degree (for unit conversion).
    confidence : confidence level for the ellipse (default 0.95).
    bcea_p : probability level for BCEA (default 0.68, per Crossland &
        Rubin 2002).
    """
    n = len(fix_xs)
    cx = float(np.mean(fix_xs)) if n > 0 else target_x
    cy = float(np.mean(fix_ys)) if n > 0 else target_y

    bias_x = cx - target_x
    bias_y = cy - target_y

    # RMSE from true target centre
    if n > 0:
        dists_sq = (fix_xs - target_x) ** 2 + (fix_ys - target_y) ** 2
        rmse_px = float(np.sqrt(np.mean(dists_sq)))
    else:
        rmse_px = 0.0

    sd_x = float(np.std(fix_xs, ddof=1)) if n > 1 else 0.0
    sd_y = float(np.std(fix_ys, ddof=1)) if n > 1 else 0.0

    ell = confidence_ellipse_params(fix_xs, fix_ys, confidence) if n >= 3 else None
    bcea_val = bcea(fix_xs, fix_ys, p=bcea_p) if n >= 3 else 0.0
    hull = convex_hull_area(fix_xs, fix_ys)

    m = DispersionMetrics(
        target_name=target_name,
        target_x=target_x,
        target_y=target_y,
        centroid_x=cx,
        centroid_y=cy,
        bias_x_px=bias_x,
        bias_y_px=bias_y,
        bias_x_deg=bias_x / ppd if ppd > 0 else 0.0,
        bias_y_deg=bias_y / ppd if ppd > 0 else 0.0,
        rmse_px=rmse_px,
        rmse_deg=rmse_px / ppd if ppd > 0 else 0.0,
        sd_x_px=sd_x,
        sd_y_px=sd_y,
        sd_x_deg=sd_x / ppd if ppd > 0 else 0.0,
        sd_y_deg=sd_y / ppd if ppd > 0 else 0.0,
        ellipse=ell,
        bcea_px2=bcea_val,
        bcea_deg2=bcea_val / (ppd * ppd) if ppd > 0 else 0.0,
        hull_area_px2=hull,
        hull_area_deg2=hull / (ppd * ppd) if ppd > 0 else 0.0,
        n_fixations=n,
    )

    # Fill in ellipse degree-space values
    if ell is not None and ppd > 0:
        ell.semi_major_deg = ell.semi_major / ppd
        ell.semi_minor_deg = ell.semi_minor / ppd
        ell.area_deg2 = ell.area_px2 / (ppd * ppd)

    return m


def compute_all_dispersion(
    fix_df: pd.DataFrame,
    aois: list,
    ppd: float = 1.0,
    confidence: float = 0.95,
    bcea_p: float = 0.68,
    x_col: str = "screen_x",
    y_col: str = "screen_y",
    nearest_col: str = "nearest_target",
) -> List[DispersionMetrics]:
    """Compute dispersion metrics for every AOI target.

    Parameters
    ----------
    fix_df : DataFrame with fixation positions and ``nearest_target`` column.
    aois : list of :class:`AOI` objects (from ``build_paradigm_aois``).
    ppd : pixels per degree.
    confidence : confidence level for ellipse (default 0.95).
    bcea_p : probability level for BCEA (default 0.68).

    Returns
    -------
    List[DispersionMetrics] — one per AOI.
    """
    results: List[DispersionMetrics] = []

    for aoi in aois:
        subset = fix_df[fix_df[nearest_col] == aoi.name]
        xs = subset[x_col].dropna().values.astype(float)
        ys = subset[y_col].dropna().values.astype(float)

        m = compute_target_dispersion(
            xs, ys,
            target_x=aoi.center_x, target_y=aoi.center_y,
            target_name=aoi.name,
            ppd=ppd, confidence=confidence, bcea_p=bcea_p,
        )
        results.append(m)

    # Flag targets with dispersion > 2× the cross-target mean
    rmses = [m.rmse_deg for m in results if m.n_fixations >= 3]
    if rmses:
        mean_rmse = float(np.mean(rmses))
        for m in results:
            if m.n_fixations >= 3 and m.rmse_deg > 2.0 * mean_rmse:
                m.flagged = True

    bceas = [m.bcea_deg2 for m in results if m.n_fixations >= 3]
    if bceas:
        mean_bcea = float(np.mean(bceas))
        for m in results:
            if m.n_fixations >= 3 and m.bcea_deg2 > 2.0 * mean_bcea:
                m.flagged = True

    return results


def dispersion_to_dataframe(metrics: List[DispersionMetrics]) -> pd.DataFrame:
    """Convert a list of :class:`DispersionMetrics` to a tidy DataFrame."""
    rows = []
    for m in metrics:
        row = {
            "Target": m.target_name,
            "N": m.n_fixations,
            "Bias X (°)": round(m.bias_x_deg, 2),
            "Bias Y (°)": round(m.bias_y_deg, 2),
            "RMSE (°)": round(m.rmse_deg, 2),
            "SD X (°)": round(m.sd_x_deg, 2),
            "SD Y (°)": round(m.sd_y_deg, 2),
        }
        if m.ellipse is not None:
            row["Semi-major (°)"] = round(m.ellipse.semi_major_deg, 2)
            row["Semi-minor (°)"] = round(m.ellipse.semi_minor_deg, 2)
            row["Orientation (°)"] = round(m.ellipse.angle_deg, 1)
            row["Ellipse Area (°²)"] = round(m.ellipse.area_deg2, 2)
        else:
            row["Semi-major (°)"] = None
            row["Semi-minor (°)"] = None
            row["Orientation (°)"] = None
            row["Ellipse Area (°²)"] = None
        row["BCEA (°²)"] = round(m.bcea_deg2, 2)
        row["Hull Area (°²)"] = round(m.hull_area_deg2, 2)
        row["Flagged"] = "⚠" if m.flagged else ""
        rows.append(row)
    return pd.DataFrame(rows)


# ====================================================================
# Ellipse-based point classification
# ====================================================================

def point_in_ellipse(
    xs: np.ndarray,
    ys: np.ndarray,
    ell: EllipseParams,
) -> np.ndarray:
    """Boolean mask: True where (x, y) falls inside the ellipse.

    Uses the standard rotated-ellipse containment test:
        ((x' cosθ + y' sinθ) / a)² + ((-x' sinθ + y' cosθ) / b)² ≤ 1
    """
    dx = xs - ell.center_x
    dy = ys - ell.center_y
    cos_a = np.cos(np.radians(ell.angle_deg))
    sin_a = np.sin(np.radians(ell.angle_deg))

    x_rot = dx * cos_a + dy * sin_a
    y_rot = -dx * sin_a + dy * cos_a

    a = max(ell.semi_major, 1e-9)
    b = max(ell.semi_minor, 1e-9)

    return (x_rot / a) ** 2 + (y_rot / b) ** 2 <= 1.0


def classify_fixations_by_ellipse(
    fix_df: pd.DataFrame,
    ellipses: Dict[str, EllipseParams],
    x_col: str = "screen_x",
    y_col: str = "screen_y",
) -> pd.DataFrame:
    """Classify fixations using fitted confidence ellipses instead of circles.

    Parameters
    ----------
    fix_df : fixation DataFrame.
    ellipses : ``{target_name: EllipseParams}`` — one per AOI.

    Returns
    -------
    DataFrame with an ``aoi_ellipse`` column (target name or None).
    """
    fix_df = fix_df.copy()
    xs = fix_df[x_col].values.astype(float)
    ys = fix_df[y_col].values.astype(float)

    labels = np.full(len(fix_df), None, dtype=object)

    for name, ell in ellipses.items():
        mask = point_in_ellipse(xs, ys, ell) & (labels == None)  # noqa: E711
        labels[mask] = name

    fix_df["aoi_ellipse"] = labels
    return fix_df
