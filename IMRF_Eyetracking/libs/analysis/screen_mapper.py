#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
AprilTag-based gaze-to-screen mapper.

Detects AprilTag markers in Neon scene-camera frames, computes a homography
from scene-camera pixel coordinates to experiment-screen pixel coordinates,
and transforms raw gaze points through that homography.

Supports any number of markers (4 at screen corners by default, or a custom
``marker_positions`` dictionary mapping tag IDs to known screen-pixel
locations).  With >4 markers, RANSAC is used for robust estimation.

Dependencies:
    pip install pupil-apriltags opencv-python
"""

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from typing import Optional

import cv2
import numpy as np

try:
    from pupil_apriltags import Detector as AprilTagDetector
except ImportError:
    AprilTagDetector = None  # type: ignore[assignment, misc]

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

@dataclass
class ScreenMapperConfig:
    """Configuration for the ScreenMapper.

    Attributes:
        screen_size:         (width, height) of the experiment monitor in px.
        marker_positions:    Mapping of ``{tag_id: (screen_x, screen_y)}``
                             for every AprilTag on the monitor.  When
                             ``None``, four corner markers are assumed using
                             *tag_ids* and *marker_margin_px*.
        tag_ids:             (Legacy / convenience) AprilTag IDs in order
                             [TL, TR, BR, BL].  Only used when
                             *marker_positions* is ``None``.
        marker_margin_px:    Distance in pixels from the screen edge to the
                             centre of each corner marker.  Matches the
                             margin used by ``MarkerArray`` in PsychoPy.
                             Use :func:`compute_marker_margin_px` to derive
                             this from your physical setup.  ``0`` means
                             markers are at the exact screen corners.
        tag_family:          AprilTag family string (e.g. ``"tag36h11"``).
        on_screen_margin_px: Extra tolerance around the screen rectangle
                             when checking whether a gaze point counts as
                             "on screen".
        min_markers:         Minimum detected markers needed to compute a
                             homography.
    """
    screen_size: tuple[int, int] = (1920, 1080)
    marker_positions: Optional[dict[int, tuple[float, float]]] = None
    tag_ids: list[int] = field(default_factory=lambda: [10, 11, 12, 13])
    marker_margin_px: float = 0.0
    tag_family: str = "tag36h11"
    on_screen_margin_px: float = 20.0
    min_markers: int = 3


def compute_marker_margin_px(
    screen_width_px: int,
    monitor_width_cm: float,
    viewing_distance_cm: float,
    marker_size_deg: float = 4.0,
    padding_deg: float = 0.8,
) -> float:
    """Compute the pixel margin from the MarkerArray physical setup.

    This matches the layout computed by
    ``paradigms/lib/markers.py::MarkerArray``.

    Args:
        screen_width_px:     Horizontal resolution (e.g. 3840).
        monitor_width_cm:    Physical screen width in cm (e.g. 72.53).
        viewing_distance_cm: Participant distance in cm (e.g. 57.0).
        marker_size_deg:     AprilTag size in degrees (default 4.0).
        padding_deg:         White border padding in degrees (default 0.8).

    Returns:
        Margin in pixels from screen edge to marker centre.
    """
    import math
    margin_deg = (marker_size_deg + 2 * padding_deg) / 2.0
    margin_cm = 2.0 * viewing_distance_cm * math.tan(math.radians(margin_deg / 2.0))
    px_per_cm = screen_width_px / monitor_width_cm
    return margin_cm * px_per_cm


# ---------------------------------------------------------------------------
# ScreenMapper
# ---------------------------------------------------------------------------

class ScreenMapper:
    """Detects AprilTags and maps scene-camera gaze to screen coordinates.

    Supports 4 corner markers (default) or arbitrary N-marker layouts.
    With >4 detected markers, ``cv2.findHomography`` uses RANSAC for a
    robust fit.

    """

    def __init__(self, config: Optional[ScreenMapperConfig] = None):
        if AprilTagDetector is None:
            raise ImportError(
                "pupil-apriltags is required for screen mapping. "
                "Install with:  pip install pupil-apriltags"
            )

        self.config = config or ScreenMapperConfig()
        self._detector = AprilTagDetector(
            families=self.config.tag_family,
            nthreads=1,          # keep at 1 — safe inside QThread / subprocess
            quad_decimate=1.0,
            quad_sigma=0.0,
            refine_edges=True,
            decode_sharpening=0.25,
        )

        # Build the destination-point lookup: tag_id → screen (x, y)
        self._dst_corners: dict[int, np.ndarray] = (
            self._build_marker_positions()
        )

        # Cache for the most recently computed valid homography
        self._last_H: Optional[np.ndarray] = None
        self._frames_since_detection: int = 0

    # ------------------------------------------------------------------
    # Internal helpers
    # ------------------------------------------------------------------

    def _build_marker_positions(self) -> dict[int, np.ndarray]:
        """Create the ``{tag_id: screen_xy}`` lookup."""
        if self.config.marker_positions is not None:
            return {
                tid: np.asarray(pos, dtype=np.float64)
                for tid, pos in self.config.marker_positions.items()
            }

        # 4-corner mode: markers are inset by marker_margin_px from edges
        w, h = self.config.screen_size
        m = self.config.marker_margin_px
        ids = self.config.tag_ids
        return {
            ids[0]: np.array([m,     m    ]),   # TL
            ids[1]: np.array([w - m, m    ]),   # TR
            ids[2]: np.array([w - m, h - m]),   # BR
            ids[3]: np.array([m,     h - m]),   # BL
        }

    # ------------------------------------------------------------------
    # Detection
    # ------------------------------------------------------------------

    def detect_markers(self, gray_frame: np.ndarray) -> dict[int, np.ndarray]:
        """Detect AprilTag markers in a grayscale scene frame.

        Args:
            gray_frame: ``(H, W)`` uint8 grayscale image.

        Returns:
            Dictionary mapping each detected ``tag_id`` to its 4 corner
            coordinates as a ``(4, 2)`` float array (in scene-camera pixels).
        """
        if gray_frame.ndim != 2:
            raise ValueError(
                f"Expected grayscale (H, W) image, got shape {gray_frame.shape}"
            )

        detections = self._detector.detect(gray_frame)

        result: dict[int, np.ndarray] = {}
        for det in detections:
            if det.tag_id in self._dst_corners:
                result[det.tag_id] = np.asarray(det.corners, dtype=np.float64)

        return result

    # ------------------------------------------------------------------
    # Homography
    # ------------------------------------------------------------------

    def compute_homography(
        self,
        detections: dict[int, np.ndarray],
    ) -> Optional[np.ndarray]:
        """Compute a scene-camera -> screen homography from detected markers.

        Uses the **centre** of each detected tag (average of its 4 corners)
        mapped to the known screen positions.

        * >=4 points:  ``cv2.findHomography`` (RANSAC when >4)
        * 3 points:    ``cv2.getAffineTransform`` promoted to 3x3

        Args:
            detections: Output of :meth:`detect_markers`.

        Returns:
            3x3 homography matrix, or ``None`` if fewer than
            ``config.min_markers`` tags were found.
        """
        if len(detections) < self.config.min_markers:
            logger.debug(
                "Only %d markers detected (need %d), skipping homography.",
                len(detections), self.config.min_markers,
            )
            return None

        src_pts: list[np.ndarray] = []
        dst_pts: list[np.ndarray] = []

        for tag_id, corners in detections.items():
            centre = corners.mean(axis=0)
            src_pts.append(centre)
            dst_pts.append(self._dst_corners[tag_id])

        src = np.asarray(src_pts, dtype=np.float64)
        dst = np.asarray(dst_pts, dtype=np.float64)

        H: Optional[np.ndarray] = None

        if len(src) > 4:
            # RANSAC for robust estimation with >4 points
            H, _mask = cv2.findHomography(src, dst, method=cv2.RANSAC,
                                            ransacReprojThreshold=5.0)
        elif len(src) == 4:
            H, _mask = cv2.findHomography(src, dst, method=0)
        elif len(src) == 3:
            src_3 = src[:3].astype(np.float32)
            dst_3 = dst[:3].astype(np.float32)
            M = cv2.getAffineTransform(src_3, dst_3)
            if M is not None:
                H = np.vstack([M, [0.0, 0.0, 1.0]])

        if H is not None:
            self._last_H = H
            self._frames_since_detection = 0

        return H

    def get_cached_homography(self) -> Optional[np.ndarray]:
        """Return the last successfully computed homography (may be stale)."""
        return self._last_H

    # ------------------------------------------------------------------
    # Gaze transformation
    # ------------------------------------------------------------------

    @staticmethod
    def map_gaze(
        gaze_xy: np.ndarray,
        H: np.ndarray,
    ) -> np.ndarray:
        """Transform gaze points from scene-camera coords to screen coords.

        Args:
            gaze_xy: ``(N, 2)`` array of gaze positions in scene-camera
                     pixels.
            H:       3x3 homography matrix (scene -> screen).

        Returns:
            ``(N, 2)`` array of gaze positions in screen-pixel coordinates.
        """
        if gaze_xy.ndim == 1:
            gaze_xy = gaze_xy.reshape(1, 2)

        pts = gaze_xy.reshape(-1, 1, 2).astype(np.float64)
        mapped = cv2.perspectiveTransform(pts, H)
        return mapped.reshape(-1, 2)

    def is_on_screen(self, screen_xy: np.ndarray) -> np.ndarray:
        """Return a boolean mask indicating which points lie on the screen.

        Args:
            screen_xy: ``(N, 2)`` array of screen-pixel coordinates.

        Returns:
            ``(N,)`` boolean array.
        """
        w, h = self.config.screen_size
        m = self.config.on_screen_margin_px
        x, y = screen_xy[:, 0], screen_xy[:, 1]
        return (
            (x >= -m) & (x <= w + m) &
            (y >= -m) & (y <= h + m)
        )

    # ------------------------------------------------------------------
    # Convenience: detect + compute in one call
    # ------------------------------------------------------------------

    def process_frame(
        self,
        gray_frame: np.ndarray,
        *,
        use_cache: bool = True,
    ) -> Optional[np.ndarray]:
        """Detect markers and return a homography (or cached fallback).

        Args:
            gray_frame: Grayscale scene frame.
            use_cache:  If detection fails and *use_cache* is True, return
                        the last good homography instead of ``None``.

        Returns:
            3x3 homography matrix, or ``None`` if unavailable.
        """
        detections = self.detect_markers(gray_frame)
        H = self.compute_homography(detections)

        if H is not None:
            return H

        self._frames_since_detection += 1

        if use_cache and self._last_H is not None:
            logger.debug(
                "Using cached homography (stale for %d frames).",
                self._frames_since_detection,
            )
            return self._last_H

        return None
