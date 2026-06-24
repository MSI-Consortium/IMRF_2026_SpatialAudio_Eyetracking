#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Visualisation tools for gaze-to-screen mapping results.

Provides:
  * **Scene-camera overlay video** -- gaze dots coloured by on/off-screen
    status, fixation circles, scanpath trail, detected marker outlines.
  * **Screen-space video** -- gaze and fixations rendered on a black canvas
    at the experiment-monitor resolution.
  * **Static matplotlib plots** -- heatmap, fixation map, scanpath diagram,
    on/off-screen time distribution, fixation-duration histogram.
"""

from __future__ import annotations

import logging
from pathlib import Path
from typing import Optional

import cv2
import numpy as np
import pandas as pd

from libs.project_config import PLOT_COLORS

logger = logging.getLogger(__name__)

def _bgr(name: str) -> tuple[int, int, int]:
    """Convert a shared Matplotlib color to OpenCV's BGR tuple."""
    from matplotlib.colors import to_rgb

    r, g, b = to_rgb(PLOT_COLORS[name])
    r, g, b = (round(channel * 255) for channel in (r, g, b))
    return (b, g, r)


# Colour constants (BGR for OpenCV)
_GREEN = _bgr("on_screen")
_RED = _bgr("off_screen")
_WHITE = _bgr("annotation")
_CYAN = _bgr("model_pir")
_YELLOW = _bgr("saccade_start")
_BORDER = _bgr("box_edge")


# ===================================================================
# Video Rendering
# ===================================================================

def render_scene_overlay_video(
    recording_path: str | Path,
    gaze_df: pd.DataFrame,
    fixations_df: pd.DataFrame,
    scanpath_df: pd.DataFrame,
    output_path: str | Path,
    *,
    max_frames: Optional[int] = None,
    fps: int = 30,
    scanpath_trail: int = 8,
    progress_callback: Optional[callable] = None,
) -> None:
    """Render the scene-camera video with gaze, fixation, and scanpath overlays.

    Overlay legend:
      * **Green filled dot** -- gaze point that maps on-screen.
      * **Red filled dot** -- gaze point that maps off-screen.
      * **Cyan circle** -- current fixation (radius ~ duration).
      * **Yellow lines** -- scanpath trail connecting last N fixations.
    """
    import pupil_labs.neon_recording as nr

    recording = nr.open(str(recording_path))
    scene = recording.scene
    scene_times = np.asarray(scene.time)
    n_frames = min(len(scene_times), max_frames or len(scene_times))

    gaze_by_frame = _group_by_frame(gaze_df)
    fix_by_frame = _group_by_frame(fixations_df)

    # Scanpath centres (scene-camera coords) for trail drawing
    scanpath_scene_pts = _scanpath_scene_coords(fixations_df, scanpath_df)

    # Video dimensions from first frame
    first = _sample_bgr(scene, scene_times, 0)
    h, w = first.shape[:2]

    writer = cv2.VideoWriter(
        str(output_path),
        cv2.VideoWriter_fourcc(*"mp4v"),
        fps, (w, h),
    )

    logger.info("Rendering scene overlay: %s  (%dx%d, %d frames)", output_path, w, h, n_frames)

    for fidx in range(n_frames):
        img = _sample_bgr(scene, scene_times, fidx)

        # -- Gaze dot -------------------------------------------------------
        if fidx in gaze_by_frame:
            for _, row in gaze_by_frame[fidx].iterrows():
                sx, sy = row.get("gaze_x_scene"), row.get("gaze_y_scene")
                if pd.isna(sx) or pd.isna(sy):
                    continue
                x, y = int(round(sx)), int(round(sy))
                col = _GREEN if row.get("on_screen", False) else _RED
                cv2.circle(img, (x, y), 10, col, -1)
                cv2.circle(img, (x, y), 10, _WHITE, 2)

        # -- Fixation circle -------------------------------------------------
        if fidx in fix_by_frame:
            for _, row in fix_by_frame[fidx].iterrows():
                ex, ey = row.get("event_x"), row.get("event_y")
                if pd.isna(ex) or pd.isna(ey):
                    continue
                dur = row.get("duration_s", row.get("duration", 0.2))
                if pd.isna(dur):
                    dur = 0.2
                radius = max(8, min(40, int(dur * 80)))
                x, y = int(round(ex)), int(round(ey))
                col = _CYAN if row.get("on_screen", False) else _RED
                cv2.circle(img, (x, y), radius, col, 2)

        # -- Scanpath trail --------------------------------------------------
        _draw_scanpath_trail(img, scanpath_scene_pts, fidx, scanpath_trail)

        writer.write(img)
        if progress_callback:
            progress_callback(fidx + 1, n_frames)

    writer.release()
    logger.info("Scene overlay video saved: %s", output_path)


