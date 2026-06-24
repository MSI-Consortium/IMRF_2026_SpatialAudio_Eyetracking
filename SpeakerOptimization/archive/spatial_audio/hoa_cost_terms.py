# hoa_cost_terms.py

import numpy as np
import math
from typing import Sequence, Dict, Tuple
from ..geometry.geometry_utils import clamp01, safe_unit, speaker_dirs_and_distances, azel_to_xyz


EPS = 1e-12

def normalized_squared_angle(u: np.ndarray, v: np.ndarray) -> float:
    """
    Normalized squared angular error:
        (angle(u, v) / pi)^2
    in [0, 1].
    """
    ang = angle_between_unit(u, v)
    return clamp01((ang / math.pi) ** 2)


def angle_between_unit(u: np.ndarray, v: np.ndarray) -> float:
    """
    Angle between two vectors in radians.
    Returns value in [0, pi].
    """
    uu = safe_unit(u)
    vv = safe_unit(v)
    dot = float(np.clip(np.dot(uu, vv), -1.0, 1.0))
    return math.acos(dot)

def squash_nonnegative(x: float) -> float:
    """
    Map any nonnegative scalar to [0, 1) monotonically.
    Useful when a natural finite upper bound is unclear.
    """
    if x <= 0:
        return 0.0
    return float(x / (1.0 + x))

def surrogate_directional_gains(
    source_dir_unit: np.ndarray,
    spk_dirs: np.ndarray,
    spk_dists: np.ndarray,
    gain_sharpness: float = 4.0,
    distance_power: float = 1.0,
) -> np.ndarray:
    """
    Compute a simple surrogate gain vector for a desired source direction.

    This is NOT true VBAP/ALLRAD/HOA decoding. It is a physically motivated
    placeholder that prefers speakers aligned with the source direction and
    mildly penalizes greater distance.

    g_i ~ max(0, dot(s_i, u))^gain_sharpness / dist_i^distance_power

    Then normalized so max gain <= 1 and sum(g^2) = 1 if possible.

    Returns
    -------
    gains : (N,) array, nonnegative
    """
    u = safe_unit(source_dir_unit)
    dots = np.maximum(0.0, spk_dirs @ u)
    g = np.power(dots, gain_sharpness)

    if distance_power > 0:
        g = g / np.power(np.maximum(spk_dists, EPS), distance_power)

    if np.all(g < EPS):
        # Fallback to nearest aligned-ish speaker:
        idx = int(np.argmax(spk_dirs @ u))
        g = np.zeros_like(g)
        g[idx] = 1.0
        return g

    # Normalize energy to 1 so P/E statistics are comparable across directions.
    energy = float(np.sum(g ** 2))
    if energy > EPS:
        g = g / math.sqrt(energy)

    # Safety clamp to keep gains bounded.
    g = np.clip(g, 0.0, 1.0)
    return g


def compute_rV_rE_P_E(
    gains: np.ndarray,
    spk_dirs: np.ndarray,
) -> Tuple[np.ndarray, np.ndarray, float, float]:
    """
    Compute surrogate velocity vector rV, energy vector rE,
    pressure-like scalar P, and energy scalar E.

    Definitions used here:
        P  = sum_i g_i
        E  = sum_i g_i^2
        rV = (sum_i g_i * s_i) / sum_i g_i
        rE = (sum_i g_i^2 * s_i) / sum_i g_i^2

    Returns
    -------
    rV : (3,) array
    rE : (3,) array
    P  : float
    E  : float
    """
    g = np.asarray(gains, dtype=float)
    s = np.asarray(spk_dirs, dtype=float)

    P = float(np.sum(g))
    E = float(np.sum(g ** 2))

    if P > EPS:
        rV = np.sum(g[:, None] * s, axis=0) / P
    else:
        rV = np.zeros(3, dtype=float)

    if E > EPS:
        rE = np.sum((g ** 2)[:, None] * s, axis=0) / E
    else:
        rE = np.zeros(3, dtype=float)

    return rV, rE, P, E


def hoa_subterm_weights(weights: Dict[str, float]) -> Dict[str, float]:
    """Extract HOA subterm weights with sensible defaults."""
    return {
        "e_rV_ang": float(weights.get("rV_ang", 1.0)),
        "e_rV_mag": float(weights.get("rV_mag", 0.1)),
        "e_rE_ang": float(weights.get("rE_ang", 1.0)),
        "e_rE_mag": float(weights.get("hoa_rE_mag", 0.1)),
        "e_match":  float(weights.get("hoa_match", 0.1)),
        "e_gain":   float(weights.get("hoa_gain", 0.1)),
    }


