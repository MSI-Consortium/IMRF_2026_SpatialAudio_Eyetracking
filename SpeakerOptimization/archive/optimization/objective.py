# layout_optimization.py

import numpy as np
import math
from typing import Sequence, Dict, Tuple
from ..spatial_audio.hoa_cost_terms import score_hoa_for_listener
from ..geometry.geometry_utils import safe_unit, speaker_dirs_and_distances, azel_to_xyz, clamp01


EPS = 1e-12

def score_vbap_for_listener(
    speaker_positions: Sequence[Sequence[float]],
    listener_position: Sequence[float],
    test_positions: Sequence[Sequence[float]],
    weights: Dict[str, float],
) -> float:
    """
    Placeholder for VBAP cost term.
    Must return value in [0, 1].

    Right now returns 1.0 so it is explicit that this term is unfinished.
    Replace this with your real VBAP metric later.
    """
    _ = speaker_positions, listener_position, test_positions, weights
    return 1.0


def score_regularization(
    speaker_positions: Sequence[Sequence[float]],
    listener_positions: Sequence[Sequence[float]],
    test_directions: Sequence[Tuple[float, float]],
    weights: Dict[str, float],
) -> float:
    """
    Placeholder for regularization term.
    Must return value in [0, 1].

    Right now returns 1.0 as requested.
    """
    _ = speaker_positions, listener_positions, test_directions, weights
    return 1.0


def score_layout(
    speaker_positions: Sequence[Sequence[float]],
    listener_positions: Sequence[Sequence[float]],
    test_positions: Sequence[Sequence[float]],
    weights: Dict[str, float],
    hoa_weights: Dict[str, float]
) -> Dict[str, float]:
    """
    Score a speaker layout.

    Parameters
    ----------
    speaker_positions : list of 3D vectors
    listener_positions : list of 3D vectors
    test_positions : list of 3D vectors
    weights : dict of floats

    Returns
    -------
    dict
        Contains total_cost and individual normalized cost terms.
    """
    if len(speaker_positions) == 0:
        raise ValueError("speaker_positions must not be empty.")
    if len(listener_positions) == 0:
        raise ValueError("listener_positions must not be empty.")
    if len(test_positions) == 0:
        raise ValueError("test_directions must not be empty.")

    # Use the first listener as the nominal reference position.
    # Off-center listeners are all provided listener_positions.
    nominal_listener = listener_positions[0]

    # --- J_hoa at nominal listener
    hoa_nominal = score_hoa_for_listener(
        speaker_positions=speaker_positions,
        listener_position=nominal_listener,
        test_positions=test_positions,
        weights=hoa_weights,
    )
    J_hoa = hoa_nominal["J_hoa"]

    # --- J_vbap at nominal listener (placeholder)
    J_vbap = clamp01(score_vbap_for_listener(
        speaker_positions=speaker_positions,
        listener_position=nominal_listener,
        test_positions=test_positions,
        weights=weights,
    ))

    # --- J_off = mean over p in P_off [ J_hoa(p) + lambda * J_vbap(p) ]
    off_lambda = float(weights.get("off_lambda", 1.0))
    off_terms = []

    off_hoa_vals = []
    off_vbap_vals = []

    for lp in listener_positions:
        hoa_lp = score_hoa_for_listener(
            speaker_positions=speaker_positions,
            listener_position=lp,
            test_positions=test_positions,
            weights=hoa_weights,
        )["J_hoa"]

        vbap_lp = clamp01(score_vbap_for_listener(
            speaker_positions=speaker_positions,
            listener_position=lp,
            test_positions=test_positions,
            weights=weights,
        ))

        # raw form requested: J_hoa(p) + lambda * J_vbap(p)
        # normalize to [0,1] by dividing by (1 + lambda) when lambda >= 0
        if off_lambda < 0:
            raise ValueError("weights['off_lambda'] must be nonnegative.")

        combined = (hoa_lp + off_lambda * vbap_lp) / (1.0 + off_lambda + EPS)
        combined = clamp01(combined)

        off_terms.append(combined)
        off_hoa_vals.append(hoa_lp)
        off_vbap_vals.append(vbap_lp)

    J_off = float(np.mean(off_terms))

    # --- J_reg (placeholder)
    J_reg = clamp01(score_regularization(
        speaker_positions=speaker_positions,
        listener_positions=listener_positions,
        test_directions=test_positions,
        weights=weights,
    ))

    # --- Total weighted cost
    w_vbap = float(weights.get("vbap", 1.0))
    w_hoa = float(weights.get("hoa", 1.0))
    w_off = float(weights.get("off", 1.0))
    w_reg = float(weights.get("reg", 1.0))

    numerator = (
        w_vbap * J_vbap
        + w_hoa * J_hoa
        + w_off * J_off
        + w_reg * J_reg
    )
    denominator = w_vbap + w_hoa + w_off + w_reg

    total_cost = clamp01(numerator / denominator) if denominator > EPS else 0.0

    return {
        "total_cost": total_cost,
        "J_vbap": J_vbap,
        "J_hoa": J_hoa,
        "J_off": J_off,
        "J_reg": J_reg,

        # HOA nominal subterms
        "e_rV_ang": hoa_nominal["e_rV_ang"],
        "e_rV_mag": hoa_nominal["e_rV_mag"],
        "e_rE_ang": hoa_nominal["e_rE_ang"],
        "e_rE_mag": hoa_nominal["e_rE_mag"],
        "e_match": hoa_nominal["e_match"],
        "e_gain": hoa_nominal["e_gain"],

        # Optional diagnostics
        "off_mean_J_hoa": float(np.mean(off_hoa_vals)),
        "off_mean_J_vbap": float(np.mean(off_vbap_vals)),
        "nominal_P_var_raw": hoa_nominal["P_var_raw"],
        "nominal_E_var_raw": hoa_nominal["E_var_raw"],
    }