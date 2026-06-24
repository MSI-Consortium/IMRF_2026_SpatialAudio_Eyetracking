"""
Differential Evolution optimizer for speaker placement.

Wraps scipy.optimize.differential_evolution with a repair+penalty hybrid
for constraint handling (feasible regions, forbidden regions, minimum
speaker distance). Includes stagnation detection and multi-restart.
"""

import numpy as np
from scipy.optimize import differential_evolution, dual_annealing, minimize
from typing import List, Dict, Tuple, Optional, Callable

try:
    import cma
except ImportError:
    cma = None

from ..geometry.box import Box
from ..optimization.objective import score_layout, compute_adaptive_weights
from ..optimization.speaker_placement import (
    repair_to_feasible,
    point_in_valid_region,
    generate_feasible_initial_population,
    initial_layout,
)
from ..config import config

EPS = 1e-12


def flatten_layout(layout: np.ndarray) -> np.ndarray:
    """(N, 3) -> (3N,) flat vector for DE."""
    return layout.ravel()


def unflatten_layout(x: np.ndarray, n_speakers: int) -> np.ndarray:
    """(3N,) flat vector -> (N, 3) layout."""
    return x.reshape(n_speakers, 3)


def compute_bounds(feasible_boxes: List[Box], n_speakers: int) -> List[Tuple[float, float]]:
    """
    Compute per-coordinate bounds for DE from the bounding box of all feasible regions.
    Returns list of (lo, hi) tuples, length 3 * n_speakers.
    """
    all_mins = np.min([b.min_pt for b in feasible_boxes], axis=0)
    all_maxs = np.max([b.max_pt for b in feasible_boxes], axis=0)
    single = [(float(all_mins[d]), float(all_maxs[d])) for d in range(3)]
    return single * n_speakers


def repair_layout(
    layout: np.ndarray,
    feasible_boxes: List[Box],
    forbidden_boxes: List[Box],
) -> Tuple[np.ndarray, float]:
    """
    Repair each speaker position to be feasible.
    Returns (repaired_layout, normalized_total_repair_distance).
    """
    repaired = layout.copy()
    total_repair = 0.0

    for i in range(len(repaired)):
        if not point_in_valid_region(repaired[i], feasible_boxes, forbidden_boxes):
            original = repaired[i].copy()
            repaired[i] = repair_to_feasible(repaired[i], feasible_boxes, forbidden_boxes)
            total_repair += np.linalg.norm(repaired[i] - original)

    # Normalize by number of speakers and room scale
    total_repair /= len(repaired) * 5.0 + EPS
    return repaired, total_repair


def compute_min_distance_penalty(layout: np.ndarray, min_dist: float) -> float:
    """
    Compute penalty for speakers closer than min_dist.
    Returns >= 0, where 0 means no violations.
    """
    if len(layout) < 2:
        return 0.0

    diffs = layout[:, None, :] - layout[None, :, :]
    dists = np.linalg.norm(diffs, axis=-1)
    np.fill_diagonal(dists, np.inf)

    violations = np.maximum(0.0, min_dist - dists)
    # Use upper triangle only to avoid double-counting each pair
    penalty = np.sum(np.triu(violations, k=1)) / (len(layout) * (len(layout) - 1) / 2 * min_dist + EPS)
    return float(penalty)


def compute_angular_spread_penalty(
    layout: np.ndarray, listener: np.ndarray
) -> float:
    """
    Penalize poor angular distribution of speakers as seen from the listener.

    Computes the minimum nearest-neighbor angle on the unit sphere and
    returns a penalty that pushes speakers toward more uniform distribution.
    This is much more sensitive to individual speaker movements than
    average VBAP localization error.

    Returns a value in [0, 1] where 0 = perfectly uniform, 1 = clustered.
    """
    rel = layout - listener[None, :]
    dists = np.linalg.norm(rel, axis=1, keepdims=True)
    dists = np.maximum(dists, EPS)
    dirs = rel / dists  # (N, 3) unit directions

    # Pairwise angles between all speakers
    dots = np.clip(dirs @ dirs.T, -1.0, 1.0)
    np.fill_diagonal(dots, -1.0)  # exclude self
    angles = np.arccos(dots)
    np.fill_diagonal(angles, np.inf)

    # Minimum nearest-neighbor angle (Tammes-like metric)
    min_nn_angles = np.min(angles, axis=1)  # (N,) nearest neighbor angle per speaker
    min_angle = np.min(min_nn_angles)

    # Ideal minimum angle for N speakers on a sphere: ~sqrt(4*pi/N)
    ideal_min = np.sqrt(4 * np.pi / len(layout))

    # Penalty: how far below ideal is the actual minimum?
    # Also penalize variance of nearest-neighbor angles (want uniform spacing)
    nn_variance = np.var(min_nn_angles)

    # Combined: (1 - min/ideal) + variance term
    shortfall = max(0.0, 1.0 - min_angle / ideal_min)
    variance_pen = nn_variance / (1.0 + nn_variance)

    return float(0.7 * shortfall + 0.3 * variance_pen)


