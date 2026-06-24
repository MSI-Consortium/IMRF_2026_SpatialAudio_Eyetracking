"""
Area-of-Interest (AOI) analysis for screen-mapped gaze data.

Supports multiple AOI definition methods (Hessels et al. 2016,
DOI 10.3758/s13428-015-0676-y):

* **Circle** — fixed-radius circles at target centres (original method)
* **Voronoi** — full Voronoi tessellation; every pixel belongs to the
  nearest target (most objective, recommended for sparse stimuli)
* **LRVT** — Limited-Radius Voronoi Tessellation; Voronoi boundaries
  capped at a maximum radius
* **Grid** — regular grid cells assigned to the nearest target
Also provides continuous **distance-based metrics** for each fixation:
nearest_target, distance_to_nearest_px/deg, spatial_error, is_hit.

Additional ``classify_by_ellipse`` helper delegates to
:mod:`libs.analysis.fixation_utils` for ellipse-based AOI assignment.

Coordinate convention
---------------------
* PsychoPy stimulus positions are in **degrees of visual angle**,
  origin at screen centre, y-up.
* Screen-mapped gaze data is in **pixels**, origin top-left, y-down.
* This module converts between the two systems.
"""

from __future__ import annotations

import logging
import math
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Tuple

import numpy as np
import pandas as pd

from libs.project_config import PLOT_COLORS

logger = logging.getLogger(__name__)

DEFAULT_SCREEN_W_PX: int = 3840
DEFAULT_SCREEN_H_PX: int = 2160


# ====================================================================
# AOI definition
# ====================================================================

@dataclass
class AOI:
    """A single circular area of interest on the screen (pixel coords)."""
    name: str
    center_x: float          # pixels
    center_y: float          # pixels
    radius: float            # pixels
    color: str = PLOT_COLORS["aoi_left"]   # for plotting

    def contains(self, x: np.ndarray, y: np.ndarray) -> np.ndarray:
        """Return boolean mask: True where (x, y) falls inside this AOI."""
        dx = x - self.center_x
        dy = y - self.center_y
        return (dx * dx + dy * dy) <= (self.radius * self.radius)


# Paradigm positions in degrees of visual angle (screen-centre origin, y-up).
# Calibrated empirically to the Unity IMRF experiment on a 1920×1080 display
# (52 cm wide, 60 cm viewing distance). Unity world targets at (±1, 1.2, 1) m
# project to approximately ±4.5° horizontal and −2.5° vertical on this surface.
PARADIGM_POSITIONS_DEG = {
    "Left":            (-4.5, -2.5),
    "Center":          ( 0.0, -2.5),
    "Right":           ( 4.5, -2.5),
    "Fixation Cross":  ( 0.0, -10.0),
}

STIMULUS_DIAMETER_DEG = 3.0      # grey circles
FIXATION_HEIGHT_DEG   = 1.5      # "+" text height


def deg_to_px(
    deg_x: float,
    deg_y: float,
    screen_w_px: int = DEFAULT_SCREEN_W_PX,
    screen_h_px: int = DEFAULT_SCREEN_H_PX,
    monitor_w_cm: float = 71.0,
    viewing_dist_cm: float = 57.0,
) -> Tuple[float, float]:
    """Convert PsychoPy degrees to screen pixels (origin top-left, y-down).

    PsychoPy: origin at screen centre, y-up.
    Pixels:   origin at top-left, y-down.
    """
    # Pixels per degree (horizontal — assumes square pixels)
    ppd = math.tan(math.radians(1.0)) * viewing_dist_cm * (screen_w_px / monitor_w_cm)
    cx = screen_w_px / 2.0
    cy = screen_h_px / 2.0
    px_x = cx + deg_x * ppd
    px_y = cy - deg_y * ppd      # y-axis inverted
    return (px_x, px_y)


