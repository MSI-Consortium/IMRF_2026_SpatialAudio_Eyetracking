# spaud/plot_intervals.py
from __future__ import annotations
from typing import Iterable, Optional, Dict, Any, Tuple, Sequence, Union
import os
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter
import matplotlib.colors as mcolors

from io_cache import processed_path, load_cache
from plot_handler import PlotHandler
from utils import pick_visual_channel

def _require_equal_len(a, b, aname: str, bname: str):
    if len(a) != len(b):
        raise ValueError(f"{aname} and {bname} must have equal length (got {len(a)} vs {len(b)})")

def _fetch_time_series(cache: dict, var: str, *, input_wav_path: Optional[str] = None):
    """
    Return a time-series ndarray for var.
    Special-case 'raw': tries cache['vars']['raw'], else loads from WAV if provided.
    """
    vars_d = cache.get("vars", {})
    if var == "raw":
        if "raw" in vars_d:
            return vars_d["raw"]
        # No cached raw; try to dynamically load if path provided
        if input_wav_path:
            import soundfile as sf
            data, _sr = sf.read(input_wav_path)
            return data
        raise ValueError("Requested 'raw' but it's not cached and no input_wav_path was provided.")
    if var not in vars_d:
        raise KeyError(f"Variable '{var}' not found in processed data.")
    arr = vars_d[var]
    if not isinstance(arr, np.ndarray):
        raise TypeError(f"Variable '{var}' is not a time-series ndarray (got {type(arr).__name__}).")
    return arr

def _slice_by_time(arr: np.ndarray, sr: int, t0: float, t1: float) -> Tuple[np.ndarray, np.ndarray]:
    """Return (time_sec, y) for [t0, t1] inclusive of t0 and exclusive of t1."""
    n = arr.shape[0]
    s0 = max(0, int(np.floor(t0 * sr)))
    s1 = min(n, int(np.ceil(t1 * sr)))
    if s1 <= s0:
        s1 = min(n, s0 + 1)
    t = np.arange(s0, s1) / float(sr)
    y = arr[s0:s1]
    return t, y

def _to_scalar_list(values) -> list[float]:
    """Normalize user-provided positions (scalar, array, nested iterables)
    into a flat list of floats suitable for axvline/axhline.
    """
    if values is None:
        return []
    try:
        import numpy as _np
    except Exception:
        _np = None

    def _flatten_one(v):
        outs = []
        if v is None:
            return outs
        # Treat strings as scalars (but will likely fail float conversion)
        if (_np is not None and _np.isscalar(v)) or isinstance(v, (int, float)):
            try:
                outs.append(float(v))
            except Exception:
                pass
            return outs
        # Try array-like
        try:
            if _np is not None:
                arr = _np.asarray(v).ravel()
                for item in arr:
                    if _np.isscalar(item):
                        try:
                            outs.append(float(item))
                        except Exception:
                            pass
                return outs
        except Exception:
            pass
        # Fallback: iterate if iterable
        try:
            for item in v:
                outs.extend(_flatten_one(item))
            return outs
        except Exception:
            # Last resort: try to cast
            try:
                outs.append(float(v))
            except Exception:
                pass
            return outs

    return _flatten_one(values)

def _positions_for_interval(values, interval_index: int, t0: float, t1: float, n_intervals: int) -> list[float]:
    """
    Determine which line positions to draw for this interval.
    - If `values` is scalar => same line every interval.
    - If 1D array-like length == n_intervals => pick value at `interval_index-1`.
    - If list/tuple of array-likes => apply rule to each and concatenate.
    - Otherwise (global array of many values) => include only those within [t0, t1].
    """
    import numpy as _np

    def _one(v):
        if v is None:
            return []
        if _np.isscalar(v) or isinstance(v, (int, float)):
            try:
                return [float(v)]
            except Exception:
                return []
        try:
            arr = _np.asarray(v).ravel()
        except Exception:
            # Not array-like: last resort attempt to cast to float
            try:
                return [float(v)]
            except Exception:
                return []
        L = arr.shape[0]
        if L == n_intervals:
            # Per-interval array
            try:
                return [float(arr[interval_index-1])]
            except Exception:
                return []
        # Global array of candidate positions: filter to the window
        outs = []
        for x in arr:
            try:
                xf = float(x)
            except Exception:
                continue
            if (xf >= t0) and (xf <= t1):
                outs.append(xf)
        return outs

    if isinstance(values, (list, tuple)):
        out = []
        for item in values:
            out.extend(_one(item))
        return out
    else:
        return _one(values)

