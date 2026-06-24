"""Gaze cleaning utilities: blink interpolation, gap filling, and filtering.

Extracted from ``gaze_to_screen.py`` so these functions can be reused
independently of the screen-mapping pipeline.
"""

from __future__ import annotations

import logging
from typing import Optional

import numpy as np
import pandas as pd
from scipy.interpolate import PchipInterpolator

from .math_utils import (
    estimate_sampling_rate_from_timestamps,
    butterworth_lowpass_1d,
    butterworth_bandpass_1d,
    inverse_distance_weighted_average,
)

logger = logging.getLogger(__name__)

_MS_TO_NS: float = 1e6
_DEFAULT_BLINK_DURATION_NS: int = 150_000_000


# ---------------------------------------------------------------------------
# Main entry points
# ---------------------------------------------------------------------------

def clean_gaze_stream(
    gaze_df: pd.DataFrame,
    recording,
    *,
    method: str = "linear",
    blink_pad_ms: float = 50.0,
    lowpass_hz: Optional[float] = None,
) -> pd.DataFrame:
    """Interpolate blinks and optionally lowpass the gaze stream in-place.

    Works on the full continuous ``gaze_x_scene`` / ``gaze_y_scene`` columns
    before homography mapping. Supported methods are ``linear``, ``pchip``,
    ``nearest``, ``weighted_average``, and ``cubic``.
    """
    # --- Load blink events ---
    blinks = get_blink_events(recording)
    if blinks is None or blinks.empty:
        logger.info("No blink data — skipping gaze cleaning.")
        if lowpass_hz is not None:
            gaze_df = apply_lowpass(gaze_df, lowpass_hz)
        return gaze_df

    n_blinks = len(blinks)
    logger.info("Gaze cleaning: %d blinks, method=%s, pad=%.0f ms",
                n_blinks, method, blink_pad_ms)

    gaze_ts = gaze_df["timestamp_ns"].values
    x_vals = gaze_df["gaze_x_scene"].values.copy()
    y_vals = gaze_df["gaze_y_scene"].values.copy()

    # --- Build blink mask (sample indices) ---
    pad_ns = blink_pad_ms * _MS_TO_NS
    blink_mask = np.zeros(len(gaze_df), dtype=bool)

    for _, brow in blinks.iterrows():
        bstart_ns = brow["start_ns"] - pad_ns
        bend_ns = brow["end_ns"] + pad_ns
        blink_mask |= (gaze_ts >= bstart_ns) & (gaze_ts <= bend_ns)

    n_masked = int(blink_mask.sum())
    if n_masked == 0:
        logger.info("No gaze samples fall within blink periods.")
        if lowpass_hz is not None:
            gaze_df = apply_lowpass(gaze_df, lowpass_hz)
        return gaze_df

    logger.info("Masking %d / %d gaze samples (%.1f%%) for interpolation.",
                n_masked, len(gaze_df), 100.0 * n_masked / len(gaze_df))

    # --- Interpolate ---
    x_vals = interpolate_masked_segments(x_vals, blink_mask, method)
    y_vals = interpolate_masked_segments(y_vals, blink_mask, method)

    gaze_df["gaze_x_scene"] = x_vals
    gaze_df["gaze_y_scene"] = y_vals

    # --- Optional lowpass filter ---
    if lowpass_hz is not None:
        gaze_df = apply_lowpass(gaze_df, lowpass_hz)

    return gaze_df


def interpolate_missing_gaze(gaze_df: pd.DataFrame, method: str = "linear") -> pd.DataFrame:
    """Interpolate missing NaN gaps in gaze_x_scene and gaze_y_scene."""
    for col in ("gaze_x_scene", "gaze_y_scene"):
        vals = gaze_df[col].values.copy()
        nan_mask = np.isnan(vals)
        if not nan_mask.any():
            continue
        if method == "cubic":
            vals = cubic_interpolate(vals, nan_mask)
        else:
            vals = linear_interpolate(vals, nan_mask)
        gaze_df[col] = vals
    logger.info("Interpolated missing samples using method=%s", method)
    return gaze_df


def apply_cleaning_steps(
    gaze_df: pd.DataFrame,
    recording,
    clean_steps: list[dict],
) -> pd.DataFrame:
    """
    Apply ordered gaze-cleaning steps from UI pipeline.
    Supported step_type: interpolate_blinks, interpolate_missing,
    lowpass_filter, bandpass_filter.
    """
    out = gaze_df
    for st in clean_steps:
        if not isinstance(st, dict) or not bool(st.get("enabled", True)):
            continue
        stype = str(st.get("step_type", "")).strip().lower()
        params = st.get("params", {}) or {}
        if stype == "interpolate_blinks":
            out = clean_gaze_stream(
                out,
                recording,
                method=str(params.get("method", "linear")),
                blink_pad_ms=float(params.get("blink_padding_ms", 50.0)),
                lowpass_hz=None,
            )
        elif stype == "interpolate_missing":
            out = interpolate_missing_gaze(
                out,
                method=str(params.get("method", "linear")),
            )
        elif stype == "lowpass_filter":
            out = apply_lowpass(
                out,
                cutoff_hz=float(params.get("cutoff_hz", 30.0)),
                order=int(params.get("order", 2)),
            )
        elif stype == "bandpass_filter":
            out = apply_bandpass(
                out,
                low_hz=float(params.get("low_hz", 0.5)),
                high_hz=float(params.get("high_hz", 30.0)),
                order=int(params.get("order", 2)),
            )
        else:
            logger.warning("Unknown cleaning step '%s' ignored.", stype)
    return out


