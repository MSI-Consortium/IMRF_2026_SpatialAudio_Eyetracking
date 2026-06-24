
import numpy as np
import math

_NS_PER_SECOND: float = 1e9
_MIN_BANDPASS_HZ: float = 0.001


def apply_lp_filter(data, cutoff_hz, dt):
    """
    Implements a first-order IIR Low Pass Filter.
    y_new = (y_old + omega0 * dt * x_new) / (omega0 * dt + 1)
    
    Args:
        data (np.ndarray): The 1D input signal.
        cutoff_hz (float): The cutoff frequency of the filter in Hz.
        dt (float): The time step between samples (1 / sampling_rate).
        
    Returns:
        np.ndarray: The filtered output signal.
    """
    n = len(data)
    if n == 0:
        return data
    
    y = np.zeros(n)
    
    # Omega0 = 2 * PI * frequency
    omega0 = 2.0 * math.pi * cutoff_hz
    
    # Coefficients
    alpha = omega0 * dt
    denom = alpha + 1.0
    
    # Initialize first value
    y[0] = data[0] 
    
    # Recursive Loop
    for i in range(1, n):
        x_new = data[i]   # Current Raw Input
        y_old = y[i-1]    # Previous Filtered Output
        
        y[i] = (y_old + alpha * x_new) / denom
        
    return y


def estimate_sampling_rate_from_timestamps(
    timestamps: np.ndarray,
    max_samples: int = 2000,
    assume_nanoseconds_if_dt_gt: float = 1e6,
) -> float:
    """Estimate sampling rate from timestamp differences.

    Args:
        timestamps: Monotonic timestamp array in seconds or nanoseconds.
        max_samples: Maximum number of samples to use for estimation.
        assume_nanoseconds_if_dt_gt: Threshold used to infer nanosecond units.

    Returns:
        Estimated sampling rate in Hz, or 0.0 if estimation fails.
    """
    ts = np.asarray(timestamps, dtype=float)
    if ts.size < 2:
        return 0.0

    sample = ts[:max_samples]
    dt = np.diff(sample)
    dt = dt[np.isfinite(dt) & (dt > 0)]
    if dt.size == 0:
        return 0.0

    dt_median = float(np.median(dt))
    if dt_median > assume_nanoseconds_if_dt_gt:
        return _NS_PER_SECOND / dt_median
    return 1.0 / dt_median


def butterworth_lowpass_1d(
    signal: np.ndarray,
    cutoff_hz: float,
    fs: float,
    order: int = 2,
) -> np.ndarray:
    """Apply a Butterworth lowpass filter to a 1D signal.

    NaNs are linearly filled before filtering and restored afterward.
    """
    from scipy.signal import butter, sosfiltfilt

    values = np.asarray(signal, dtype=float).copy()
    if values.size == 0:
        return values
    if fs <= 0:
        raise ValueError("Sampling frequency must be positive")

    nyq = fs / 2.0
    if cutoff_hz <= 0 or cutoff_hz >= nyq:
        raise ValueError("Lowpass cutoff must be in (0, Nyquist)")

    nan_mask = np.isnan(values)
    if nan_mask.all():
        return values

    valid_idx = np.where(~nan_mask)[0]
    if valid_idx.size <= 3 * (order + 1):
        return values

    filled = np.interp(np.arange(values.size), valid_idx, values[valid_idx])
    sos = butter(order, cutoff_hz / nyq, btype="low", output="sos")
    filtered = sosfiltfilt(sos, filled)
    filtered[nan_mask] = np.nan
    return filtered


def butterworth_bandpass_1d(
    signal: np.ndarray,
    low_hz: float,
    high_hz: float,
    fs: float,
    order: int = 2,
    restore_mean: bool = False,
) -> np.ndarray:
    """Apply a Butterworth bandpass filter to a 1D signal.

    NaNs are linearly filled before filtering and restored afterward.
    """
    from scipy.signal import butter, sosfiltfilt

    values = np.asarray(signal, dtype=float).copy()
    if values.size == 0:
        return values
    if fs <= 0:
        raise ValueError("Sampling frequency must be positive")

    nyq = fs / 2.0
    if low_hz <= 0:
        low_hz = _MIN_BANDPASS_HZ
    if high_hz <= low_hz:
        raise ValueError("Bandpass high cutoff must be greater than low cutoff")
    if high_hz >= nyq:
        raise ValueError("Bandpass high cutoff must be lower than Nyquist")

    nan_mask = np.isnan(values)
    if nan_mask.all():
        return values

    valid_idx = np.where(~nan_mask)[0]
    if valid_idx.size <= 3 * (order + 1):
        return values

    orig_mean = float(np.nanmean(values[valid_idx])) if restore_mean else 0.0
    filled = np.interp(np.arange(values.size), valid_idx, values[valid_idx])
    sos = butter(order, [low_hz / nyq, high_hz / nyq], btype="band", output="sos")
    filtered = sosfiltfilt(sos, filled)
    if restore_mean:
        filtered = filtered + orig_mean
    filtered[nan_mask] = np.nan
    return filtered


def inverse_distance_weighted_average(
    query_points: np.ndarray,
    support_points: np.ndarray,
    support_values: np.ndarray,
    epsilon: float = 1e-9,
) -> np.ndarray:
    """Compute inverse-distance weighted averages for query points.

    Args:
        query_points: Coordinates where values are estimated.
        support_points: Coordinates of known values.
        support_values: Values at known coordinates.
        epsilon: Numerical stabilizer to avoid division by zero.

    Returns:
        Estimated values for each query point.
    """
    q = np.asarray(query_points, dtype=float)
    x = np.asarray(support_points, dtype=float)
    y = np.asarray(support_values, dtype=float)

    if q.size == 0:
        return np.array([], dtype=float)
    if x.size == 0 or y.size == 0:
        return np.full(q.shape, np.nan, dtype=float)
    if x.size != y.size:
        raise ValueError("support_points and support_values must have the same length")

    out = np.empty(q.shape, dtype=float)
    for idx, qv in enumerate(q):
        dist = np.abs(x - qv)
        exact = dist <= epsilon
        if np.any(exact):
            out[idx] = float(np.mean(y[exact]))
            continue
        w = 1.0 / (dist + epsilon)
        out[idx] = float(np.sum(w * y) / np.sum(w))
    return out
