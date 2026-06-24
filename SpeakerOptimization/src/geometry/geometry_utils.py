import numpy as np
import math
from typing import List, Sequence, Tuple
from ..geometry.box import Box


def point_in_box(point: np.ndarray, box: Box, tol: float = 1e-12) -> bool:
    """Check if a point is within the bounds of a given box."""
    return np.all(point >= box.min_pt - tol) and np.all(point <= box.max_pt + tol)


def point_in_box_union(point: np.ndarray, boxes: List[Box], tol: float = 1e-12) -> bool:
    """Check if a point is in any of the feasible boxes."""
    return any(point_in_box(point, box, tol) for box in boxes)


def fibonacci_sphere(samples: int, listener_position: np.ndarray) -> np.ndarray:
    """
    Generate `samples` points uniformly distributed on the surface of a unit sphere
    centered at `listener_position` using the Fibonacci method.

    Parameters:
    - samples: The number of directions (points) to generate.
    - listener_position: (3,) array, center of the sphere.

    Returns:
    - A numpy array of shape (samples, 3), where each row is a point on the
      unit sphere offset by listener_position.
    """
    phi = np.pi * (3.0 - np.sqrt(5.0))  # Golden angle in radians
    lp = np.asarray(listener_position, dtype=float)

    points = []
    for i in range(samples):
        y = 1 - (i / float(samples - 1)) * 2  # y goes from 1 to -1
        radius = np.sqrt(1 - y * y)  # Radius at y

        theta = phi * i

        x = radius * np.cos(theta)
        z = radius * np.sin(theta)

        points.append(np.array([x, y, z]) + lp)

    return np.array(points)

EPS = 1e-12


def as_vec3(x: Sequence[float]) -> np.ndarray:
    """Convert input to a float numpy array of shape (3,)."""
    arr = np.asarray(x, dtype=float).reshape(3)
    return arr


def clamp01(x: float) -> float:
    """Clamp scalar to [0, 1]."""
    return float(max(0.0, min(1.0, x)))


def safe_unit(v: np.ndarray, fallback: np.ndarray | None = None) -> np.ndarray:
    """Return unit vector, or fallback / zeros if norm is tiny."""
    n = np.linalg.norm(v)
    if n < EPS:
        if fallback is not None:
            return np.asarray(fallback, dtype=float).reshape(3)
        return np.zeros(3, dtype=float)
    return v / n


def azel_to_xyz(az_deg: float, el_deg: float) -> np.ndarray:
    """
    Convert azimuth/elevation in degrees to 3D unit vector.

    Convention:
        azimuth 0 deg   -> +x
        azimuth 90 deg  -> +y
        elevation 90 deg -> +z
    """
    az = math.radians(az_deg)
    el = math.radians(el_deg)
    x = math.cos(el) * math.cos(az)
    y = math.cos(el) * math.sin(az)
    z = math.sin(el)
    return np.array([x, y, z], dtype=float)


def speaker_dirs_and_distances(
    speaker_positions: Sequence[Sequence[float]],
    listener_position: Sequence[float],
) -> Tuple[np.ndarray, np.ndarray]:
    """
    Compute unit directions and distances from listener to each speaker.

    Returns
    -------
    spk_dirs : (N, 3) array
    spk_dists : (N,) array
    """
    lp = as_vec3(listener_position)
    spk_dirs = []
    spk_dists = []

    for s in speaker_positions:
        sv = as_vec3(s)
        rel = sv - lp
        dist = np.linalg.norm(rel)
        if dist < EPS:
            # Extremely pathological: speaker at listener position.
            # Use zero direction and tiny distance protection.
            spk_dirs.append(np.zeros(3))
            spk_dists.append(EPS)
        else:
            spk_dirs.append(rel / dist)
            spk_dists.append(dist)

    return np.asarray(spk_dirs, dtype=float), np.asarray(spk_dists, dtype=float)