def compute_symmetry_penalty(layout: np.ndarray) -> float:
    """
    Penalize left/right speaker count imbalance across the x=0 plane.

    Returns |n_right - n_left| / n_total, a value in [0, 1]
    where 0 = perfectly balanced.
    """
    x_coords = layout[:, 0]
    n_right = int(np.sum(x_coords > 0))
    n_left = int(np.sum(x_coords < 0))
    n_total = len(layout)
    if n_total == 0:
        return 0.0
    return abs(n_right - n_left) / n_total


def make_cost_function(
    n_speakers: int,
    feasible_boxes: List[Box],
    forbidden_boxes: List[Box],
    listener_positions: np.ndarray,
    test_directions: np.ndarray,
    cost_weights: Dict[str, float],
    min_speaker_distance: float,
    feasibility_penalty: float = 10.0,
    distance_penalty_factor: float = 5.0,
    callback_store: Optional[List] = None,
) -> Callable:
    """
    Create the objective function closure for DE.

    Uses repair+penalty hybrid:
    1. Repair each speaker to nearest feasible point if infeasible
    2. Add penalty proportional to repair distance
    3. Add penalty for min-distance violations
    4. Add angular spread penalty for better gradient signal
    """
    listener_center = np.mean(listener_positions, axis=0)
    spread_weight = float(cost_weights.get("spread_penalty", 2.0))
    symmetry_weight = float(cost_weights.get("symmetry_weight", 1.5))

    def objective(x: np.ndarray) -> float:
        layout = unflatten_layout(x, n_speakers)

        # Repair infeasible speakers
        repaired, repair_cost = repair_layout(layout, feasible_boxes, forbidden_boxes)

        # Minimum distance penalty
        dist_violation = compute_min_distance_penalty(repaired, min_speaker_distance)

        # Real VBAP cost
        result = score_layout(repaired, listener_positions, test_directions, cost_weights)
        vbap_cost = result["total_cost"]

        # Angular spread penalty — provides gradient signal when VBAP metrics plateau
        spread_pen = compute_angular_spread_penalty(repaired, listener_center)

        # Left/right symmetry penalty
        symmetry_pen = compute_symmetry_penalty(repaired)

        total = (
            vbap_cost
            + feasibility_penalty * repair_cost
            + distance_penalty_factor * dist_violation
            + spread_weight * spread_pen
            + symmetry_weight * symmetry_pen
        )

        # Store for convergence tracking (scalars only to limit memory)
        if callback_store is not None:
            callback_store.append(
                {
                    "total": total,
                    "vbap_cost": vbap_cost,
                    "repair_cost": repair_cost,
                    "dist_violation": dist_violation,
                    "spread_penalty": spread_pen,
                    "symmetry_penalty": symmetry_pen,
                }
            )

        return total

    return objective