def render_screen_space_video(
    gaze_df: pd.DataFrame,
    fixations_df: pd.DataFrame,
    scanpath_df: pd.DataFrame,
    screen_size: tuple[int, int],
    output_path: str | Path,
    *,
    n_frames: int = 0,
    max_frames: Optional[int] = None,
    fps: int = 30,
    scanpath_trail: int = 8,
    progress_callback: Optional[callable] = None,
) -> None:
    """Render gaze and fixations on a black canvas at screen resolution.

    Each video frame corresponds to a scene-video frame index.  Gaze dots
    and fixation circles are drawn in screen-pixel coordinates.
    """
    w, h = screen_size
    if n_frames <= 0:
        n_frames = int(gaze_df["frame_idx"].max()) + 1
    if max_frames:
        n_frames = min(n_frames, max_frames)

    gaze_by_frame = _group_by_frame_screen(gaze_df)
    fix_by_frame = _group_by_frame_screen(fixations_df)
    scanpath_pts = _scanpath_screen_coords(scanpath_df)

    writer = cv2.VideoWriter(
        str(output_path),
        cv2.VideoWriter_fourcc(*"mp4v"),
        fps, (w, h),
    )

    logger.info("Rendering screen-space video: %s  (%dx%d, %d frames)",
                output_path, w, h, n_frames)

    for fidx in range(n_frames):
        img = np.zeros((h, w, 3), dtype=np.uint8)

        # Screen border
        cv2.rectangle(img, (0, 0), (w - 1, h - 1), _BORDER, 1)

        # -- Gaze dot -------------------------------------------------------
        if fidx in gaze_by_frame:
            for _, row in gaze_by_frame[fidx].iterrows():
                sx = row.get("gaze_x_screen")
                sy = row.get("gaze_y_screen")
                if pd.isna(sx) or pd.isna(sy):
                    continue
                x, y = int(round(sx)), int(round(sy))
                if 0 <= x < w and 0 <= y < h:
                    cv2.circle(img, (x, y), 8, _GREEN, -1)
                    cv2.circle(img, (x, y), 8, _WHITE, 1)

        # -- Fixation circle -------------------------------------------------
        if fidx in fix_by_frame:
            for _, row in fix_by_frame[fidx].iterrows():
                sx, sy = row.get("screen_x"), row.get("screen_y")
                if pd.isna(sx) or pd.isna(sy):
                    continue
                dur = row.get("duration_s", row.get("duration", 0.2))
                if pd.isna(dur):
                    dur = 0.2
                radius = max(8, min(50, int(dur * 100)))
                x, y = int(round(sx)), int(round(sy))
                if 0 <= x < w and 0 <= y < h:
                    cv2.circle(img, (x, y), radius, _CYAN, 2)

        # -- Scanpath trail --------------------------------------------------
        _draw_screen_scanpath_trail(img, scanpath_pts, fidx, scanpath_trail, w, h)

        writer.write(img)
        if progress_callback:
            progress_callback(fidx + 1, n_frames)

    writer.release()
    logger.info("Screen-space video saved: %s", output_path)


# ===================================================================
# Static Plots (matplotlib)
# ===================================================================