def deg_to_px_size(
    size_deg: float,
    screen_w_px: int = DEFAULT_SCREEN_W_PX,
    monitor_w_cm: float = 71.0,
    viewing_dist_cm: float = 57.0,
) -> float:
    """Convert a size in degrees to pixels."""
    ppd = math.tan(math.radians(1.0)) * viewing_dist_cm * (screen_w_px / monitor_w_cm)
    return size_deg * ppd


def pixels_per_degree(
    screen_w_px: int = DEFAULT_SCREEN_W_PX,
    monitor_w_cm: float = 71.0,
    viewing_dist_cm: float = 57.0,
) -> float:
    """Return pixels-per-degree for the given display geometry."""
    return math.tan(math.radians(1.0)) * viewing_dist_cm * (screen_w_px / monitor_w_cm)


def min_inter_target_distance(aois: List[AOI]) -> float:
    """Return the minimum pairwise Euclidean distance (px) between AOI centres."""
    d_min = float("inf")
    for i in range(len(aois)):
        for j in range(i + 1, len(aois)):
            dx = aois[i].center_x - aois[j].center_x
            dy = aois[i].center_y - aois[j].center_y
            d_min = min(d_min, math.sqrt(dx * dx + dy * dy))
    return d_min


# ====================================================================
# Build the default set of AOIs
# ====================================================================

# Colours for each AOI (for consistent plotting)
AOI_COLORS = {
    "Left": PLOT_COLORS["aoi_left"],
    "Center": PLOT_COLORS["aoi_center"],
    "Right": PLOT_COLORS["aoi_right"],
    "Fixation Cross": PLOT_COLORS["aoi_fixation"],
}


def build_paradigm_aois(
    screen_w_px: int = DEFAULT_SCREEN_W_PX,
    screen_h_px: int = DEFAULT_SCREEN_H_PX,
    monitor_w_cm: float = 71.0,
    viewing_dist_cm: float = 57.0,
    buffer_pct: float = 15.0,
) -> List[AOI]:
    """Build the default AOIs for the IMRF paradigm.

    Parameters
    ----------
    buffer_pct : float
        Percentage to expand each AOI radius beyond the visible stimulus
        (e.g. 15 → radius × 1.15).
    """
    buffer = 1.0 + buffer_pct / 100.0

    aois: List[AOI] = []
    for name, (deg_x, deg_y) in PARADIGM_POSITIONS_DEG.items():
        cx, cy = deg_to_px(deg_x, deg_y, screen_w_px, screen_h_px,
                           monitor_w_cm, viewing_dist_cm)

        if name == "Fixation Cross":
            base_radius = deg_to_px_size(
                FIXATION_HEIGHT_DEG / 2.0,
                screen_w_px, monitor_w_cm, viewing_dist_cm,
            )
        else:
            base_radius = deg_to_px_size(
                STIMULUS_DIAMETER_DEG / 2.0,
                screen_w_px, monitor_w_cm, viewing_dist_cm,
            )

        aois.append(AOI(
            name=name,
            center_x=cx,
            center_y=cy,
            radius=base_radius * buffer,
            color=AOI_COLORS.get(name, PLOT_COLORS["raw"]),
        ))

    return aois


# ====================================================================
# Classification
# ====================================================================

def classify_samples(
    df: pd.DataFrame,
    aois: List[AOI],
    x_col: str = "gaze_x_screen",
    y_col: str = "gaze_y_screen",
) -> pd.DataFrame:
    """Add an ``aoi`` column to *df* with the name of the containing AOI.

    If a point falls inside multiple AOIs (unlikely with non-overlapping
    circles), the first match wins.  Points outside all AOIs get ``None``.
    """
    df = df.copy()
    x = df[x_col].values.astype(float)
    y = df[y_col].values.astype(float)

    labels = np.full(len(df), None, dtype=object)
    for aoi in aois:
        mask = aoi.contains(x, y) & (labels == None)  # noqa: E711
        labels[mask] = aoi.name

    df["aoi"] = labels
    return df