def score_hoa_for_listener(
    speaker_positions: Sequence[Sequence[float]],
    listener_position: Sequence[float],
    test_positions: Sequence[Sequence[float]],
    weights: Dict[str, float],
) -> Dict[str, float]:
    """
    Compute J_hoa and its subterms for a single listener position.
    All subterms and J_hoa are normalized to [0, 1].
    """
    if len(speaker_positions) == 0:
        raise ValueError("speaker_positions is empty.")
    if len(test_positions) == 0:
        raise ValueError("test_positions is empty.")

    gain_sharpness = weights["gain_sharpness"]
    distance_power = weights["distance_power"]

    spk_dirs, spk_dists = speaker_dirs_and_distances(speaker_positions, listener_position)

    rV_ang_terms = []
    rV_mag_terms = []
    rE_ang_terms = []
    rE_mag_terms = []
    match_terms = []
    P_vals = []
    E_vals = []

    for test_pos in test_positions:
        u = safe_unit(np.array(test_pos) - np.array(listener_position))

        gains = surrogate_directional_gains(
            source_dir_unit=u,
            spk_dirs=spk_dirs,
            spk_dists=spk_dists,
            gain_sharpness=gain_sharpness,
            distance_power=distance_power,
        )

        rV, rE, P, E = compute_rV_rE_P_E(gains, spk_dirs)

        rV_hat = safe_unit(rV, fallback=u)
        rE_hat = safe_unit(rE, fallback=u)

        # e_rV_ang = mean angle(û, r̂V)^2, normalized to [0,1]
        rV_ang_terms.append(normalized_squared_angle(u, rV_hat))

        # e_rV_mag = mean (1 - |rV|)^2, already in [0,1] if |rV| in [0,1]
        rV_mag = np.linalg.norm(rV)
        rV_mag_terms.append(clamp01((1.0 - clamp01(rV_mag)) ** 2))

        # e_rE_ang = mean angle(û, r̂E)^2, normalized to [0,1]
        rE_ang_terms.append(normalized_squared_angle(u, rE_hat))

        # e_rE_mag = mean normalized(1 - |rE|)
        # We use squared deviation like rV, then clamp to [0,1].
        rE_mag = np.linalg.norm(rE)
        rE_mag_terms.append(clamp01((1.0 - clamp01(rE_mag)) ** 2))

        # e_match = mean angle(r̂V, r̂E)^2, normalized to [0,1]
        match_terms.append(normalized_squared_angle(rV_hat, rE_hat))

        P_vals.append(P)
        E_vals.append(E)

    e_rV_ang = float(np.mean(rV_ang_terms))
    e_rV_mag = float(np.mean(rV_mag_terms))
    e_rE_ang = float(np.mean(rE_ang_terms))
    e_rE_mag = float(np.mean(rE_mag_terms))
    e_match = float(np.mean(match_terms))

    # e_gain = var(P over directions) + var(E over directions)
    # Normalize with x/(1+x) to keep in [0,1).
    P_var = float(np.var(P_vals))
    E_var = float(np.var(E_vals))
    e_gain_raw = P_var + E_var
    e_gain = squash_nonnegative(e_gain_raw)

    # subweights = hoa_subterm_weights(weights)

    # Dynamically scale each term (if necessary)
    # For instance, scale the e_gain term to make it more influential
    scaled_e_gain = e_gain * 2.0  # Example scaling factor for e_gain
    scaled_e_rV_ang = e_rV_ang * 1.5  # Increase importance of angle error

    num = (
        weights["rV_ang"] * scaled_e_rV_ang
        + weights["rV_mag"] * e_rV_mag
        + weights["rE_ang"] * e_rE_ang
        + weights["rE_mag"] * e_rE_mag
        + weights["match"] * e_match
        + weights["gain"] * scaled_e_gain
    )

    den = sum(weights.values())

    J_hoa = clamp01(num / den) if den > EPS else 0.0

    return {
        "J_hoa": J_hoa,
        "e_rV_ang": e_rV_ang,
        "e_rV_mag": e_rV_mag,
        "e_rE_ang": e_rE_ang,
        "e_rE_mag": e_rE_mag,
        "e_match": e_match,
        "e_gain": e_gain,
        "P_var_raw": P_var,
        "E_var_raw": E_var,
    }