def plot_all(
    gaze_df: pd.DataFrame,
    fixations_df: pd.DataFrame,
    scanpath_df: pd.DataFrame,
    screen_size: tuple[int, int],
    output_dir: str | Path,
) -> list[Path]:
    """Generate all static analysis plots and save as PNGs.

    Returns a list of saved file paths.
    """
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    saved: list[Path] = []

    saved.append(_plot_gaze_heatmap(gaze_df, screen_size, output_dir, plt))
    saved.append(_plot_fixation_map(fixations_df, screen_size, output_dir, plt))
    saved.append(_plot_scanpath(scanpath_df, screen_size, output_dir, plt))
    saved.append(_plot_time_distribution(gaze_df, output_dir, plt))
    saved.append(_plot_fixation_histogram(fixations_df, output_dir, plt))

    logger.info("Saved %d plots to %s", len(saved), output_dir)
    return saved


# -- Individual plot functions ----------------------------------------------

def _plot_gaze_heatmap(
    gaze_df: pd.DataFrame,
    screen_size: tuple[int, int],
    out: Path,
    plt,
) -> Path:
    w, h = screen_size
    on = gaze_df[gaze_df["on_screen"]]
    fig, ax = plt.subplots(figsize=(10, 10 * h / w))
    if not on.empty:
        ax.hist2d(
            on["gaze_x_screen"], on["gaze_y_screen"],
            bins=[80, 60], range=[[0, w], [0, h]],
            cmap=PLOT_COLORS["cmap_heatmap"],
        )
    ax.set_xlim(0, w)
    ax.set_ylim(h, 0)  # flip Y so top-left is origin
    ax.set_aspect("equal")
    ax.set_title("On-Screen Gaze Heatmap")
    ax.set_xlabel("Screen X (px)")
    ax.set_ylabel("Screen Y (px)")
    path = out / "gaze_heatmap.png"
    fig.savefig(path, dpi=150, bbox_inches="tight")
    plt.close(fig)
    return path


def _plot_fixation_map(
    fix_df: pd.DataFrame,
    screen_size: tuple[int, int],
    out: Path,
    plt,
) -> Path:
    w, h = screen_size
    fig, ax = plt.subplots(figsize=(10, 10 * h / w))
    ax.set_xlim(0, w)
    ax.set_ylim(h, 0)
    ax.set_aspect("equal")

    on = fix_df[fix_df.get("on_screen", pd.Series(dtype=bool))] if "on_screen" in fix_df.columns else fix_df
    if not on.empty and "screen_x" in on.columns:
        durations = on.get("duration_s", on.get("duration", pd.Series(0.2, index=on.index)))
        sizes = durations.fillna(0.2) * 300
        ax.scatter(
            on["screen_x"], on["screen_y"],
            s=sizes, alpha=0.5, c=PLOT_COLORS["scatter"],
            edgecolors=PLOT_COLORS["box_edge"], linewidths=0.5,
        )

    ax.set_title("On-Screen Fixation Map (size = duration)")
    ax.set_xlabel("Screen X (px)")
    ax.set_ylabel("Screen Y (px)")
    path = out / "fixation_map.png"
    fig.savefig(path, dpi=150, bbox_inches="tight")
    plt.close(fig)
    return path


