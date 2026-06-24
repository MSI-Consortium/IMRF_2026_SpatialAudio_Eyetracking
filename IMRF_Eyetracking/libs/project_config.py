"""Shared project settings that are safe to keep under version control."""

from __future__ import annotations

COLOR_PALETTE: dict[str, str] = {
    "blue": "tab:blue",
    "orange": "tab:orange",
    "green": "tab:green",
    "red": "tab:red",
    "purple": "tab:purple",
    "brown": "tab:brown",
    "pink": "tab:pink",
    "grey": "tab:gray",
    "olive": "tab:olive",
    "cyan": "tab:cyan",
    "black": "black",
    "white": "white",
    "screen": "whitesmoke",
    "note": "cornsilk",
}

COLOR_ROLES: dict[str, tuple[str, ...]] = {
    "blue": (
        "processed", "average", "fixation", "cdf_V", "interp_linear",
        "bar", "aoi_left", "scatter",
    ),
    "cyan": ("model_pir", "histogram"),
    "green": ("stimulus_onset", "on_screen", "cdf_AV", "interp_pchip", "aoi_center"),
    "orange": ("stimulus_end", "saccade_start", "cdf_A", "interp_nearest", "mean_line"),
    "brown": ("saccade_end", "model_coactivation"),
    "red": (
        "response", "saccade", "off_screen", "cdf_bound", "trend_line",
        "median_line", "aoi_right",
    ),
    "purple": ("blink_region", "blink_event", "violation", "interp_cubic"),
    "pink": ("model_independent", "interp_weighted_average"),
    "grey": ("raw", "model_mre", "aoi_fixation"),
    "olive": ("gaze_trajectory",),
    "black": ("zero_line", "point_overlay", "bar_edge", "aoi_bar_edge", "box_edge", "arrow"),
    "screen": ("screen_background",),
    "note": ("box_face",),
    "white": ("annotation",),
}

PLOT_COLORS: dict[str, str] = {
    role: COLOR_PALETTE[color_name]
    for color_name, roles in COLOR_ROLES.items()
    for role in roles
}
PLOT_COLORS.update({
    "cmap_heatmap": "inferno",
    "cmap_trials": "cividis",
    "cmap_fixations": "viridis",
    "cmap_conditions": "coolwarm",
})

RACE_MODEL_STYLES: dict[str, dict[str, str]] = {
    "miller_bound": {
        "color": PLOT_COLORS["cdf_bound"],
        "ls": "--",
        "label": "Miller Bound",
    },
    "independent_race": {
        "color": PLOT_COLORS["model_independent"],
        "ls": "-.",
        "label": "Independent Race",
    },
    "coactivation": {
        "color": PLOT_COLORS["model_coactivation"],
        "ls": ":",
        "label": "Coactivation",
    },
    "pir": {
        "color": PLOT_COLORS["model_pir"],
        "ls": "-",
        "label": "PIR",
    },
    "mre": {
        "color": PLOT_COLORS["model_mre"],
        "ls": "-.",
        "label": "MRE",
    },
}
