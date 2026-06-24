import numpy as np
from typing import Sequence, Dict, List
from ..geometry.geometry_utils import clamp01, safe_unit

def score_vbap_for_listener(
        speaker_positions: Sequence[Sequence[float]],  # Positions of the speakers
        listener_position: Sequence[float],  # Listener's position
        test_positions: Sequence[Sequence[float]],  # Test positions (3D coordinates)
        weights: Dict[str, float]  # Weights for the cost terms
) -> Dict[str, float]:
    """
    Compute the VBAP-based score for a given layout and test positions.
    The score measures how well the layout reproduces each test direction.
    """
    target_amplitudes = []
    actual_amplitudes = []

    # Step 1: Compute the target amplitudes for each test position (ideal speaker layout)
    for test_position in test_positions:
        # Convert test_position (XYZ) to a unit direction vector relative to the listener
        direction_unit = safe_unit(np.array(test_position) - np.array(listener_position))

        # Calculate the target amplitudes for the ideal setup (desired speaker contributions)
        # Assuming a perfect speaker layout
        target_amplitudes.append(compute_vbap_amplitudes_ideal(speaker_positions, listener_position, direction_unit))

    # Step 2: Compute the actual amplitudes based on the current speaker layout
    for test_position in test_positions:
        # Convert test_position (XYZ) to a unit direction vector relative to the listener
        direction_unit = safe_unit(np.array(test_position) - np.array(listener_position))

        # Calculate the actual amplitudes for the current speaker layout
        actual_amplitudes.append(compute_vbap_amplitudes(speaker_positions, listener_position, direction_unit))

    # Step 3: Calculate the error between target and actual amplitudes
    errors = []
    for target, actual in zip(target_amplitudes, actual_amplitudes):
        error = np.sum(np.square(np.array(target) - np.array(actual)))  # Squared error
        errors.append(error)

    # Step 4: Aggregate the errors and normalize the score
    total_error = np.sum(errors)
    max_possible_error = len(test_positions)  # This could be adjusted based on number of test positions

    # Normalize the error to the range [0, 1]
    J_vbap = clamp01(total_error / max_possible_error)

    return {
        "J_vbap": J_vbap,
        "errors": errors  # Optionally return individual errors for analysis
    }

def compute_vbap_amplitudes_ideal(
        speaker_positions: Sequence[Sequence[float]],
        listener_position: Sequence[float],
        test_direction_unit: np.ndarray
) -> List[float]:
    """
    Compute the ideal VBAP amplitudes for each speaker based on the test direction.
    This function calculates how much each speaker should contribute to the target direction.
    It assumes a perfect configuration of speakers.
    """
    # Step 1: Compute the direction from the listener to each speaker
    speaker_directions = []
    for speaker_position in speaker_positions:
        direction = safe_unit(np.array(speaker_position) - np.array(listener_position))
        speaker_directions.append(direction)

    # Step 2: Compute the VBAP amplitudes by projecting the test direction onto the speaker directions
    amplitudes = []
    for speaker_direction in speaker_directions:
        # Compute the projection of the test direction onto the speaker direction (dot product)
        amplitude = np.dot(speaker_direction, test_direction_unit)
        amplitudes.append(amplitude)

    return amplitudes

def compute_vbap_amplitudes(
        speaker_positions: Sequence[Sequence[float]],
        listener_position: Sequence[float],
        test_direction_unit: np.ndarray
) -> List[float]:
    """
    Compute the VBAP amplitudes for each speaker based on the test direction.
    This function calculates how much each speaker contributes to the target direction
    based on the current speaker layout.
    """
    # Step 1: Compute the direction from the listener to each speaker
    speaker_directions = []
    for speaker_position in speaker_positions:
        direction = safe_unit(np.array(speaker_position) - np.array(listener_position))
        speaker_directions.append(direction)

    # Step 2: Compute the VBAP amplitudes by projecting the test direction onto the speaker directions
    amplitudes = []
    for speaker_direction in speaker_directions:
        # Compute the projection of the test direction onto the speaker direction (dot product)
        amplitude = np.dot(speaker_direction, test_direction_unit)
        amplitudes.append(amplitude)

    return amplitudes