# ---------------------------------------------------------------------------
# Blink extraction
# ---------------------------------------------------------------------------

def _extract_stream_df(stream, label: str) -> pd.DataFrame:
    """Extract a DataFrame from a neon_recording stream object."""
    if stream is None:
        return pd.DataFrame()
    if hasattr(stream, "pd"):
        df = stream.pd
        if isinstance(df, pd.DataFrame) and len(df) > 0:
            return df.copy()
    if hasattr(stream, "data"):
        data = stream.data
        if hasattr(data, "dtype") and data.dtype.names:
            return pd.DataFrame(data)
    if isinstance(stream, pd.DataFrame) and len(stream) > 0:
        return stream.copy()
    return pd.DataFrame()


def get_blink_events(recording) -> Optional[pd.DataFrame]:
    """Extract blink start/end timestamps in nanoseconds from the recording."""
    try:
        blinks_stream = getattr(recording, "blinks", None)
    except Exception:
        logger.debug("Failed to access blinks stream from recording", exc_info=True)
        return None
    if blinks_stream is None:
        return None

    try:
        df = _extract_stream_df(blinks_stream, "blinks")
    except Exception:
        logger.debug("Failed to extract blinks DataFrame", exc_info=True)
        return None
    if df.empty:
        return None

    # Standardise columns to start_ns / end_ns
    start_col, end_col = None, None
    for c in ["start_time", "time", "timestamp_ns", "timestamp [ns]"]:
        if c in df.columns:
            start_col = c
            break
    for c in ["stop_time", "end_time", "end_time_ns", "end timestamp [ns]"]:
        if c in df.columns:
            end_col = c
            break

    if start_col is None:
        return None

    starts = df[start_col].values.astype(float)
    if end_col is not None:
        ends = df[end_col].values.astype(float)
    else:
        # Estimate ~150ms blink duration if no end column
        ends = starts + _DEFAULT_BLINK_DURATION_NS

    result = pd.DataFrame({"start_ns": starts, "end_ns": ends})
    return result


# ---------------------------------------------------------------------------
# Interpolation primitives
# ---------------------------------------------------------------------------

def interpolate_masked_segments(signal: np.ndarray, mask: np.ndarray, method: str) -> np.ndarray:
    """
    Interpolate contiguous masked segments using local boundary anchors only.

    This avoids global extrapolation artifacts and keeps behavior consistent
    with preprocessing interpolation.
    """
    out = signal.copy()
    n = len(out)
    if n == 0:
        return out

    m = np.asarray(mask, dtype=bool)
    if not np.any(m):
        return out

    idx = np.where(m)[0]
    starts = [idx[0]]
    ends = []
    for j in range(1, len(idx)):
        if idx[j] != idx[j - 1] + 1:
            ends.append(idx[j - 1])
            starts.append(idx[j])
    ends.append(idx[-1])

    x_all = np.arange(n, dtype=float)
    method = (method or "linear").lower()
    if method == "weighted":
        method = "weighted_average"
    supported = {"linear", "pchip", "nearest", "weighted_average", "cubic"}
    if method not in supported:
        logger.warning("Unknown interpolation method '%s'; falling back to linear.", method)
        method = "linear"

    for seg_start, seg_end in zip(starts, ends):
        # Find nearest valid sample before segment.
        left = seg_start - 1
        while left >= 0:
            if (not m[left]) and np.isfinite(out[left]):
                break
            left -= 1

        # Find nearest valid sample after segment.
        right = seg_end + 1
        while right < n:
            if (not m[right]) and np.isfinite(out[right]):
                break
            right += 1

        has_left = left >= 0
        has_right = right < n

        if has_left and has_right:
            x_seg = x_all[seg_start:seg_end + 1]
            x0, x1 = float(left), float(right)
            y0, y1 = float(out[left]), float(out[right])

            if method == "nearest":
                mid = (x0 + x1) / 2.0
                out[seg_start:seg_end + 1] = np.where(x_seg <= mid, y0, y1)
                continue

            if method in {"pchip", "weighted_average", "cubic"}:
                # Local support using up to three valid points per side.
                support_left = []
                k = left
                while k >= 0 and len(support_left) < 3:
                    if (not m[k]) and np.isfinite(out[k]):
                        support_left.append(k)
                    k -= 1
                support_right = []
                k = right
                while k < n and len(support_right) < 3:
                    if (not m[k]) and np.isfinite(out[k]):
                        support_right.append(k)
                    k += 1
                support_idx = sorted(set(support_left + support_right))

                if method == "weighted_average" and len(support_idx) >= 2:
                    out[seg_start:seg_end + 1] = inverse_distance_weighted_average(
                        query_points=x_seg,
                        support_points=x_all[support_idx],
                        support_values=out[support_idx],
                    )
                    continue

                if method == "pchip" and len(support_idx) >= 2:
                    try:
                        y_seg = PchipInterpolator(
                            x_all[support_idx],
                            out[support_idx].astype(float),
                            extrapolate=False,
                        )(x_seg)
                        if np.all(np.isfinite(y_seg)):
                            out[seg_start:seg_end + 1] = y_seg
                            continue
                    except Exception:
                        logger.debug("PCHIP failed for segment %d:%d; falling back to linear", seg_start, seg_end)

                if method == "cubic" and len(support_idx) >= 4:
                    xs = x_all[support_idx]
                    ys = out[support_idx].astype(float)
                    try:
                        coeffs = np.polyfit(xs, ys, deg=3)
                        y_seg = np.polyval(coeffs, x_seg)
                        if np.all(np.isfinite(y_seg)):
                            out[seg_start:seg_end + 1] = y_seg
                            continue
                    except Exception:
                        logger.debug("Cubic polyfit failed for segment %d:%d; falling back to linear", seg_start, seg_end)

            # Linear boundary interpolation (default/fallback).
            out[seg_start:seg_end + 1] = np.interp(x_seg, [x0, x1], [y0, y1])
        elif has_left:
            out[seg_start:seg_end + 1] = out[left]
        elif has_right:
            out[seg_start:seg_end + 1] = out[right]
        else:
            continue

    return out