def classify_fixations(
    df: pd.DataFrame,
    aois: List[AOI],
    x_col: str = "screen_x",
    y_col: str = "screen_y",
) -> pd.DataFrame:
    """Classify fixations into AOIs (same logic, different default columns)."""
    return classify_samples(df, aois, x_col=x_col, y_col=y_col)


# ====================================================================
# Multi-method classification  (Hessels et al. 2016)
# ====================================================================

AOI_METHODS = ("circle", "voronoi", "lrvt", "grid")


def classify_extended(
    df: pd.DataFrame,
    aois: List[AOI],
    x_col: str = "gaze_x_screen",
    y_col: str = "gaze_y_screen",
    method: str = "circle",
    max_radius_px: Optional[float] = None,
    grid_size_px: Optional[float] = None,
    ppd: Optional[float] = None,
    **_kwargs,
) -> pd.DataFrame:
    """Classify samples using the chosen AOI method.

    Always adds these columns:

    * ``aoi`` — name of the assigned AOI (or ``None`` if unclassified)
    * ``nearest_target`` — name of the closest AOI centre (always set)
    * ``distance_to_nearest_px`` — Euclidean distance in pixels
    * ``distance_to_nearest_deg`` — distance in degrees (if *ppd* given)
    * ``is_hit`` — True when the sample is inside the assigned AOI

    Parameters
    ----------
    method : str
        One of ``"circle"``, ``"voronoi"``, ``"lrvt"``, ``"grid"``.
    max_radius_px : float, optional
        Maximum radius for LRVT.  If *None*, defaults to half the
        minimum inter-target distance.
    grid_size_px : float, optional
        Cell size for the grid method (pixels).
    ppd : float, optional
        Pixels-per-degree; if given, ``distance_to_nearest_deg`` is
        populated.
    """
    df = df.copy()
    x = df[x_col].values.astype(float)
    y = df[y_col].values.astype(float)
    n = len(df)
    n_aoi = len(aois)

    # --- Distances to every AOI centre ---------------------------------
    distances = np.empty((n, n_aoi))
    for i, aoi in enumerate(aois):
        dx = x - aoi.center_x
        dy = y - aoi.center_y
        distances[:, i] = np.sqrt(dx * dx + dy * dy)

    nearest_idx = np.argmin(distances, axis=1)
    nearest_dist = distances[np.arange(n), nearest_idx]
    nearest_names = np.array([aois[k].name for k in nearest_idx], dtype=object)

    # --- Common distance columns (always present) ----------------------
    df["nearest_target"] = nearest_names
    df["distance_to_nearest_px"] = nearest_dist
    if ppd and ppd > 0:
        df["distance_to_nearest_deg"] = nearest_dist / ppd

    # --- AOI assignment (method-specific) ------------------------------
    if method == "voronoi":
        df["aoi"] = nearest_names

    elif method == "lrvt":
        if max_radius_px is None:
            max_radius_px = min_inter_target_distance(aois) / 2.0
        labels = nearest_names.copy()
        labels[nearest_dist > max_radius_px] = None
        df["aoi"] = labels

    elif method == "grid":
        if grid_size_px is None:
            grid_size_px = 100.0
        cell_x = (x // grid_size_px).astype(int)
        cell_y = (y // grid_size_px).astype(int)
        cell_cx = (cell_x + 0.5) * grid_size_px
        cell_cy = (cell_y + 0.5) * grid_size_px
        cell_dists = np.empty((n, n_aoi))
        for i, aoi in enumerate(aois):
            ddx = cell_cx - aoi.center_x
            ddy = cell_cy - aoi.center_y
            cell_dists[:, i] = np.sqrt(ddx * ddx + ddy * ddy)
        cell_nearest = np.argmin(cell_dists, axis=1)
        df["aoi"] = [aois[k].name for k in cell_nearest]

    else:  # "circle" — original behaviour
        labels = np.full(n, None, dtype=object)
        for aoi in aois:
            mask = aoi.contains(x, y) & (labels == None)  # noqa: E711
            labels[mask] = aoi.name
        df["aoi"] = labels

    df["is_hit"] = df["aoi"].notna()
    return df


def classify_fixations_extended(
    df: pd.DataFrame,
    aois: List[AOI],
    x_col: str = "screen_x",
    y_col: str = "screen_y",
    **kwargs,
) -> pd.DataFrame:
    """Convenience wrapper: :func:`classify_extended` with fixation defaults."""
    return classify_extended(df, aois, x_col=x_col, y_col=y_col, **kwargs)


# ====================================================================
# Voronoi geometry helpers  (for visualisation)
# ====================================================================

def _sutherland_hodgman_clip(
    subject: List[Tuple[float, float]],
    clip: List[Tuple[float, float]],
) -> List[Tuple[float, float]]:
    """Clip *subject* polygon to the convex *clip* polygon."""

    def _inside(p, a, b):
        return ((b[0] - a[0]) * (p[1] - a[1])
                - (b[1] - a[1]) * (p[0] - a[0])) >= 0

    def _intersect(p1, p2, a, b):
        x1, y1 = p1; x2, y2 = p2
        x3, y3 = a;  x4, y4 = b
        denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
        if abs(denom) < 1e-12:
            return p2
        t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom
        return (x1 + t * (x2 - x1), y1 + t * (y2 - y1))

    output = list(subject)
    for i in range(len(clip)):
        if not output:
            return output
        a = clip[i]
        b = clip[(i + 1) % len(clip)]
        inp = output
        output = []
        for j in range(len(inp)):
            cur = inp[j]
            prev = inp[j - 1]
            if _inside(cur, a, b):
                if not _inside(prev, a, b):
                    output.append(_intersect(prev, cur, a, b))
                output.append(cur)
            elif _inside(prev, a, b):
                output.append(_intersect(prev, cur, a, b))
    return output


def compute_voronoi_regions(
    aois: List[AOI],
    screen_w_px: int = 3840,
    screen_h_px: int = 2160,
) -> Dict[str, np.ndarray]:
    """Return Voronoi cell polygons clipped to the screen rectangle.

    Returns ``{aoi_name: Nx2 vertex array}``.
    """
    from scipy.spatial import Voronoi as _Voronoi

    centers = np.array([[a.center_x, a.center_y] for a in aois])
    far = float(max(screen_w_px, screen_h_px)) * 5.0
    dummy = np.array([
        [-far, -far], [screen_w_px + far, -far],
        [-far, screen_h_px + far], [screen_w_px + far, screen_h_px + far],
    ])
    all_pts = np.vstack([centers, dummy])
    vor = _Voronoi(all_pts)

    screen_rect = [
        (0.0, 0.0), (float(screen_w_px), 0.0),
        (float(screen_w_px), float(screen_h_px)), (0.0, float(screen_h_px)),
    ]

    regions: Dict[str, np.ndarray] = {}
    for i, aoi in enumerate(aois):
        reg_idx = vor.point_region[i]
        vert_indices = vor.regions[reg_idx]
        if -1 in vert_indices or len(vert_indices) < 3:
            continue
        verts = [(float(vor.vertices[v][0]), float(vor.vertices[v][1]))
                 for v in vert_indices]
        clipped = _sutherland_hodgman_clip(verts, screen_rect)
        if len(clipped) >= 3:
            regions[aoi.name] = np.array(clipped)
    return regions


def compute_grid_cells(
    aois: List[AOI],
    grid_size_px: float,
    screen_w_px: int = 3840,
    screen_h_px: int = 2160,
) -> Dict[str, List[Tuple[float, float, float, float]]]:
    """Return grid cells assigned to each AOI.

    Returns ``{aoi_name: [(x, y, w, h), ...]}``.
    """
    centers = np.array([[a.center_x, a.center_y] for a in aois])
    result: Dict[str, List[Tuple[float, float, float, float]]] = {
        a.name: [] for a in aois
    }
    nx = int(math.ceil(screen_w_px / grid_size_px))
    ny = int(math.ceil(screen_h_px / grid_size_px))
    for iy in range(ny):
        for ix in range(nx):
            cx = (ix + 0.5) * grid_size_px
            cy = (iy + 0.5) * grid_size_px
            dists = np.sqrt((centers[:, 0] - cx) ** 2 + (centers[:, 1] - cy) ** 2)
            nearest = int(np.argmin(dists))
            name = aois[nearest].name
            result[name].append((ix * grid_size_px, iy * grid_size_px,
                                 grid_size_px, grid_size_px))
    return result


# ====================================================================
# Metrics computation
# ====================================================================

@dataclass
class AOITrialMetrics:
    """Metrics for a single AOI in a single trial."""
    aoi_name: str
    dwell_time_s: float = 0.0
    fixation_count: int = 0
    mean_fixation_duration_s: float = 0.0
    max_fixation_duration_s: float = 0.0
    first_fixation_latency_s: float = float("nan")
    revisit_count: int = 0
    proportion: float = 0.0        # fraction of on-screen time


def compute_trial_aoi_metrics(
    gaze_window: pd.DataFrame,
    fix_window: pd.DataFrame,
    aois: List[AOI],
    trigger_ts: float,
    sampling_rate: float = 200.0,
    ts_col: str = "timestamp_ns",
) -> List[AOITrialMetrics]:
    """Compute AOI metrics for one trial epoch.

    Parameters
    ----------
    gaze_window : DataFrame
        Gaze samples already filtered to the trial time window,
        with ``aoi`` column (from :func:`classify_samples`).
    fix_window : DataFrame
        Fixations already filtered to the trial window,
        with ``aoi`` column (from :func:`classify_fixations`).
    trigger_ts : float
        Trigger timestamp **in the same unit** as *ts_col*.
    sampling_rate : float
        Gaze sampling rate (Hz) — used for dwell time if sample-based.
    ts_col : str
        Timestamp column in the gaze DataFrame.

    Returns
    -------
    List[AOITrialMetrics]
        One entry per AOI.
    """
    total_on_screen = len(gaze_window)
    sample_dt = 1.0 / sampling_rate        # seconds per sample

    results = []
    for aoi in aois:
        m = AOITrialMetrics(aoi_name=aoi.name)

        # --- Gaze-based: dwell time & proportion ---
        in_aoi = gaze_window[gaze_window["aoi"] == aoi.name]
        m.dwell_time_s = len(in_aoi) * sample_dt
        m.proportion = len(in_aoi) / max(total_on_screen, 1)

        # --- Fixation-based metrics ---
        fix_in = fix_window[fix_window["aoi"] == aoi.name]
        m.fixation_count = len(fix_in)

        if not fix_in.empty:
            dur_col = "duration_s" if "duration_s" in fix_in.columns else "duration"
            durs = fix_in[dur_col].dropna().values.astype(float)
            if len(durs) > 0:
                m.mean_fixation_duration_s = float(np.mean(durs))
                m.max_fixation_duration_s = float(np.max(durs))

            # First fixation latency (from trigger onset)
            if ts_col in fix_in.columns:
                first_ts = fix_in[ts_col].min()
                # Handle ns vs s
                if first_ts > 1e15:  # nanoseconds
                    latency = (first_ts - trigger_ts) / 1e9
                else:
                    latency = first_ts - trigger_ts
                m.first_fixation_latency_s = float(latency)

            # Revisit count: number of separate "entries" into this AOI
            # A revisit = gaze left the AOI then came back
            if not in_aoi.empty and ts_col in in_aoi.columns:
                ts_vals = in_aoi[ts_col].sort_values().values
                if len(ts_vals) > 1:
                    # Detect gaps: if gap between consecutive timestamps
                    # exceeds 2× the sample period → new visit
                    diffs = np.diff(ts_vals)
                    if ts_vals[0] > 1e15:   # ns
                        gap_thresh = (2.0 / sampling_rate) * 1e9
                    else:
                        gap_thresh = 2.0 / sampling_rate
                    entries = 1 + int(np.sum(diffs > gap_thresh))
                    m.revisit_count = max(0, entries - 1)   # first visit is not a "re"-visit

        results.append(m)

    return results


def compute_aoi_metrics_table(
    gaze_df: pd.DataFrame,
    fix_df: pd.DataFrame,
    aois: List[AOI],
    trigger_times: Dict[str, List[float]],
    time_before: float = 0.2,
    time_after: float = 1.0,
    sampling_rate: float = 200.0,
    ts_col: str = "timestamp_ns",
) -> pd.DataFrame:
    """Compute a full AOI metrics table across conditions and trials.

    Parameters
    ----------
    gaze_df : DataFrame
        Full gaze DataFrame with ``aoi`` column already added.
    fix_df : DataFrame
        Full fixation DataFrame with ``aoi`` column already added.
    trigger_times : dict
        ``{condition_label: [trigger_ts_1, trigger_ts_2, ...]}``
        Timestamps must be in the **same unit** as *ts_col* in gaze_df.
    time_before, time_after : float
        Epoch window in seconds around each trigger.

    Returns
    -------
    pd.DataFrame
        Columns: condition, trial, aoi, dwell_time_s, fixation_count,
        mean_fixation_duration_s, max_fixation_duration_s,
        first_fixation_latency_s, revisit_count, proportion.
    """
    rows = []

    for condition, times_list in trigger_times.items():
        for trial_idx, trig_ts in enumerate(times_list):
            # Build window boundaries in the timestamp unit
            ts_vals = gaze_df[ts_col]
            if ts_vals.median() > 1e15:  # nanoseconds
                win_start = (trig_ts - time_before) * 1e9 if trig_ts < 1e15 else trig_ts - time_before * 1e9
                win_end   = (trig_ts + time_after)  * 1e9 if trig_ts < 1e15 else trig_ts + time_after  * 1e9
                trig_ts_native = trig_ts * 1e9 if trig_ts < 1e15 else trig_ts
            else:
                win_start = trig_ts - time_before
                win_end   = trig_ts + time_after
                trig_ts_native = trig_ts

            gaze_win = gaze_df[(gaze_df[ts_col] >= win_start) & (gaze_df[ts_col] <= win_end)]
            # Only on-screen gaze
            if "on_screen" in gaze_win.columns:
                gaze_win = gaze_win[gaze_win["on_screen"] == True]

            fix_win = fix_df[(fix_df[ts_col] >= win_start) & (fix_df[ts_col] <= win_end)]
            if "on_screen" in fix_win.columns:
                fix_win = fix_win[fix_win["on_screen"] == True]

            trial_metrics = compute_trial_aoi_metrics(
                gaze_win, fix_win, aois,
                trigger_ts=trig_ts_native,
                sampling_rate=sampling_rate,
                ts_col=ts_col,
            )

            for m in trial_metrics:
                rows.append({
                    "condition": condition,
                    "trial": trial_idx + 1,
                    "aoi": m.aoi_name,
                    "dwell_time_s": m.dwell_time_s,
                    "fixation_count": m.fixation_count,
                    "mean_fixation_duration_s": m.mean_fixation_duration_s,
                    "max_fixation_duration_s": m.max_fixation_duration_s,
                    "first_fixation_latency_s": m.first_fixation_latency_s,
                    "revisit_count": m.revisit_count,
                    "proportion": m.proportion,
                })

    if not rows:
        return pd.DataFrame()

    df = pd.DataFrame(rows)
    return df


# ====================================================================
# Entropy metrics
# ====================================================================

def stationary_entropy(proportions: np.ndarray) -> float:
    """Shannon entropy of the gaze-proportion distribution across AOIs.

    Measures how evenly gaze is distributed.  High entropy = gaze spread
    equally across all AOIs; low entropy = concentrated on one target.

    Parameters
    ----------
    proportions : 1-D array
        Proportion of gaze time in each AOI (should sum to ~1).

    Returns
    -------
    float
        Entropy in *bits*.  Returns 0.0 if no valid data.
    """
    p = np.asarray(proportions, dtype=float)
    p = p[p > 0]
    if len(p) == 0:
        return 0.0
    p = p / p.sum()                       # normalise just in case
    return float(-np.sum(p * np.log2(p)))


def transition_entropy(trans_matrix: np.ndarray) -> float:
    """Conditional (transition) entropy of the AOI transition matrix.

    For each source AOI *i* the row of the transition matrix gives the
    probability of moving to each destination *j*.  The conditional
    entropy is the weighted average of each row's Shannon entropy:

        H = Σ_i  p_i · H(row_i)

    where ``p_i`` is the marginal probability of being in AOI *i*
    (estimated from row sums).

    Low entropy → predictable scan-path; high entropy → random.

    Parameters
    ----------
    trans_matrix : 2-D array (N × N)
        Raw *counts* of transitions from row to column.

    Returns
    -------
    float
        Conditional entropy in *bits*.  Returns 0.0 if no transitions.
    """
    T = np.asarray(trans_matrix, dtype=float)
    total = T.sum()
    if total == 0:
        return 0.0

    row_sums = T.sum(axis=1)
    marginal = row_sums / total           # p_i

    H = 0.0
    for i in range(T.shape[0]):
        if row_sums[i] == 0:
            continue
        p_row = T[i] / row_sums[i]
        p_row = p_row[p_row > 0]
        row_entropy = -np.sum(p_row * np.log2(p_row))
        H += marginal[i] * row_entropy

    return float(H)


def max_entropy(n_aois: int) -> float:
    """Maximum possible entropy for *n_aois* categories (log₂ N)."""
    if n_aois <= 1:
        return 0.0
    return float(np.log2(n_aois))


# ====================================================================
# Ellipse-based classification (delegated to fixation_utils)
# ====================================================================

def classify_by_ellipse(
    fix_df: pd.DataFrame,
    aois: List[AOI],
    ppd: float = 1.0,
    confidence: float = 0.95,
    x_col: str = "screen_x",
    y_col: str = "screen_y",
    nearest_col: str = "nearest_target",
) -> pd.DataFrame:
    """Classify fixations using data-driven 95 % confidence ellipses.

    1. Computes per-target dispersion metrics (centroid, covariance).
    2. Fits a confidence ellipse at the requested level.
    3. Adds an ``aoi_ellipse`` column: target name or ``None``.

    This is useful as an alternative to circular AOIs — it adapts to
    each participant's actual landing distribution.

    Parameters
    ----------
    fix_df : DataFrame with fixation positions and *nearest_col*.
    aois : list of :class:`AOI` from :func:`build_paradigm_aois`.
    ppd : pixels per degree.
    confidence : probability level for the ellipse (default 0.95).

    Returns
    -------
    DataFrame with ``aoi_ellipse`` column appended.
    """
    from libs.analysis.fixation_utils import (
        compute_all_dispersion,
        classify_fixations_by_ellipse,
    )

    metrics = compute_all_dispersion(
        fix_df, aois, ppd=ppd, confidence=confidence,
        x_col=x_col, y_col=y_col, nearest_col=nearest_col,
    )

    # Build ellipse dict (skip targets with too few fixations)
    ellipses = {}
    for m in metrics:
        if m.ellipse is not None:
            ellipses[m.target_name] = m.ellipse

    if not ellipses:
        fix_df = fix_df.copy()
        fix_df["aoi_ellipse"] = None
        return fix_df

    return classify_fixations_by_ellipse(
        fix_df, ellipses, x_col=x_col, y_col=y_col,
    )
