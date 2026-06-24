"""
Multi-listener VBAP cost function.

Evaluates real VBAP quality at each listener position in a grid,
then aggregates across listeners using configurable strategies
(mean, worst-case, or weighted worst).
"""

import numpy as np
from typing import Dict, List

from ..spatial_audio.vbap import evaluate_vbap_quality

EPS = 1e-12


def compute_adaptive_weights(
    baseline_metrics: Dict[str, float],
    base_weights: Dict[str, float],
) -> Dict[str, float]:
    """
    Compute adaptive cost weights based on how far each metric is from its
    realistic ideal.

    Metrics further from their ideal values get proportionally higher weight,
    focusing optimization pressure where improvement is most needed.

    Uses realistic ideals that account for room geometry constraints:
    - max_gap and loc/energy error have hard floors imposed by the room
      (no floor speakers = permanent lower-hemisphere gap)
    - Coverage ideal remains 1.0 but gets a minimum weight floor to prevent
      the optimizer from abandoning coverage defense

    Parameters
    ----------
    baseline_metrics : dict from score_layout() containing mean_* keys
    base_weights : original weight dict from config

    Returns
    -------
    New weights dict with same keys as base_weights, scaled by gap from ideal.
    """
    # Realistic ideals: account for room geometry constraints.
    # A half-sphere speaker array (walls + ceiling, no floor) cannot achieve
    # max_gap=0 or loc_error=0. These floors prevent the optimizer from
    # over-investing in unreachable targets.
    realistic_ideals = {
        "coverage": 1.0,
        "upper_coverage": 1.0,  # upper hemisphere should reach ~100%
        "loc_error": 0.0,       # rV direction error is ~0 with correct VBAP (by construction)
        "energy_error": 0.02,   # rE angular error floor for well-conditioned triangles
        "rV_mag": 0.01,         # squared deviation from |rV|=1.0
        "rE_mag": 0.05,         # rE magnitude harder to get close to 1.0
        "conditioning": 0.05,
        "uniformity": 0.005,
        "max_gap": 0.20,        # ~36 deg gap is realistic for upper hemisphere with 24 speakers
    }

    gaps = {}
    for key, ideal in realistic_ideals.items():
        if key in ("coverage", "upper_coverage"):
            metric_key = f"mean_{key}"
            measured = baseline_metrics.get(metric_key, 1.0)
            gaps[key] = max(0.0, ideal - measured)  # gap = how far below 1.0
        else:
            measured = baseline_metrics.get(f"mean_mean_{key}", 0.0)
            if measured == 0.0:
                # Try alternate key naming
                alt_keys = {
                    "loc_error": "mean_mean_loc_error",
                    "energy_error": "mean_mean_energy_err",
                    "rV_mag": "mean_mean_rV_mag_error",
                    "rE_mag": "mean_mean_rE_mag_error",
                    "conditioning": "mean_mean_cond",
                    "uniformity": "mean_angular_uniformity",
                    "max_gap": "mean_max_gap",
                }
                measured = baseline_metrics.get(alt_keys.get(key, ""), 0.0)
            gaps[key] = max(0.0, measured - ideal)  # gap = how far above ideal

    gap_values = np.array(list(gaps.values()))
    mean_gap = float(np.mean(gap_values))

    if mean_gap < EPS:
        clean = {k: v for k, v in base_weights.items() if k != "adaptive"}
        return clean

    # Copy all keys except 'adaptive' metadata flag
    adapted = {k: v for k, v in base_weights.items() if k != "adaptive"}
    for key, gap in gaps.items():
        if key in adapted:
            # Scale = gap / mean_gap, clamped to [0.3, 3.0]
            # Narrower range than before to prevent extreme rebalancing
            scale = float(np.clip(gap / mean_gap, 0.3, 3.0))
            adapted[key] = float(base_weights.get(key, 1.0) * scale)

    # Coverage minimum floor: never let coverage drop below 60% of its base
    # weight. Coverage is a hard requirement — once lost, localization is moot.
    cov_base = float(base_weights.get("coverage", 5.0))
    cov_floor = cov_base * 0.6
    if adapted.get("coverage", 0) < cov_floor:
        adapted["coverage"] = cov_floor

    # Scale down spread_penalty proportionally — it compounds with max_gap
    # and shouldn't get a free pass outside the adaptive system
    if "spread_penalty" in adapted and "max_gap" in gaps:
        max_gap_scale = float(np.clip(gaps["max_gap"] / mean_gap, 0.3, 3.0))
        # If max_gap is already heavily weighted, reduce spread to compensate
        if max_gap_scale > 1.5:
            adapted["spread_penalty"] = float(
                base_weights.get("spread_penalty", 2.0) / max_gap_scale
            )

    return adapted


def generate_test_directions(
    n_directions: int,
    min_elevation_deg: float = -90.0,
) -> np.ndarray:
    """
    Generate unit vectors uniformly on the unit sphere using Fibonacci sampling,
    optionally excluding directions below a minimum elevation.

    Parameters
    ----------
    n_directions : int
        Number of directions to sample on the *full* sphere. When filtering
        by elevation, the returned count will be smaller.
    min_elevation_deg : float
        Minimum elevation in degrees. Directions below this are excluded.
        -90 (default) = full sphere, 0 = upper hemisphere only,
        -30 = exclude steep below-horizon directions.

    Returns (M, 3) array of unit vectors, where M <= n_directions.
    """
    if n_directions < 2:
        return np.array([[1.0, 0.0, 0.0]])
    phi = np.pi * (3.0 - np.sqrt(5.0))  # golden angle
    # Over-sample to compensate for filtering, so we get ~n_directions after cut
    if min_elevation_deg > -89.0:
        # Fraction of sphere above min_elevation
        frac = (1.0 - np.sin(np.radians(min_elevation_deg))) / 2.0
        n_sample = int(n_directions / max(frac, 0.1))
    else:
        n_sample = n_directions

    min_z = np.sin(np.radians(min_elevation_deg))
    directions = []
    for i in range(n_sample):
        z = 1 - (i / float(n_sample - 1)) * 2  # z goes from +1 to -1
        if z < min_z:
            continue
        r = np.sqrt(max(0.0, 1 - z * z))
        theta = phi * i
        directions.append([r * np.cos(theta), r * np.sin(theta), z])
    return np.array(directions)