def _run_single_de(
    objective: Callable,
    bounds: List[Tuple[float, float]],
    init_pop: np.ndarray,
    de_params: Dict,
    seed: int,
    callback: Optional[Callable] = None,
    stagnation_limit: int = 20,
):
    """
    Run a single DE optimization pass with stagnation detection.

    If the best cost doesn't improve for `stagnation_limit` generations,
    the run terminates early to save time for the next restart.
    """
    workers = de_params.get("workers", 1)
    stag_limit = de_params.get("stagnation_limit", stagnation_limit)

    # Track best cost seen across all function evaluations
    best_at_last_gen = [np.inf]
    best_ever = [np.inf]
    stale_gens = [0]
    eval_count = [0]

    # Wrap objective to track the global minimum
    def tracked_objective(x):
        cost = objective(x)
        eval_count[0] += 1
        if cost < best_ever[0]:
            best_ever[0] = cost
        return cost

    def stag_callback(xk, convergence):
        # Check if best improved since last generation
        if best_ever[0] < best_at_last_gen[0] - 1e-10:
            best_at_last_gen[0] = best_ever[0]
            stale_gens[0] = 0
        else:
            stale_gens[0] += 1
        if stale_gens[0] >= stag_limit:
            print(f"  Stagnation: no improvement for {stag_limit} gens "
                  f"(best={best_ever[0]:.6f}). Stopping restart.")
            return True  # stops DE
        if callback is not None:
            return callback(xk, convergence)
        return False

    de_kwargs = {
        "func": tracked_objective,
        "bounds": bounds,
        "strategy": de_params.get("strategy", "randtobest1bin"),
        "maxiter": de_params.get("maxiter", 500),
        "popsize": de_params.get("popsize", 15),
        "tol": de_params.get("tol", 0),
        "mutation": de_params.get("mutation", (0.5, 1.5)),
        "recombination": de_params.get("recombination", 0.9),
        "seed": seed,
        "disp": de_params.get("disp", True),
        "polish": de_params.get("polish", True),
        "init": init_pop,
        "callback": stag_callback,
        "workers": workers,
    }
    if workers > 1:
        de_kwargs["updating"] = "deferred"

    return differential_evolution(**de_kwargs)

def adaptive_weights(base_seed, feasible_boxes, n_speakers, min_speaker_distance, forbidden_boxes, listener_positions, test_directions, cost_weights):
    rng_sample = np.random.default_rng(base_seed)
    sample_metrics = []
    for _ in range(10):
        sample = initial_layout(
            feasible_boxes, n_speakers, min_speaker_distance,
            rng_sample, forbidden_boxes
        )
        m = score_layout(sample, listener_positions, test_directions, cost_weights)
        sample_metrics.append(m)
    avg_m = {}
    for key in sample_metrics[0]:
        vals = [m[key] for m in sample_metrics if isinstance(m[key], (int, float))]
        if vals:
            avg_m[key] = float(np.mean(vals))
    effective_weights = compute_adaptive_weights(avg_m, cost_weights)
    print("  Adaptive weights (base -> adapted):")
    for key in cost_weights: #["coverage", "loc_error", "energy_error", "conditioning",
                #"uniformity", "max_gap"]:
        if isinstance(cost_weights[key], (int, float)):
            print(f"    {key}: {cost_weights.get(key, 0):.2f} -> "
                  f"{effective_weights.get(key, 0):.2f}")
    return effective_weights


def optimize_layout_de(
    feasible_boxes: List[Box],
    forbidden_boxes: List[Box],
    n_speakers: int,
    listener_positions: np.ndarray,
    test_directions: np.ndarray,
    cost_weights: Dict[str, float],
    de_params: Dict,
    min_speaker_distance: float,
    seed: Optional[int] = None,
    callback: Optional[Callable] = None,
    convergence_log: Optional[List] = None,
    num_restarts: Optional[int] = None,
    seed_layouts: Optional[List[np.ndarray]] = None,
) -> Tuple[np.ndarray, float, object]:
    """
    Run Differential Evolution with multi-restart to optimize speaker placement.

    Each restart uses a different seed and fresh initial population.
    The best result across all restarts is returned.

    Parameters
    ----------
    seed_layouts : list of (n_speakers, 3) arrays, optional
        Known-good reference layouts to inject into the initial population
        of the first restart.

    Returns
    -------
    best_layout : (n_speakers, 3)
    best_cost : float
    de_result : scipy OptimizeResult
    """
    if num_restarts is None:
        num_restarts = getattr(config, "NUM_RESTARTS", 1)

    bounds = compute_bounds(feasible_boxes, n_speakers)
    base_seed = seed if seed is not None else de_params.get("seed", 42)
    use_adaptive = bool(cost_weights.get("adaptive", False))
    effective_weights = cost_weights

    # Adaptive weighting: evaluate a few random layouts, adjust weights
    if use_adaptive:
        effective_weights = adaptive_weights(base_seed, feasible_boxes, n_speakers, min_speaker_distance, forbidden_boxes, listener_positions, test_directions, cost_weights)

    objective = make_cost_function(
        n_speakers=n_speakers,
        feasible_boxes=feasible_boxes,
        forbidden_boxes=forbidden_boxes,
        listener_positions=listener_positions,
        test_directions=test_directions,
        cost_weights=effective_weights,
        min_speaker_distance=min_speaker_distance,
        feasibility_penalty=config.FEASIBILITY_PENALTY,
        distance_penalty_factor=config.DISTANCE_PENALTY_FACTOR,
        callback_store=convergence_log,
    )

    best_result = None
    best_cost = np.inf
    best_layout = None

    for restart in range(num_restarts):
        restart_seed = base_seed + restart * 1000
        rng = np.random.default_rng(restart_seed)

        pop_count = de_params.get("popsize", 15) * (n_speakers * 3)
        init_pop = generate_feasible_initial_population(
            feasible_boxes,
            forbidden_boxes,
            n_speakers,
            pop_count,
            min_speaker_distance,
            rng,
        )

        # Inject seed layouts into the first restart's population
        if seed_layouts and restart == 0:
            for idx, sl in enumerate(seed_layouts):
                sl_repaired, _ = repair_layout(sl, feasible_boxes, forbidden_boxes)
                init_pop[idx] = flatten_layout(sl_repaired)
            print(f"  Injected {len(seed_layouts)} seed layout(s) into initial population")

        if num_restarts > 1:
            print(f"\n{'='*60}")
            print(f"  Restart {restart + 1}/{num_restarts}  (seed={restart_seed})")
            print(f"{'='*60}")

        result = _run_single_de(
            objective=objective,
            bounds=bounds,
            init_pop=init_pop,
            de_params=de_params,
            seed=restart_seed,
            callback=callback,
            stagnation_limit=getattr(config, "STAGNATION_LIMIT", 20),
        )

        if result.fun < best_cost:
            best_cost = result.fun
            best_result = result
            best_layout = unflatten_layout(result.x, n_speakers)

        if num_restarts > 1:
            print(f"  Restart {restart + 1} best: {result.fun:.6f}  "
                  f"(overall best: {best_cost:.6f})")

    # Final repair to ensure feasibility
    best_layout, _ = repair_layout(best_layout, feasible_boxes, forbidden_boxes)

    return best_layout, best_cost, best_result


