from dataclasses import dataclass
from typing import Optional

import numpy as np


Vec3 = tuple[float, float, float]


@dataclass(frozen=True)
class Box:
    """
    Axis-aligned box representing a rectangular solid (in 3D space).
    This is used for defining allowed or forbidden regions in the room.
    """
    min_corner: Vec3
    max_corner: Vec3
    label: str = ""

    def __post_init__(self):
        """
        Ensure that the box is well-defined (max_corner > min_corner).
        """
        min_pt = np.asarray(self.min_corner, dtype=float)
        max_pt = np.asarray(self.max_corner, dtype=float)
        if np.any(max_pt <= min_pt):
            raise ValueError(f"Invalid box {self.label}: max_corner must be > min_corner in all dims.")

    @property
    def min_pt(self) -> np.ndarray:
        """
        Return the minimum corner as a numpy array.
        """
        return np.asarray(self.min_corner, dtype=float)

    @property
    def max_pt(self) -> np.ndarray:
        """
        Return the maximum corner as a numpy array.
        """
        return np.asarray(self.max_corner, dtype=float)

    @property
    def size(self) -> np.ndarray:
        """
        Return the size (differences in coordinates) along each dimension.
        """
        return self.max_pt - self.min_pt

    @property
    def volume(self) -> float:
        """
        Return the volume of the box (product of sizes).
        """
        return float(np.prod(self.size))

    def contains_point(self, point: Vec3, tol: float = 1e-12) -> bool:
        """
        Check if the given point lies inside the box, with a tolerance.
        """
        point = np.asarray(point, dtype=float)
        return np.all(point >= self.min_pt - tol) and np.all(point <= self.max_pt + tol)

    def ray_intersects(self, origin: Vec3, direction: Vec3, tol: float = 1e-12) -> bool:
        """
        Return True if the ray p(t) = origin + t * direction, with t >= 0,
        intersects this axis-aligned box.

        Parameters
        ----------
        origin : Vec3
            Ray origin.
        direction : Vec3
            Ray direction. Does not need to be normalized.
        tol : float
            Numerical tolerance for handling near-zero direction components.

        Returns
        -------
        bool
            True if the ray hits the box, otherwise False.
        """
        origin = np.asarray(origin, dtype=float)
        direction = np.asarray(direction, dtype=float)

        if origin.shape != (3,) or direction.shape != (3,):
            raise ValueError("origin and direction must be length-3 vectors.")

        # Degenerate "ray" with zero direction: treat as point containment
        if np.all(np.abs(direction) < tol):
            return self.contains_point(origin, tol=tol)

        tmin = -np.inf
        tmax = np.inf

        for i in range(3):
            if abs(direction[i]) < tol:
                # Ray is parallel to slab in this dimension.
                # It must already lie within the slab to have any intersection.
                if origin[i] < self.min_pt[i] - tol or origin[i] > self.max_pt[i] + tol:
                    return False
            else:
                t1 = (self.min_pt[i] - origin[i]) / direction[i]
                t2 = (self.max_pt[i] - origin[i]) / direction[i]

                t_near = min(t1, t2)
                t_far = max(t1, t2)

                tmin = max(tmin, t_near)
                tmax = min(tmax, t_far)

                if tmin > tmax:
                    return False

        # For a ray, intersection must occur at t >= 0
        return tmax >= max(tmin, 0.0)

    def intersection(self, other: 'Box') -> Optional['Box']:
        """
        Compute the intersection of this box with another box.
        If there is no intersection, return None.
        """
        min_corner = np.maximum(self.min_pt, other.min_pt)
        max_corner = np.minimum(self.max_pt, other.max_pt)

        # If there is no intersection, return None
        if np.any(max_corner <= min_corner):
            return None

        return Box(tuple(min_corner), tuple(max_corner), label=f"intersection({self.label}, {other.label})")

    def union(self, other: 'Box') -> 'Box':
        """
        Return the union of this box and another box.
        This is a box that contains both the current and the other box.
        """
        min_corner = np.minimum(self.min_pt, other.min_pt)
        max_corner = np.maximum(self.max_pt, other.max_pt)
        return Box(tuple(min_corner), tuple(max_corner), label=f"union({self.label}, {other.label})")