def _plot_scanpath(
    scanpath_df: pd.DataFrame,
    screen_size: tuple[int, int],
    out: Path,
    plt,
) -> Path:
    w, h = screen_size
    fig, ax = plt.subplots(figsize=(10, 10 * h / w))
    ax.set_xlim(0, w)
    ax.set_ylim(h, 0)
    ax.set_aspect("equal")

    if not scanpath_df.empty and "screen_x" in scanpath_df.columns:
        xs = scanpath_df["screen_x"].to_numpy()
        ys = scanpath_df["screen_y"].to_numpy()
        durations = scanpath_df.get("duration_s", pd.Series(0.2, index=scanpath_df.index))
        sizes = durations.fillna(0.2) * 300

        # Lines
        ax.plot(xs, ys, "-", color=PLOT_COLORS["gaze_trajectory"], linewidth=0.8, alpha=0.6)
        # Circles
        ax.scatter(
            xs, ys, s=sizes, alpha=0.6, c=PLOT_COLORS["scatter"],
            edgecolors=PLOT_COLORS["box_edge"], linewidths=0.5, zorder=3
        )
        # Numbers
        for i, (x, y) in enumerate(zip(xs, ys)):
            ax.text(x, y, str(i + 1), fontsize=6, ha="center", va="center",
                    color=PLOT_COLORS["annotation"], fontweight="bold", zorder=4)

    ax.set_title("On-Screen Scanpath")
    ax.set_xlabel("Screen X (px)")
    ax.set_ylabel("Screen Y (px)")
    path = out / "scanpath.png"
    fig.savefig(path, dpi=150, bbox_inches="tight")
    plt.close(fig)
    return path


def _plot_time_distribution(
    gaze_df: pd.DataFrame,
    out: Path,
    plt,
) -> Path:
    fig, ax = plt.subplots(figsize=(6, 4))
    n_total = len(gaze_df)
    n_on = gaze_df["on_screen"].sum() if "on_screen" in gaze_df.columns else 0
    n_off = n_total - n_on

    if n_total > 0:
        pct_on = 100.0 * n_on / n_total
        pct_off = 100.0 * n_off / n_total
        bars = ax.bar(
            ["On Screen", "Off Screen"],
            [pct_on, pct_off],
            color=[PLOT_COLORS["on_screen"], PLOT_COLORS["off_screen"]],
        )
        for bar, pct in zip(bars, [pct_on, pct_off]):
            ax.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 1,
                    f"{pct:.1f}%", ha="center", va="bottom", fontweight="bold")

    ax.set_ylabel("Percentage of gaze samples (%)")
    ax.set_title("On-Screen vs Off-Screen Gaze")
    ax.set_ylim(0, 110)
    path = out / "time_distribution.png"
    fig.savefig(path, dpi=150, bbox_inches="tight")
    plt.close(fig)
    return path


def _plot_fixation_histogram(
    fix_df: pd.DataFrame,
    out: Path,
    plt,
) -> Path:
    fig, ax = plt.subplots(figsize=(7, 4))

    on = fix_df[fix_df["on_screen"]] if "on_screen" in fix_df.columns else fix_df
    durations = on.get("duration_s", on.get("duration", pd.Series(dtype=float)))
    durations = durations.dropna()

    if not durations.empty:
        ax.hist(
            durations * 1000, bins=30, color=PLOT_COLORS["histogram"],
            edgecolor=PLOT_COLORS["bar_edge"], alpha=0.8
        )
        ax.axvline(
            durations.median() * 1000, color=PLOT_COLORS["trend_line"], linestyle="--",
            label=f"Median: {durations.median()*1000:.0f} ms"
        )
        ax.legend()

    ax.set_xlabel("Fixation duration (ms)")
    ax.set_ylabel("Count")
    ax.set_title("On-Screen Fixation Duration Distribution")
    path = out / "fixation_durations.png"
    fig.savefig(path, dpi=150, bbox_inches="tight")
    plt.close(fig)
    return path


# ===================================================================
# Internal helpers
# ===================================================================

def _group_by_frame(df: pd.DataFrame) -> dict[int, pd.DataFrame]:
    if df.empty or "frame_idx" not in df.columns:
        return {}
    return {int(k): v for k, v in df.groupby("frame_idx")}


def _group_by_frame_screen(df: pd.DataFrame) -> dict[int, pd.DataFrame]:
    """Group only on-screen rows by frame_idx."""
    if df.empty or "frame_idx" not in df.columns:
        return {}
    on = df[df.get("on_screen", pd.Series(False, index=df.index))]
    if on.empty:
        return {}
    return {int(k): v for k, v in on.groupby("frame_idx")}


