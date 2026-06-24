import numpy as np
from typing import Optional, List, Tuple
from ..geometry.geometry_utils import point_in_box_union
from ..geometry.box import Box


MAX_PLACEMENT_ATTEMPTS = 50_000


def initial_layout(
    feasible_boxes: List[Box],
    n_speakers: int,
    min_speaker_distance: float,
    rng: np.random.Generator,
    forbidden_boxes: Optional[List[Box]] = None,
) -> np.ndarray:
    """Randomly position speakers ensuring min distance and feasibility."""
    if forbidden_boxes is None:
        forbidden_boxes = []
    layout = []
    for spk_idx in range(n_speakers):
        for attempt in range(MAX_PLACEMENT_ATTEMPTS):
            box = rng.choice(feasible_boxes)
            candidate = sample_point_in_box(box, rng)
            if point_in_valid_region(candidate, feasible_boxes, forbidden_boxes):
                if not layout or no_distance_violation(candidate, layout, min_speaker_distance):
                    layout.append(candidate)
                    break
        else:
            raise RuntimeError(
                f"Could not place speaker {spk_idx + 1}/{n_speakers} after "
                f"{MAX_PLACEMENT_ATTEMPTS} attempts. Check feasible regions and "
                f"min_speaker_distance ({min_speaker_distance})."
            )
    return np.array(layout)


def point_in_valid_region(
    point: np.ndarray,
    feasible_boxes: List[Box],
    forbidden_boxes: Optional[List[Box]] = None,
) -> bool:
    """Check if point is in a feasible box and not in any forbidden box."""
    if forbidden_boxes is None:
        forbidden_boxes = []
    return point_in_box_union(point, feasible_boxes) and not point_in_box_union(point, forbidden_boxes)


def no_distance_violation(
    test_point: np.ndarray,
    points,
    min_distance: float,
    point_index: Optional[int] = None,
) -> bool:
    """Return True if test_point is at least min_distance from all other points."""
    min_distance_sq = min_distance ** 2
    for i, point in enumerate(points):
        if point_index is not None and i == point_index:
            continue
        distance_sq = np.sum((test_point - point) ** 2)
        if distance_sq < min_distance_sq:
            return False
    return True


def sample_point_in_box(
    box: Box,
    rng: np.random.Generator,
    forbidden_boxes: Optional[List[Box]] = None,
    max_attempts: int = 10_000,
) -> np.ndarray:
    """Sample a point uniformly within a box, avoiding forbidden regions."""
    if forbidden_boxes is None:
        forbidden_boxes = []
    for _ in range(max_attempts):
        candidate = rng.uniform(box.min_pt, box.max_pt)
        if not point_in_box_union(candidate, forbidden_boxes):
            return candidate
    raise RuntimeError(
        f"Could not sample a valid point in box {box} after {max_attempts} "
        f"attempts. The box may be entirely covered by forbidden regions."
    )


def repair_to_feasible(
    point: np.ndarray,
    feasible_boxes: List[Box],
    forbidden_boxes: List[Box],
) -> np.ndarray:
    """
    Project a point to the nearest feasible location.

    For each feasible box, clamp the point to the box bounds, check it's not
    in a forbidden region, and keep the closest valid result.
    Falls back to the centroid of the largest non-forbidden feasible box.
    """
    best_point = None
    best_dist = np.inf

    for box in feasible_boxes:
        clamped = np.clip(point, box.min_pt, box.max_pt)
        if not point_in_box_union(clamped, forbidden_boxes):
            d = np.linalg.norm(point - clamped)
            if d < best_dist:
                best_dist = d
                best_point = clamped.copy()

    if best_point is not None:
        return best_point

    # Fallback: centroid of largest non-forbidden feasible box
    for box in sorted(feasible_boxes, key=lambda b: b.volume, reverse=True):
        centroid = (box.min_pt + box.max_pt) / 2.0
        if not point_in_box_union(centroid, forbidden_boxes):
            return centroid

    # Ultimate fallback
    return (feasible_boxes[0].min_pt + feasible_boxes[0].max_pt) / 2.0


def generate_feasible_initial_population(
    feasible_boxes: List[Box],
    forbidden_boxes: List[Box],
    n_speakers: int,
    pop_size: int,
    min_speaker_distance: float,
    rng: np.random.Generator,
) -> np.ndarray:
    """
    Generate an initial population of feasible layouts for DE.

    Returns (pop_size, 3 * n_speakers) array where each row is a flattened layout.
    """
    population = []
    for _ in range(pop_size):
        layout = initial_layout(
            feasible_boxes, n_speakers, min_speaker_distance, rng, forbidden_boxes
        )
        population.append(layout.ravel())
    return np.array(population)
