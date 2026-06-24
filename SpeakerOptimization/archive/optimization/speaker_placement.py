import numpy as np
from typing import Optional
from ..geometry.geometry_utils import (point_in_box_union)
from ..geometry.box import Box
from ..config import config


def initial_layout(feasible_boxes, n_speakers, min_speaker_distance, rng, forbidden_boxes):
    """
    Randomly position each speaker and ensure they are at least min_speaker_distance apart
    """
    layout = []
    for _ in range(n_speakers):
        while True:
            box = rng.choice(feasible_boxes)
            candidate = sample_point_in_box(box, rng)
            # Ensure the point is not in any forbidden regions
            if point_in_valid_region(candidate, feasible_boxes, forbidden_boxes):
                # Ensure minimum speaker separation
                if not layout or no_distance_violation(candidate, layout, min_speaker_distance):
                    layout.append(candidate)
                    break

    return np.array(layout)


def perturb_layout_continuous(
    layout, feasible_boxes, forbidden_boxes, step_scale, rng, min_speaker_distance, max_retries=20, jitter_increase=0.1, max_jitter_scale=5
):
    """
    Perturb the layout by applying random jitter to all speakers, ensuring the layout
    remains within the feasible region and respects the forbidden areas and minimum distance.
    If no valid position is found after max_retries, increase jitter and retry.
    """
    new_layout = layout.copy()

    # Apply random jitter to all speakers in all 3 dimensions (first loop)
    for i in range(len(new_layout)):

        # Randomly perturb the speaker position in all three dimensions
        jitter = rng.uniform(-step_scale, step_scale, size=3)
        candidate = new_layout[i] + jitter
        retries = 0
        current_jitter_scale = step_scale

        # Ensure the new position is not inside any forbidden regions
        while (not point_in_valid_region(candidate, feasible_boxes, forbidden_boxes)
               or not no_distance_violation(candidate, new_layout, min_speaker_distance, i)):

            retries += 1
            jitter = rng.uniform(-current_jitter_scale, current_jitter_scale, size=3)
            candidate = new_layout[i]
            candidate += jitter

            # If retries exceed max_retries, increase jitter and retry
            if retries >= max_retries:
                # print("Increasing jitter")
                current_jitter_scale = min(current_jitter_scale + jitter_increase, max_jitter_scale)  # Increase jitter but cap it
                if current_jitter_scale == max_jitter_scale:
                    candidate = None
                    break

        if candidate is None:
            # teleport the speaker to a random location if we can't find a suitable point after jittering
            resample_retries = 0
            while resample_retries < max_retries:
                # Randomly select a feasible box and sample a point
                box = rng.choice(feasible_boxes)
                candidate = sample_point_in_box(box, rng)

                if point_in_valid_region(candidate, feasible_boxes, forbidden_boxes) and no_distance_violation(candidate, new_layout, min_speaker_distance, i):
                    break
                # Ensure the new position is valid and satisfies the minimum distance
                else:
                    resample_retries += 1

            # If resampling fails, print a warning and keep the original position
            if resample_retries >= max_retries:
                print(f"WARNING: Resampling failed for speaker {i}. Keeping original position.")
                continue
        new_layout[i] = candidate
    return new_layout


def point_in_valid_region(point: np.ndarray, feasible_boxes: list[Box], forbidden_boxes: Optional[list[Box]]) -> bool:
    if point_in_box_union(point, feasible_boxes) and not point_in_box_union(point, forbidden_boxes):
        return True
    else:
        return False


def no_distance_violation(test_point, points, min_distance, point_index=None):
    """
    Checks whether the test_point is within min_distance of any other point in points.

    Parameters:
    - test_point (np.array): The point to test (1x3 array).
    - points (np.array): A list of points (Nx3 array).
    - min_distance (float): The minimum allowed distance between points.
    - point_index (optional, int): Index of the point to exclude from the check.

    Returns:
    - bool: True if no point is within min_distance, False otherwise.
    """

    # Calculate the squared min_distance to avoid computing square roots
    min_distance_sq = min_distance ** 2

    # Loop over each point and check distance
    for i, point in enumerate(points):
        # Skip the point at point_index if provided
        if point_index is not None and i == point_index:
            continue

        # Calculate squared distance between test_point and current point
        distance_sq = np.sum((test_point - point) ** 2)

        # If the distance is less than min_distance, return False
        if distance_sq < min_distance_sq:
            return False

    # No violation found
    return True


def sample_point_in_box(
    box: Box, rng: np.random.Generator, forbidden_boxes: Optional[list[Box]] = None
) -> np.ndarray:
    """
    Sample a point uniformly within the box, ensuring it is not within any forbidden regions.

    Parameters:
    - box: The allowed region (Box).
    - rng: Random number generator.
    - forbidden_boxes: List of forbidden regions (boxes). Default is None (no forbidden areas).

    Returns:
    - A sampled point in the allowed region that is not in any forbidden regions.
    """
    if forbidden_boxes is None:
        forbidden_boxes = []

    while True:
        # Sample a random point within the allowed box
        candidate = rng.uniform(box.min_pt, box.max_pt)

        # Check if the point is inside any forbidden regions
        if not point_in_box_union(candidate, forbidden_boxes):
            return candidate