def optimize_layout_multistart(
    feasible_boxes: List[Box],
    forbidden_boxes: List[Box],
    n_speakers: int,
    listener_positions: np.ndarray,
    test_directions: np.ndarray,
    cost_weights: Dict[str, float],
    min_speaker_distance: float,
    num_starts: int = 20,
    num_refine: Optional[int] = None,
    seed: Optional[int] = None,
    convergence_log: Optional[List] = None,
    seed_layouts: Optional[List[np.ndarray]] = None,
) -> Tuple[np.ndarray, float, object]:
    """
    Multi-start L-BFGS-B optimization for speaker placement.

    Generates many random feasible layouts, evaluates them all, then runs
    L-BFGS-B local optimization from the best ones. Much faster than DE
    for landscapes with small gradients.

    Parameters
    ----------
    seed_layouts : list of (n_speakers, 3) arrays, optional
        Known-good reference layouts (e.g. Atmos 9.1.6) to include as
        candidates alongside the random ones. These compete on equal
        footing — only used if they score well enough to be refined.

    Returns
    -------
    best_layout : (n_speakers, 3)
    best_cost : float
    best_result : scipy OptimizeResult
    """
    bounds = compute_bounds(feasible_boxes, n_speakers)
    base_seed = seed if seed is not None else 42
    rng = np.random.default_rng(base_seed)
    use_adaptive = bool(cost_weights.get("adaptive", False))
    effective_weights = cost_weights

    # Adaptive weighting: sample a few random layouts to calibrate weights
    # before any phase, so both Phase 1 and Phase 2 use the same scale.
    if use_adaptive:

        effective_weights = adaptive_weights(base_seed, feasible_boxes, n_speakers, min_speaker_distance, forbidden_boxes, listener_positions, test_directions, cost_weights)

    objective = make_cost_function(
        n_speakers=n_speakers,
        feasible_boxes=feasible_boxes,
        forbidden_boxes=forbidden_boxes,
        listener_positions=listener_positions,
        test_directions=test_directions,
        cost_weights=effective_weights,
        min_speaker_distance=min_speaker_distance,
        feasibility_penalty=config.FEASIBILITY_PENALTY,
        distance_penalty_factor=config.DISTANCE_PENALTY_FACTOR,
        callback_store=convergence_log,
    )

    # Phase 1: Generate and evaluate many random layouts
    print(f"  Phase 1: Evaluating {num_starts} random layouts...")
    candidates = []
    for i in range(num_starts):
        layout = initial_layout(
            feasible_boxes, n_speakers, min_speaker_distance,
            np.random.default_rng(base_seed + i), forbidden_boxes
        )
        x = flatten_layout(layout)
        cost = objective(x)
        candidates.append((cost, x))

    # Inject seed layouts (e.g. Atmos reference) alongside random candidates
    if seed_layouts:
        for idx, sl in enumerate(seed_layouts):
            sl_repaired, _ = repair_layout(sl, feasible_boxes, forbidden_boxes)
            x = flatten_layout(sl_repaired)
            cost = objective(x)
            candidates.append((cost, x))
            print(f"  Seed layout {idx+1}: cost={cost:.6f}")

    candidates.sort(key=lambda c: c[0])
    print(f"  Best candidate: {candidates[0][0]:.6f}, "
          f"Worst: {candidates[-1][0]:.6f}")

    # Phase 2: Run L-BFGS-B from the top candidates
    n_refine = min(num_refine if num_refine is not None else 5, num_starts)
    print(f"  Phase 2: Refining top {n_refine} layouts with L-BFGS-B...")

    best_cost = np.inf
    best_result = None
    best_layout = None

    for rank, (init_cost, x0) in enumerate(candidates[:n_refine]):
        result = minimize(
            objective,
            x0,
            method="L-BFGS-B",
            bounds=bounds,
            options={"maxiter": 500, "ftol": 1e-10},
        )
        print(f"    Start {rank+1}: {init_cost:.6f} -> {result.fun:.6f} "
              f"({result.nit} iters)")
        if result.fun < best_cost:
            best_cost = result.fun
            best_result = result
            best_layout = unflatten_layout(result.x, n_speakers)

    # Final repair
    best_layout, _ = repair_layout(best_layout, feasible_boxes, forbidden_boxes)

    return best_layout, best_cost, best_result