def plot_intervals(
    output_folder: str,
    *,
    base_name: Optional[str] = None,
    input_wav_path: Optional[str] = None,
    plot_start_times: Iterable[float],
    plot_end_times: Iterable[float],
    plot_variables: Union[str, Sequence[str]],
    variable_column: Optional[Union[int, Sequence[int]]] = None,  # Column(s) for each variable (can be a list)
    ylabel: Optional[Union[str, Sequence[str]]] = None,  # Custom ylabel(s)
    ylim: Optional[Union[float, Tuple[float, float], Sequence[Union[float, Tuple[float, float]]]]] = None,  # Custom ylim(s)
    # optional behavior
    early_offset: float = 0.0,
    late_offset: float = 0.0,
    vertical_line_xpos: Optional[Iterable[float]] = None,
    horizontal_line_ypos: Optional[Iterable[float]] = None,
    # NEW: multichannel pretty options
    multichannel_pretty_ordering: Union[str, bool, Sequence[bool]] = 'variance',  # 'variance', 'magnitude', or True/False
    multichannel_pretty_transparency: Union[bool, Sequence[bool]] = False,  # per variable
    multichannel_skip_low_value_channels: Union[int, Sequence[int]] = 0,  # New argument to skip channels
    multichannel_variance_order_high_to_low: Union[bool, Sequence[bool]] = True,  # New argument to control variance order
    # styling (pass any matplotlib line kwargs here)
    primary_style: Optional[Dict[str, Any]] = None,
    vline_style: Optional[Dict[str, Any]] = None,
    hline_style: Optional[Dict[str, Any]] = None,
    # axes labels/limits
    xlabel: str = "Time (s)",
    xlim: Optional[Tuple[float, float]] = None,
    title_fmt: str = "Stim {i}, Duration: {dur_ms} ms",
    # PlotHandler passthrough
    display: bool = True,
    save: bool = False,
    displayAutoPause: Optional[float] = 10.0,
    savePath: Optional[str] = None,
    backend: Optional[str] = None,
    dpi: Optional[int] = None,
    # tick label formatting
    round_xticks_ms: bool = False,
):
    # Resolve cache filename
    if base_name:
        ppath = processed_path(output_folder, base_name)
    else:
        import glob
        pkls = glob.glob(os.path.join(output_folder, "*_processed_data.pkl"))
        if len(pkls) != 1:
            raise ValueError("Ambiguous cache: provide base_name or ensure exactly one processed_data file.")
        ppath = pkls[0]
        base_name = os.path.basename(ppath).rsplit("_processed_data.pkl", 1)[0]

    cache = load_cache(ppath)
    sr = cache.get("meta", {}).get("sr")
    if not sr:
        raise ValueError("Sample rate not found in cache meta. Re-run processing to populate meta.sr.")

    starts = list(plot_start_times)
    ends = list(plot_end_times)
    _require_equal_len(starts, ends, "plot_start_times", "plot_end_times")

    # Normalize plot_variables to a list
    if isinstance(plot_variables, str):
        var_list = [plot_variables]
    else:
        var_list = list(plot_variables)
    if not var_list:
        raise ValueError("plot_variables must be a non-empty string or list of strings.")

    # Normalize column input
    if variable_column is None:
        column_list = [None] * len(var_list)
    elif isinstance(variable_column, (list, tuple)):
        column_list = list(variable_column)
    else:
        column_list = [variable_column] * len(var_list)

    print(column_list)

    # Normalize ylabel input
    if ylabel is None:
        ylabel_list = [None] * len(var_list)
    elif isinstance(ylabel, str):
        ylabel_list = [ylabel] * len(var_list)
    else:
        ylabel_list = list(ylabel)

    # Normalize ylim input
    if ylim is None:
        ylim_list = [None] * len(var_list)
    elif isinstance(ylim, (list, tuple)):
        ylim_list = list(ylim)
    else:
        ylim_list = [ylim] * len(var_list)

    # Normalize multichannel_pretty_ordering
    if isinstance(multichannel_pretty_ordering, bool):
        multichannel_pretty_ordering_list = [multichannel_pretty_ordering] * len(var_list)
    else:
        multichannel_pretty_ordering_list = list(multichannel_pretty_ordering)

    # Normalize multichannel_pretty_transparency
    if isinstance(multichannel_pretty_transparency, bool):
        multichannel_pretty_transparency_list = [multichannel_pretty_transparency] * len(var_list)
    else:
        multichannel_pretty_transparency_list = list(multichannel_pretty_transparency)

    # Normalize multichannel_skip_low_value_channels
    if isinstance(multichannel_skip_low_value_channels, int):
        multichannel_skip_low_value_channels_list = [multichannel_skip_low_value_channels] * len(var_list)
    else:
        multichannel_skip_low_value_channels_list = list(multichannel_skip_low_value_channels)

    # Normalize multichannel_variance_order_high_to_low
    if isinstance(multichannel_variance_order_high_to_low, bool):
        multichannel_variance_order_high_to_low_list = [multichannel_variance_order_high_to_low] * len(var_list)
    else:
        multichannel_variance_order_high_to_low_list = list(multichannel_variance_order_high_to_low)

    # Pull arrays
    arrays = [_fetch_time_series(cache, v, input_wav_path=input_wav_path) for v in var_list]

    # Styles
    primary_style = dict(primary_style or {})
    vline_style = dict(vline_style or {})
    hline_style = dict(hline_style or {})

    if "linewidth" not in primary_style:
        primary_style["linewidth"] = 1.25
    if "linestyle" not in vline_style:
        vline_style["linestyle"] = "--"
    if "alpha" not in vline_style:
        vline_style["alpha"] = 0.7
    if "linestyle" not in hline_style:
        hline_style["linestyle"] = "--"
    if "alpha" not in hline_style:
        hline_style["alpha"] = 0.7

    # Stable per-channel color mapping (deterministic across runs)
    def _channel_color(ch_idx: int, channels_ordering):
        # Golden ratio hue stepping → well-spaced, stable hues
        h = (0.61803398875 * (ch_idx + 1)) % 1.0
        s = 0.65
        v = 0.95
        r, g, b = mcolors.hsv_to_rgb((h, s, v))
        return (r, g, b)

    # Sorting function for channels by magnitude or variance
    def sort_channels_by(order_type, data):
        if order_type == 'variance':
            # Sort channels based on variance of their signal
            return np.argsort(np.nanvar(data, axis=0))  # low variance first
        elif order_type == 'magnitude':
            # Sort channels based on the peak magnitude of the signal
            return np.argsort(np.max(np.abs(data), axis=0))  # low magnitude first
        else:
            raise ValueError("Invalid sorting type. Use 'variance' or 'magnitude'.")

    for i, (start_s, end_s) in enumerate(zip(starts, ends), start=1):
        t0 = float(start_s) - float(early_offset)
        t1 = float(end_s) + float(late_offset)
        if t1 <= t0:
            t1 = t0 + 1.0 / float(sr)

        # Pre-slice all variables for this window
        sliced = [ _slice_by_time(arr, sr, t0, t1) for arr in arrays ]  # list of (t_sec, seg)

        # Figure
        fig, axes = plt.subplots(nrows=len(var_list), ncols=1, sharex=True, figsize=(8, 3*len(var_list)))
        if not isinstance(axes, np.ndarray):
            axes = np.array([axes])

        # Title on the first axis
        dur_ms = int(round((float(end_s) - float(start_s)) * 1000.0))
        axes[0].set_title(title_fmt.format(i=i, dur_ms=dur_ms))

        for ax, (var_name, (t_sec, seg), col, lbl, ylim, ordering, transparency, skip_low, variance_order) in zip(axes, zip(var_list, sliced, column_list, ylabel_list, ylim_list, multichannel_pretty_ordering_list, multichannel_pretty_transparency_list, multichannel_skip_low_value_channels_list, multichannel_variance_order_high_to_low_list)):
            # Check if it's a multi-channel variable
            if seg.ndim > 1:  # multi-channel
                # Use column index if specified
                if col is not None:
                    seg = seg[:, col]  # Select the specific column (e.g., Azimuth or Elevation)
                    ax.plot(t_sec, seg, **primary_style)
                else:
                    # Determine the order type ('variance' or 'magnitude')
                    order_type = ordering if isinstance(ordering, str) else 'variance'
                    order = sort_channels_by(order_type, seg)

                    # Skip low-value channels if specified
                    if skip_low > 0:
                        var = np.nanvar(seg, axis=0)
                        skip_indices = np.argsort(var)[:skip_low]
                        low_value_channels = skip_indices

                    # Reverse order if specified
                    if not variance_order:
                        order = order[::-1]

                    base_alpha = 1.0
                    for rank, ch in enumerate(order):
                        if skip_low > 0 and ch in low_value_channels:
                            continue  # Skip low value channels
                        style = dict(primary_style)
                        style["color"] = _channel_color(int(ch), order)  # Color by sorting
                        if transparency:
                            # Linear transparency reduction from 1.0 to 0.5
                            alpha_mod = 1.0 - 0.5 * (rank / (seg.shape[1] - 1))
                            style["alpha"] = base_alpha * alpha_mod
                        ax.plot(t_sec, seg[:, ch], **style)

            # Primary axis plot (single channel)
            else:
                ax.plot(t_sec, seg, **primary_style)

            # Labels & limits
            if round_xticks_ms:
                ax.xaxis.set_major_formatter(FuncFormatter(lambda s, pos: f"{s:.3f}"))
            ax.set_xlabel(xlabel)
            if ylabel is None:
                ax.set_ylabel(var_name)
            else:
                ax.set_ylabel(lbl)  # Custom ylabel if specified
            if xlim:
                ax.set_xlim(xlim)
            if ylim is not None:
                ax.set_ylim(ylim)  # Custom ylim if specified

            # VERTICAL LINES
            vs = _positions_for_interval(vertical_line_xpos, i, t0, t1, len(starts))
            for vx in vs:
                ax.axvline(x=vx, **vline_style)

            # HORIZONTAL LINES
            hs = _positions_for_interval(horizontal_line_ypos, i, t0, t1, len(starts))
            for hy in hs:
                ax.axhline(y=hy, **hline_style)

        # Save/display handling
        ph_savePath = savePath
        if save and savePath:
            if os.path.isdir(savePath):
                ph_savePath = os.path.join(savePath, f"{base_name}_plot_{i:03d}.png")
            elif any(savePath.endswith(ext) for ext in (".png", ".jpg", ".jpeg", ".pdf")):
                root, ext = os.path.splitext(savePath)
                ph_savePath = f"{root}_{i:03d}{ext}"

        PlotHandler(
            fig,
            display=display,
            save=save,
            displayAutoPause=displayAutoPause,
            savePath=ph_savePath,
            backend=backend,
            dpi=dpi,
        )
        # PlotHandler closes fig