def score_layout(
    speaker_positions: np.ndarray,
    listener_positions: np.ndarray,
    test_directions: np.ndarray,
    weights: Dict[str, float],
) -> Dict[str, float]:
    """
    Full multi-listener cost function for a speaker layout.

    Parameters
    ----------
    speaker_positions : (N, 3)
    listener_positions : (M, 3) grid of listener positions
    test_directions : (K, 3) unit vectors
    weights : dict with keys:
        'coverage', 'loc_error', 'energy_error', 'conditioning',
        'uniformity', 'max_gap', 'distance_penalty',
        'aggregation', 'worst_weight'

    Returns
    -------
    dict with 'total_cost' and per-metric breakdowns
    """
    w_coverage = float(weights.get("coverage", 5.0))
    w_upper_cov = float(weights.get("upper_coverage", 10.0))
    w_loc = float(weights.get("loc_error", 4.0))
    w_energy = float(weights.get("energy_error", 1.0))
    w_energy_var = float(weights.get("energy_var", 1.0))
    w_rV_mag = float(weights.get("rV_mag", 1.0))
    w_rE_mag = float(weights.get("rE_mag", 0.5))
    w_cond = float(weights.get("conditioning", 1.0))
    w_unif = float(weights.get("uniformity", 1.0))
    w_gap = float(weights.get("max_gap", 2.0))
    w_dist = float(weights.get("distance_penalty", 0.5))
    aggregation = weights.get("aggregation", "mean")
    worst_weight = float(weights.get("worst_weight", 0.3))

    speaker_positions = np.asarray(speaker_positions, dtype=float)
    listener_positions = np.asarray(listener_positions, dtype=float)
    if listener_positions.ndim == 1:
        listener_positions = listener_positions.reshape(1, -1)

    # Evaluate at each listener position
    per_listener_costs = []
    all_metrics: List[Dict[str, float]] = []

    for lp in listener_positions:
        m = evaluate_vbap_quality(speaker_positions, lp, test_directions)
        all_metrics.append(m)

        coverage_penalty = 1.0 - m["coverage"]
        upper_cov_penalty = 1.0 - m["upper_coverage"]
        cost = (
            w_coverage * coverage_penalty
            + w_upper_cov * upper_cov_penalty
            + w_loc * m["mean_loc_error"]
            + w_energy * m["mean_energy_err"]
            + w_energy_var * m["energy_var"]
            + w_rV_mag * m["mean_rV_mag_error"]
            + w_rE_mag * m["mean_rE_mag_error"]
            + w_cond * m["mean_cond"]
            + w_unif * m["angular_uniformity"]
            + w_gap * m["upper_max_gap"]
        )
        per_listener_costs.append(cost)

    per_listener_costs = np.array(per_listener_costs)

    # Aggregate across listeners
    if aggregation == "worst":
        spatial_cost = float(np.max(per_listener_costs))
    elif aggregation == "weighted_worst":
        spatial_cost = float(
            (1 - worst_weight) * np.mean(per_listener_costs)
            + worst_weight * np.max(per_listener_costs)
        )
    else:  # 'mean'
        spatial_cost = float(np.mean(per_listener_costs))

    # Distance penalty: penalize speakers far from listener centroid
    center = np.mean(listener_positions, axis=0)
    speaker_dists = np.linalg.norm(speaker_positions - center[None, :], axis=1)
    room_diag = 6.0  # approximate diagonal of 4x2.4x3.7m room
    dist_penalty = float(np.mean(speaker_dists) / room_diag)

    total = float(spatial_cost + w_dist * dist_penalty)

    # Collect mean/worst metrics for reporting
    report = {
        "total_cost": total,
        "spatial_cost": spatial_cost,
        "dist_penalty": dist_penalty,
        "per_listener_costs": per_listener_costs.tolist(),
    }
    for key in all_metrics[0]:
        vals = [m[key] for m in all_metrics]
        report[f"mean_{key}"] = float(np.mean(vals))
        if key in ("coverage", "upper_coverage"):
            report[f"worst_{key}"] = float(np.min(vals))
        else:
            report[f"worst_{key}"] = float(np.max(vals))

    # Worst-case coverage floor penalty: steep cost when any listener
    # drops below the minimum acceptable upper-hemisphere coverage.
    # Uses upper_coverage since that's the achievable target (no floor speakers).
    coverage_floor = float(weights.get("coverage_floor", 0.98))
    coverage_floor_weight = float(weights.get("coverage_floor_weight", 10.0))
    worst_upper_cov = report.get("worst_upper_coverage", 1.0)
    floor_shortfall = max(0.0, coverage_floor - worst_upper_cov)
    floor_penalty = floor_shortfall * coverage_floor_weight
    report["total_cost"] = report["total_cost"] + floor_penalty
    report["coverage_floor_penalty"] = floor_penalty

    return report