def optimize_layout_da(
    feasible_boxes: List[Box],
    forbidden_boxes: List[Box],
    n_speakers: int,
    listener_positions: np.ndarray,
    test_directions: np.ndarray,
    cost_weights: Dict[str, float],
    min_speaker_distance: float,
    maxiter: int = 1000,
    seed: Optional[int] = None,
    convergence_log: Optional[List] = None,
) -> Tuple[np.ndarray, float, object]:
    """
    Dual Annealing optimization for speaker placement.

    Combines generalized simulated annealing for global exploration with
    L-BFGS-B for local refinement. Better than DE for landscapes with
    thin feasible regions and small gradients.

    Returns
    -------
    best_layout : (n_speakers, 3)
    best_cost : float
    da_result : scipy OptimizeResult
    """
    bounds = compute_bounds(feasible_boxes, n_speakers)
    base_seed = seed if seed is not None else 42

    objective = make_cost_function(
        n_speakers=n_speakers,
        feasible_boxes=feasible_boxes,
        forbidden_boxes=forbidden_boxes,
        listener_positions=listener_positions,
        test_directions=test_directions,
        cost_weights=cost_weights,
        min_speaker_distance=min_speaker_distance,
        feasibility_penalty=config.FEASIBILITY_PENALTY,
        distance_penalty_factor=config.DISTANCE_PENALTY_FACTOR,
        callback_store=convergence_log,
    )

    # Generate a good starting point
    rng = np.random.default_rng(base_seed)
    x0 = flatten_layout(
        initial_layout(feasible_boxes, n_speakers, min_speaker_distance,
                       rng, forbidden_boxes)
    )

    print(f"  Running dual annealing (maxiter={maxiter})...")
    result = dual_annealing(
        objective,
        bounds=bounds,
        maxiter=maxiter,
        seed=base_seed,
        x0=x0,
        minimizer_kwargs={"method": "L-BFGS-B", "bounds": bounds},
    )

    best_layout = unflatten_layout(result.x, n_speakers)
    best_layout, _ = repair_layout(best_layout, feasible_boxes, forbidden_boxes)

    return best_layout, result.fun, result