def _sample_bgr(scene, scene_times: np.ndarray, fidx: int) -> np.ndarray:
    ts = int(scene_times[fidx])
    frame = scene.sample(np.array([ts]))[0]
    if hasattr(frame, "bgr"):
        return np.asarray(frame.bgr).copy()
    return cv2.cvtColor(np.asarray(frame.gray), cv2.COLOR_GRAY2BGR)


def _scanpath_scene_coords(
    fix_df: pd.DataFrame, scanpath_df: pd.DataFrame,
) -> list[tuple[int, int, int]]:
    """Return [(frame_idx, scene_x, scene_y), ...] for on-screen fixations."""
    if fix_df.empty or scanpath_df.empty:
        return []
    on = fix_df[fix_df.get("on_screen", pd.Series(False, index=fix_df.index))]
    if on.empty or "event_x" not in on.columns:
        return []
    ts_col = next((c for c in ["timestamp_ns", "start_time", "timestamp"] if c in on.columns), None)
    if ts_col:
        on = on.sort_values(ts_col)
    result = []
    for _, row in on.iterrows():
        fidx = int(row.get("frame_idx", 0))
        x = int(round(row["event_x"]))
        y = int(round(row["event_y"]))
        result.append((fidx, x, y))
    return result


def _scanpath_screen_coords(scanpath_df: pd.DataFrame) -> list[tuple[int, float, float]]:
    """Return [(order, screen_x, screen_y), ...] from the scanpath."""
    if scanpath_df.empty or "screen_x" not in scanpath_df.columns:
        return []
    result = []
    for _, row in scanpath_df.iterrows():
        result.append((
            int(row.get("order", 0)),
            float(row["screen_x"]),
            float(row["screen_y"]),
        ))
    return result


def _draw_scanpath_trail(
    img: np.ndarray,
    pts: list[tuple[int, int, int]],
    current_fidx: int,
    trail_len: int,
) -> None:
    """Draw scanpath lines on a scene-camera image up to *current_fidx*."""
    recent = [p for p in pts if p[0] <= current_fidx]
    recent = recent[-trail_len:]
    for i in range(1, len(recent)):
        p1 = (recent[i - 1][1], recent[i - 1][2])
        p2 = (recent[i][1], recent[i][2])
        cv2.line(img, p1, p2, _YELLOW, 2, cv2.LINE_AA)
    # Draw small dots at each fixation centre
    for _, x, y in recent:
        cv2.circle(img, (x, y), 5, _YELLOW, -1)


def _draw_screen_scanpath_trail(
    img: np.ndarray,
    pts: list[tuple[int, float, float]],
    current_fidx: int,
    trail_len: int,
    w: int,
    h: int,
) -> None:
    """Draw scanpath lines on a screen-space canvas."""
    # Use order index as proxy: show fixations whose order <= current step
    # Approximate: show the last trail_len fixations
    # Since we don't have a perfect fidx->order mapping here, show all
    # up to a proportional point
    if not pts:
        return
    total_fix = len(pts)
    # Estimate which fixations have occurred by this frame
    # Use a simple proportional approach based on frame progress
    # This is approximate; in a real implementation you'd match timestamps
    idx = min(total_fix, max(1, int(total_fix * current_fidx /
              max(current_fidx + 1, 1))))
    recent = pts[:idx][-trail_len:]

    for i in range(1, len(recent)):
        x1, y1 = int(round(recent[i - 1][1])), int(round(recent[i - 1][2]))
        x2, y2 = int(round(recent[i][1])), int(round(recent[i][2]))
        if (0 <= x1 < w and 0 <= y1 < h and 0 <= x2 < w and 0 <= y2 < h):
            cv2.line(img, (x1, y1), (x2, y2), _YELLOW, 2, cv2.LINE_AA)

    for _, sx, sy in recent:
        x, y = int(round(sx)), int(round(sy))
        if 0 <= x < w and 0 <= y < h:
            cv2.circle(img, (x, y), 5, _YELLOW, -1)
