"""
Preprocessing Pipeline

Provides preprocessing functions for eye-tracking data including:
- Blink interpolation
- Missing data interpolation
- Filtering (lowpass, bandpass)
- Artifact detection
- Trial rejection

Uses scipy for signal processing.
"""

import logging
from typing import List, Tuple, Optional
import numpy as np
import pandas as pd
from scipy.interpolate import interp1d, PchipInterpolator
from .math_utils import (
    inverse_distance_weighted_average,
    estimate_sampling_rate_from_timestamps,
    butterworth_lowpass_1d,
    butterworth_bandpass_1d,
)

logger = logging.getLogger(__name__)


class PreprocessingPipeline:
    """
    Preprocessing pipeline for eye-tracking data.

    Provides methods for interpolation, filtering, artifact detection,
    and trial rejection. All methods operate on pandas DataFrames with
    a 'timestamp' column.
    """

    def interpolate_blinks(
        self,
        data: pd.DataFrame,
        blinks: pd.DataFrame,
        columns: Optional[List[str]] = None,
        method: str = 'linear',
        margin_ms: float = 50.0
    ) -> pd.DataFrame:
        """
        Interpolate data during blink periods.

        Extends blink windows by margin to catch partial blinks and
        post-blink artifacts.

        Args:
            data: DataFrame with 'timestamp' column and signal columns
            blinks: DataFrame with 'start_timestamp' and 'end_timestamp' columns
            columns: List of columns to interpolate (default: all numeric except timestamp)
            method: Interpolation method ('linear', 'cubic', 'pchip', 'nearest', 'weighted_average')
            margin_ms: Margin in milliseconds to extend blink windows

        Returns:
            DataFrame with interpolated values during blink periods
        """
        if data is None or data.empty:
            return data

        if blinks is None or blinks.empty:
            return data.copy()

        result = data.copy()

        # Determine columns to interpolate
        if columns is None:
            columns = [col for col in result.columns
                       if col != 'timestamp' and pd.api.types.is_numeric_dtype(result[col])]

        if not columns:
            return result

        # Convert margin to seconds
        margin_s = margin_ms / 1000.0

        # Normalize timestamp to a single Series even if duplicate column names exist.
        timestamps = result['timestamp']
        if isinstance(timestamps, pd.DataFrame):
            timestamps = timestamps.iloc[:, 0]

        # Create blink mask
        blink_mask = np.zeros(len(result), dtype=bool)

        for _, blink in blinks.iterrows():
            start = blink.get('start_timestamp', blink.get('timestamp', np.nan))
            end = blink.get('end_timestamp', start)

            if pd.isna(start):
                continue

            # Extend window by margin
            start_extended = start - margin_s
            end_extended = end + margin_s

            mask = (timestamps >= start_extended) & (timestamps <= end_extended)
            blink_mask |= mask.to_numpy(dtype=bool, copy=False)

        # Interpolate each column
        for col in columns:
            if col not in result.columns:
                continue

            # Interpolate contiguous blink segments using local boundaries only.
            # This avoids global extrapolation artifacts when a blink segment
            # touches the beginning/end of an epoch.
            try:
                values = result[col].to_numpy(copy=True)
                times = timestamps.to_numpy()
                n = len(values)
                if n == 0:
                    continue

                segment_mask = blink_mask.copy()
                if not np.any(segment_mask):
                    continue

                # Find contiguous True segments in blink mask: [start, end] inclusive.
                idx = np.where(segment_mask)[0]
                starts = [idx[0]]
                ends = []
                for j in range(1, len(idx)):
                    if idx[j] != idx[j - 1] + 1:
                        ends.append(idx[j - 1])
                        starts.append(idx[j])
                ends.append(idx[-1])

                for seg_start, seg_end in zip(starts, ends):
                    # Find nearest valid sample on the left (outside blink mask).
                    left = seg_start - 1
                    while left >= 0:
                        if (not segment_mask[left]) and np.isfinite(values[left]):
                            break
                        left -= 1

                    # Find nearest valid sample on the right (outside blink mask).
                    right = seg_end + 1
                    while right < n:
                        if (not segment_mask[right]) and np.isfinite(values[right]):
                            break
                        right += 1

                    has_left = left >= 0
                    has_right = right < n

                    if has_left and has_right:
                        seg_times = times[seg_start:seg_end + 1]
                        left_t, right_t = times[left], times[right]
                        left_v, right_v = values[left], values[right]

                        interp_method = str(method).lower()
                        if interp_method == 'nearest':
                            mid_t = (left_t + right_t) / 2.0
                            interp_vals = np.where(seg_times <= mid_t, left_v, right_v)
                        elif interp_method in ('cubic', 'pchip'):
                            # Local cubic interpolation using nearby boundary support
                            # points only (no global extrapolation).
                            support_left = []
                            k = left
                            while k >= 0 and len(support_left) < 2:
                                if (not segment_mask[k]) and np.isfinite(values[k]):
                                    support_left.append(k)
                                k -= 1
                            support_right = []
                            k = right
                            while k < n and len(support_right) < 2:
                                if (not segment_mask[k]) and np.isfinite(values[k]):
                                    support_right.append(k)
                                k += 1
                            support_idx = np.array(sorted(set(support_left + support_right)), dtype=int)

                            if len(support_idx) >= 4:
                                try:
                                    if interp_method == 'pchip':
                                        pchip_func = PchipInterpolator(
                                            times[support_idx],
                                            values[support_idx],
                                            extrapolate=False,
                                        )
                                        interp_vals = pchip_func(seg_times)
                                    else:
                                        cubic_func = interp1d(
                                            times[support_idx],
                                            values[support_idx],
                                            kind='cubic',
                                            bounds_error=True,
                                        )
                                        interp_vals = cubic_func(seg_times)
                                    if not np.all(np.isfinite(interp_vals)):
                                        interp_vals = np.interp(
                                            seg_times,
                                            [left_t, right_t],
                                            [left_v, right_v],
                                        )
                                except Exception:
                                    interp_vals = np.interp(
                                        seg_times,
                                        [left_t, right_t],
                                        [left_v, right_v],
                                    )
                            else:
                                interp_vals = np.interp(
                                    seg_times,
                                    [left_t, right_t],
                                    [left_v, right_v],
                                )
                        elif interp_method in ('weighted_average', 'weighted'):
                            support_left = []
                            k = left
                            while k >= 0 and len(support_left) < 3:
                                if (not segment_mask[k]) and np.isfinite(values[k]):
                                    support_left.append(k)
                                k -= 1
                            support_right = []
                            k = right
                            while k < n and len(support_right) < 3:
                                if (not segment_mask[k]) and np.isfinite(values[k]):
                                    support_right.append(k)
                                k += 1
                            support_idx = np.array(sorted(set(support_left + support_right)), dtype=int)
                            if len(support_idx) >= 2:
                                interp_vals = inverse_distance_weighted_average(
                                    query_points=seg_times,
                                    support_points=times[support_idx],
                                    support_values=values[support_idx],
                                )
                            else:
                                interp_vals = np.interp(
                                    seg_times,
                                    [left_t, right_t],
                                    [left_v, right_v],
                                )
                        else:
                            # Linear boundary interpolation is the robust default
                            # for blink reconstruction within an epoch.
                            interp_vals = np.interp(
                                seg_times,
                                [left_t, right_t],
                                [left_v, right_v],
                            )
                        values[seg_start:seg_end + 1] = interp_vals
                    elif has_left:
                        # No right anchor available: hold last valid value.
                        values[seg_start:seg_end + 1] = values[left]
                    elif has_right:
                        # No left anchor available: hold next valid value.
                        values[seg_start:seg_end + 1] = values[right]
                    else:
                        # No anchors available, leave unchanged.
                        continue

                result[col] = values
            except Exception as e:
                logger.warning("Could not interpolate column %s: %s", col, e)

        return result

    def interpolate_missing(
        self,
        data: pd.DataFrame,
        columns: Optional[List[str]] = None,
        method: str = 'linear',
        max_gap_ms: float = 100.0
    ) -> pd.DataFrame:
        """
        Interpolate short gaps of missing data.

        Gaps longer than max_gap_ms are left as NaN.

        Args:
            data: DataFrame with 'timestamp' column and signal columns
            columns: List of columns to interpolate (default: all numeric except timestamp)
            method: Interpolation method ('linear', 'cubic', 'pchip', 'nearest', 'weighted_average')
            max_gap_ms: Maximum gap duration in milliseconds to interpolate

        Returns:
            DataFrame with interpolated short gaps
        """
        if data is None or data.empty:
            return data

        result = data.copy()

        if columns is None:
            columns = [col for col in result.columns
                       if col != 'timestamp' and pd.api.types.is_numeric_dtype(result[col])]

        if not columns:
            return result

        max_gap_s = max_gap_ms / 1000.0

        for col in columns:
            if col not in result.columns:
                continue

            values = result[col].values.copy()
            times = result['timestamp'].values

            # Find NaN regions
            is_nan = np.isnan(values)
            if not is_nan.any():
                continue

            # Find gap boundaries
            nan_diff = np.diff(is_nan.astype(int))
            gap_starts = np.where(nan_diff == 1)[0] + 1
            gap_ends = np.where(nan_diff == -1)[0] + 1

            # Handle edge cases
            if is_nan[0]:
                gap_starts = np.insert(gap_starts, 0, 0)
            if is_nan[-1]:
                gap_ends = np.append(gap_ends, len(values))

            # Interpolate short gaps
            for start_idx, end_idx in zip(gap_starts, gap_ends):
                if start_idx == 0 or end_idx >= len(values):
                    continue

                gap_duration = times[end_idx - 1] - times[start_idx]

                if gap_duration <= max_gap_s:
                    # Get boundary values for interpolation
                    left_idx = start_idx - 1
                    right_idx = end_idx

                    if right_idx < len(values) and not np.isnan(values[left_idx]) and not np.isnan(values[right_idx]):
                        gap_times = times[start_idx:end_idx]
                        interp_method = str(method).lower()
                        if interp_method == 'nearest':
                            mid_t = (times[left_idx] + times[right_idx]) / 2.0
                            interp_values = np.where(
                                gap_times <= mid_t,
                                values[left_idx],
                                values[right_idx],
                            )
                        elif interp_method == 'pchip':
                            interp_values = PchipInterpolator(
                                np.array([times[left_idx], times[right_idx]], dtype=float),
                                np.array([values[left_idx], values[right_idx]], dtype=float),
                                extrapolate=False,
                            )(gap_times)
                        elif interp_method in ('weighted_average', 'weighted'):
                            interp_values = inverse_distance_weighted_average(
                                query_points=gap_times,
                                support_points=np.array([times[left_idx], times[right_idx]], dtype=float),
                                support_values=np.array([values[left_idx], values[right_idx]], dtype=float),
                            )
                        else:
                            interp_values = np.interp(
                                gap_times,
                                [times[left_idx], times[right_idx]],
                                [values[left_idx], values[right_idx]]
                            )
                        values[start_idx:end_idx] = interp_values

            result[col] = values

        return result

    def lowpass_filter(
        self,
        data: pd.DataFrame,
        columns: List[str],
        cutoff_hz: float = 10.0,
        fs: Optional[float] = None,
        order: int = 2
    ) -> pd.DataFrame:
        """
        Apply Butterworth lowpass filter.

        Useful for smoothing pupil data and removing high-frequency noise.

        Args:
            data: DataFrame with 'timestamp' column and signal columns
            columns: List of columns to filter
            cutoff_hz: Cutoff frequency in Hz
            fs: Sampling frequency (estimated from data if not provided)
            order: Filter order

        Returns:
            DataFrame with filtered signals
        """
        if data is None or data.empty:
            return data

        result = data.copy()

        # Estimate sampling frequency if not provided
        if fs is None:
            fs = self._estimate_sampling_rate(result)

        if fs <= 0 or fs <= 2 * cutoff_hz:
            logger.warning("Cannot apply %.1fHz lowpass filter with sampling rate %.1fHz", cutoff_hz, fs)
            return result

        for col in columns:
            if col not in result.columns:
                continue

            try:
                result[col] = butterworth_lowpass_1d(
                    signal=result[col].values,
                    cutoff_hz=cutoff_hz,
                    fs=fs,
                    order=order,
                )
            except Exception as e:
                logger.warning("Could not filter column %s: %s", col, e)

        return result

    def bandpass_filter(
        self,
        data: pd.DataFrame,
        columns: List[str],
        low_hz: float = 0.01,
        high_hz: float = 4.0,
        fs: Optional[float] = None,
        order: int = 2
    ) -> pd.DataFrame:
        """
        Apply Butterworth bandpass filter.

        Useful for analyzing pupil oscillations in specific frequency bands.

        Args:
            data: DataFrame with 'timestamp' column and signal columns
            columns: List of columns to filter
            low_hz: Low cutoff frequency in Hz
            high_hz: High cutoff frequency in Hz
            fs: Sampling frequency (estimated from data if not provided)
            order: Filter order

        Returns:
            DataFrame with filtered signals
        """
        if data is None or data.empty:
            return data

        result = data.copy()

        if fs is None:
            fs = self._estimate_sampling_rate(result)

        if fs <= 0 or fs <= 2 * high_hz:
            logger.warning("Cannot apply bandpass filter with sampling rate %.1fHz", fs)
            return result

        for col in columns:
            if col not in result.columns:
                continue

            try:
                result[col] = butterworth_bandpass_1d(
                    signal=result[col].values,
                    low_hz=low_hz,
                    high_hz=high_hz,
                    fs=fs,
                    order=order,
                    restore_mean=False,
                )
            except Exception as e:
                logger.warning("Could not filter column %s: %s", col, e)

        return result

    def detect_artifacts(
        self,
        gaze: pd.DataFrame,
        velocity_threshold: float = 1000.0,
        min_duration_ms: float = 50.0
    ) -> pd.DataFrame:
        """
        Detect artifacts based on implausible gaze velocities.

        High velocities that are not saccades (too fast, too long) are
        marked as artifacts.

        Args:
            gaze: DataFrame with 'timestamp', 'x', 'y' columns
            velocity_threshold: Maximum plausible velocity in degrees/second
            min_duration_ms: Minimum duration to consider as artifact

        Returns:
            DataFrame with added 'is_artifact' and 'velocity' columns
        """
        if gaze is None or gaze.empty:
            return gaze

        result = gaze.copy()

        if 'x' not in result.columns or 'y' not in result.columns:
            result['is_artifact'] = False
            result['velocity'] = 0.0
            return result

        # Calculate velocity
        dt = np.diff(result['timestamp'].values)
        dx = np.diff(result['x'].values)
        dy = np.diff(result['y'].values)

        # Avoid division by zero
        dt[dt == 0] = 1e-10

        # Calculate velocity magnitude (assuming pixels, convert if needed)
        velocity = np.sqrt(dx**2 + dy**2) / dt

        # Pad velocity array to match original length
        velocity = np.concatenate([[0], velocity])

        result['velocity'] = velocity

        # Initial artifact mask based on velocity
        artifact_mask = velocity > velocity_threshold

        # Find artifact regions and filter by duration
        min_duration_s = min_duration_ms / 1000.0

        # Find contiguous artifact regions
        artifact_diff = np.diff(artifact_mask.astype(int))
        starts = np.where(artifact_diff == 1)[0] + 1
        ends = np.where(artifact_diff == -1)[0] + 1

        if artifact_mask[0]:
            starts = np.insert(starts, 0, 0)
        if artifact_mask[-1]:
            ends = np.append(ends, len(artifact_mask))

        # Filter short artifacts (likely saccades)
        filtered_mask = np.zeros_like(artifact_mask)

        for start, end in zip(starts, ends):
            duration = result['timestamp'].iloc[end - 1] - result['timestamp'].iloc[start]
            if duration >= min_duration_s:
                filtered_mask[start:end] = True

        result['is_artifact'] = filtered_mask

        return result

    def reject_trials(
        self,
        trials: List[pd.DataFrame],
        max_missing_pct: float = 30.0,
        max_blink_pct: float = 50.0,
        signal_column: Optional[str] = None
    ) -> Tuple[List[pd.DataFrame], List[int], List[str]]:
        """
        Reject trials with too much missing data or blinks.

        Args:
            trials: List of trial DataFrames
            max_missing_pct: Maximum percentage of missing data allowed
            max_blink_pct: Maximum percentage of blink data allowed
            signal_column: Column to check for missing data (default: first numeric column)

        Returns:
            Tuple of:
                - good_trials: List of trials that passed rejection criteria
                - rejected_indices: List of indices of rejected trials
                - rejection_reasons: List of reasons for rejection
        """
        good_trials = []
        rejected_indices = []
        rejection_reasons = []

        for i, trial in enumerate(trials):
            if trial is None or trial.empty:
                rejected_indices.append(i)
                rejection_reasons.append("empty_trial")
                continue

            # Determine signal column
            if signal_column is None:
                numeric_cols = [col for col in trial.columns
                               if col != 'timestamp' and pd.api.types.is_numeric_dtype(trial[col])]
                if not numeric_cols:
                    rejected_indices.append(i)
                    rejection_reasons.append("no_numeric_columns")
                    continue
                check_col = numeric_cols[0]
            else:
                check_col = signal_column

            if check_col not in trial.columns:
                rejected_indices.append(i)
                rejection_reasons.append(f"missing_column_{check_col}")
                continue

            # Calculate missing percentage
            total_samples = len(trial)
            missing_samples = trial[check_col].isna().sum()
            missing_pct = (missing_samples / total_samples) * 100 if total_samples > 0 else 100

            # Check for blink markers if available
            blink_pct = 0.0
            if 'is_blink' in trial.columns:
                blink_samples = trial['is_blink'].sum()
                blink_pct = (blink_samples / total_samples) * 100 if total_samples > 0 else 0

            # Apply rejection criteria
            if missing_pct > max_missing_pct:
                rejected_indices.append(i)
                rejection_reasons.append(f"missing_data_{missing_pct:.1f}%")
            elif blink_pct > max_blink_pct:
                rejected_indices.append(i)
                rejection_reasons.append(f"blink_data_{blink_pct:.1f}%")
            else:
                good_trials.append(trial)

        return good_trials, rejected_indices, rejection_reasons

    def baseline_correct(
        self,
        data: pd.DataFrame,
        columns: List[str],
        baseline_start_s: float,
        baseline_end_s: float,
        method: str = 'subtract_mean'
    ) -> pd.DataFrame:
        """
        Apply baseline correction to signals.

        Args:
            data: DataFrame with 'timestamp' column (relative to event)
            columns: List of columns to baseline correct
            baseline_start_s: Start of baseline period (in seconds)
            baseline_end_s: End of baseline period (in seconds)
            method: 'subtract_mean', 'divide_mean', or 'z_score'

        Returns:
            DataFrame with baseline-corrected signals
        """
        if data is None or data.empty:
            return data

        result = data.copy()

        # Find baseline period
        # Assuming timestamp is relative to event (e.g., from -0.5 to 1.0)
        if 'relative_time' in result.columns:
            time_col = 'relative_time'
        else:
            time_col = 'timestamp'

        baseline_mask = (result[time_col] >= baseline_start_s) & (result[time_col] <= baseline_end_s)

        if not baseline_mask.any():
            logger.warning("No samples in baseline period [%s, %s]", baseline_start_s, baseline_end_s)
            return result

        for col in columns:
            if col not in result.columns:
                continue

            baseline_values = result.loc[baseline_mask, col].dropna()

            if len(baseline_values) == 0:
                continue

            baseline_mean = baseline_values.mean()
            baseline_std = baseline_values.std()

            if method == 'subtract_mean':
                result[col] = result[col] - baseline_mean
            elif method == 'divide_mean':
                if baseline_mean != 0:
                    result[col] = result[col] / baseline_mean
            elif method == 'z_score':
                if baseline_std > 0:
                    result[col] = (result[col] - baseline_mean) / baseline_std

        return result

    def mark_blink_periods(
        self,
        data: pd.DataFrame,
        blinks: pd.DataFrame,
        margin_ms: float = 50.0
    ) -> pd.DataFrame:
        """
        Add 'is_blink' column marking samples during blink periods.

        Args:
            data: DataFrame with 'timestamp' column
            blinks: DataFrame with blink events
            margin_ms: Margin to extend blink periods

        Returns:
            DataFrame with 'is_blink' boolean column
        """
        if data is None or data.empty:
            return data

        result = data.copy()
        result['is_blink'] = False

        if blinks is None or blinks.empty:
            return result

        margin_s = margin_ms / 1000.0

        for _, blink in blinks.iterrows():
            start = blink.get('start_timestamp', blink.get('timestamp', np.nan))
            end = blink.get('end_timestamp', start)

            if pd.isna(start):
                continue

            start_extended = start - margin_s
            end_extended = end + margin_s

            mask = (result['timestamp'] >= start_extended) & (result['timestamp'] <= end_extended)
            result.loc[mask, 'is_blink'] = True

        return result

    def _estimate_sampling_rate(self, data: pd.DataFrame) -> float:
        """Estimate sampling rate from timestamp differences."""
        if data is None or len(data) < 2:
            return 0.0

        if 'timestamp' not in data.columns:
            return 0.0

        return estimate_sampling_rate_from_timestamps(data['timestamp'].values)