def optimize_layout_cmaes(
    feasible_boxes: List[Box],
    forbidden_boxes: List[Box],
    n_speakers: int,
    listener_positions: np.ndarray,
    test_directions: np.ndarray,
    cost_weights: Dict[str, float],
    min_speaker_distance: float,
    cmaes_params: Optional[Dict] = None,
    num_starts: int = 5,
    seed: Optional[int] = None,
    convergence_log: Optional[List] = None,
    seed_layouts: Optional[List[np.ndarray]] = None,
) -> Tuple[np.ndarray, float, object]:
    """
    CMA-ES optimization for speaker placement.

    Covariance Matrix Adaptation Evolution Strategy — a population-based
    global optimizer that adapts its search distribution. Better than
    L-BFGS-B for non-convex landscapes and better than DE for problems
    with correlated variables.

    Uses multi-start: generates random feasible starting points,
    runs CMA-ES from the best ones.

    Parameters
    ----------
    seed_layouts : list of (n_speakers, 3) arrays, optional
        Known-good reference layouts to include as candidates.

    Returns
    -------
    best_layout : (n_speakers, 3)
    best_cost : float
    best_result : object (CMAEvolutionStrategy outcome)
    """
    if cma is None:
        raise ImportError(
            "CMA-ES requires the 'cma' package. Install with: pip install cma"
        )
    if cmaes_params is None:
        cmaes_params = {}

    bounds = compute_bounds(feasible_boxes, n_speakers)
    lower = [b[0] for b in bounds]
    upper = [b[1] for b in bounds]
    base_seed = seed if seed is not None else 42
    rng = np.random.default_rng(base_seed)
    use_adaptive = bool(cost_weights.get("adaptive", False))
    effective_weights = cost_weights

    # Adaptive weighting
    if use_adaptive:
        effective_weights = adaptive_weights(base_seed, feasible_boxes, n_speakers, min_speaker_distance, forbidden_boxes, listener_positions, test_directions, cost_weights)

    objective = make_cost_function(
        n_speakers=n_speakers,
        feasible_boxes=feasible_boxes,
        forbidden_boxes=forbidden_boxes,
        listener_positions=listener_positions,
        test_directions=test_directions,
        cost_weights=effective_weights,
        min_speaker_distance=min_speaker_distance,
        feasibility_penalty=config.FEASIBILITY_PENALTY,
        distance_penalty_factor=config.DISTANCE_PENALTY_FACTOR,
        callback_store=convergence_log,
    )

    # Generate starting points
    print(f"  Phase 1: Evaluating {num_starts} random starting layouts...")
    candidates = []
    for i in range(num_starts):
        layout = initial_layout(
            feasible_boxes, n_speakers, min_speaker_distance,
            np.random.default_rng(base_seed + i), forbidden_boxes
        )
        x = flatten_layout(layout)
        cost = objective(x)
        candidates.append((cost, x))

    # Inject seed layouts alongside random candidates
    if seed_layouts:
        for idx, sl in enumerate(seed_layouts):
            sl_repaired, _ = repair_layout(sl, feasible_boxes, forbidden_boxes)
            x = flatten_layout(sl_repaired)
            cost = objective(x)
            candidates.append((cost, x))
            print(f"  Seed layout {idx+1}: cost={cost:.6f}")

    candidates.sort(key=lambda c: c[0])
    print(f"  Best candidate: {candidates[0][0]:.6f}, Worst: {candidates[-1][0]:.6f}")

    # CMA-ES parameters
    sigma0 = cmaes_params.get("sigma0", 0.3)
    maxiter = cmaes_params.get("maxiter", 500)
    popsize = cmaes_params.get("popsize", None)
    tolx = cmaes_params.get("tolx", 1e-6)
    tolfun = cmaes_params.get("tolfun", 1e-8)

    n_refine = min(3, num_starts)
    best_cost = np.inf
    best_result = None
    best_layout = None

    print(f"  Phase 2: Running CMA-ES from top {n_refine} layouts...")
    for rank, (init_cost, x0) in enumerate(candidates[:n_refine]):
        opts = {
            "maxiter": maxiter,
            "bounds": [lower, upper],
            "seed": base_seed + rank * 100,
            "tolx": tolx,
            "tolfun": tolfun,
            "verbose": -1,
        }
        if popsize is not None:
            opts["popsize"] = popsize

        es = cma.CMAEvolutionStrategy(x0, sigma0, opts)

        while not es.stop():
            solutions = es.ask()
            fitnesses = [objective(s) for s in solutions]
            es.tell(solutions, fitnesses)

        final_cost = es.result.fbest
        final_x = es.result.xbest
        print(f"    Start {rank+1}: {init_cost:.6f} -> {final_cost:.6f} "
              f"({es.result.iterations} iters, {es.result.evaluations} evals)")

        if final_cost < best_cost:
            best_cost = final_cost
            best_result = es.result
            best_layout = unflatten_layout(final_x, n_speakers)

    # Final repair
    best_layout, _ = repair_layout(best_layout, feasible_boxes, forbidden_boxes)

    return best_layout, best_cost, best_result