def linear_interpolate(signal: np.ndarray, mask: np.ndarray) -> np.ndarray:
    """Linear interpolation with local boundary anchoring."""
    return interpolate_masked_segments(signal, mask, method="linear")


def cubic_interpolate(signal: np.ndarray, mask: np.ndarray) -> np.ndarray:
    """Cubic interpolation with local boundary anchoring and linear fallback."""
    return interpolate_masked_segments(signal, mask, method="cubic")


# ---------------------------------------------------------------------------
# Frequency-domain filters
# ---------------------------------------------------------------------------

def apply_lowpass(
    gaze_df: pd.DataFrame,
    cutoff_hz: float,
    order: int = 2,
) -> pd.DataFrame:
    """Apply a Butterworth lowpass filter to gaze_x_scene and gaze_y_scene."""
    # Estimate sampling rate from timestamps
    ts = gaze_df["timestamp_ns"].values
    if len(ts) < 10:
        return gaze_df
    fs = estimate_sampling_rate_from_timestamps(ts)
    if fs <= 0:
        return gaze_df

    nyq = fs / 2.0
    if cutoff_hz >= nyq:
        logger.warning("Lowpass cutoff %.1f Hz >= Nyquist %.1f Hz — skipping.", cutoff_hz, nyq)
        return gaze_df

    for col in ("gaze_x_scene", "gaze_y_scene"):
        try:
            gaze_df[col] = butterworth_lowpass_1d(
                signal=gaze_df[col].values,
                cutoff_hz=cutoff_hz,
                fs=fs,
                order=order,
            )
        except Exception as e:
            logger.warning("Lowpass filtering failed for %s: %s", col, e)

    logger.info("Lowpass filter applied: %.1f Hz (fs=%.0f Hz).", cutoff_hz, fs)
    return gaze_df


def apply_bandpass(
    gaze_df: pd.DataFrame,
    low_hz: float,
    high_hz: float,
    order: int = 2,
) -> pd.DataFrame:
    """Apply a Butterworth bandpass filter to gaze_x_scene and gaze_y_scene.

    For gaze-position coordinates, raw bandpass output is zero-centered and can
    make mapped points appear collapsed/off-screen. We therefore restore the
    original per-axis mean after filtering.
    """
    ts = gaze_df["timestamp_ns"].values
    if len(ts) < 10:
        return gaze_df
    fs = estimate_sampling_rate_from_timestamps(ts)
    if fs <= 0:
        return gaze_df

    nyq = fs / 2.0
    if low_hz <= 0:
        low_hz = 0.01
    if high_hz <= low_hz:
        logger.warning(
            "Bandpass high cutoff %.3f Hz <= low cutoff %.3f Hz — skipping.",
            high_hz,
            low_hz,
        )
        return gaze_df
    if high_hz >= nyq:
        logger.warning("Bandpass high cutoff %.1f Hz >= Nyquist %.1f Hz — skipping.", high_hz, nyq)
        return gaze_df

    for col in ("gaze_x_scene", "gaze_y_scene"):
        try:
            gaze_df[col] = butterworth_bandpass_1d(
                signal=gaze_df[col].values,
                low_hz=low_hz,
                high_hz=high_hz,
                fs=fs,
                order=order,
                restore_mean=True,
            )
        except Exception as e:
            logger.warning("Bandpass filtering failed for %s: %s", col, e)

    logger.info(
        "Bandpass filter applied: %.3f-%.3f Hz (order=%d, fs=%.0f Hz, mean-restored).",
        low_hz,
        high_hz,
        order,
        fs,
    )
    return gaze_df