def preprocess_recording(
    recording,
    interpolate_blinks: bool = True,
    interpolate_missing: bool = True,
    lowpass_hz: Optional[float] = 10.0,
    blink_margin_ms: float = 50.0,
    max_gap_ms: float = 100.0
) -> 'NeonRecording':
    """
    Apply standard preprocessing to a NeonRecording.

    Convenience function that applies common preprocessing steps:
    1. Mark blink periods in gaze data
    2. Interpolate blinks in pupil data
    3. Interpolate short missing gaps
    4. Apply lowpass filter to pupil data

    Args:
        recording: NeonRecording to preprocess
        interpolate_blinks: Whether to interpolate blink periods
        interpolate_missing: Whether to interpolate short gaps
        lowpass_hz: Cutoff frequency for lowpass filter (None to skip)
        blink_margin_ms: Margin for blink windows
        max_gap_ms: Maximum gap to interpolate

    Returns:
        Preprocessed NeonRecording (modified in place and returned)
    """
    from .recording_helpers import NeonRecording

    pipeline = PreprocessingPipeline()

    # Mark blink periods in gaze data
    if recording.has_gaze and recording.has_blinks:
        recording.gaze = pipeline.mark_blink_periods(
            recording.gaze,
            recording.blinks,
            margin_ms=blink_margin_ms
        )

    # Preprocess pupil data
    if recording.has_pupil:
        pupil_cols = [col for col in recording.pupil.columns
                     if 'pupil' in col.lower()]

        if interpolate_blinks and recording.has_blinks:
            recording.pupil = pipeline.interpolate_blinks(
                recording.pupil,
                recording.blinks,
                columns=pupil_cols,
                margin_ms=blink_margin_ms
            )

        if interpolate_missing:
            recording.pupil = pipeline.interpolate_missing(
                recording.pupil,
                columns=pupil_cols,
                max_gap_ms=max_gap_ms
            )

        if lowpass_hz is not None and pupil_cols:
            recording.pupil = pipeline.lowpass_filter(
                recording.pupil,
                columns=pupil_cols,
                cutoff_hz=lowpass_hz
            )

    return recording
