import numpy as np
import tqdm

def spherical_to_cartesian(azimuth_deg, elevation_deg, radius):
    """Convert spherical coordinates to Cartesian coordinates."""
    azimuth_rad = np.radians(azimuth_deg)
    elevation_rad = np.radians(elevation_deg)

    x = radius * np.cos(elevation_rad) * np.cos(azimuth_rad)
    y = radius * np.cos(elevation_rad) * np.sin(azimuth_rad)
    z = radius * np.sin(elevation_rad)

    return np.array([x, y, z]) + np.array([0, 0, 1.2])


def normalize_mic_data(raw_mic_data, eps=1e-12):
    """
    Normalize raw microphone activation data into weights for centroid calculation,
    safely handling zero-activation windows.
    """
    raw_mic_data = np.array(raw_mic_data)

    # Determine mic axis
    if raw_mic_data.shape[0] <= 64:  # n_mics along axis 0
        sums = np.sum(raw_mic_data, axis=0, keepdims=True)
        sums[sums == 0] = eps
        activation_weights = raw_mic_data / sums
    else:  # n_mics along axis 1
        sums = np.sum(raw_mic_data, axis=1, keepdims=True)
        sums[sums == 0] = eps
        activation_weights = raw_mic_data / sums

    return activation_weights


def estimate_direction(raw_mic_data, mic_positions):
    """
    Compute the azimuth, elevation, and magnitude for a window of raw mic data.
    """
    # Convert microphone positions to Cartesian coordinates
    mic_cartesian = np.array([spherical_to_cartesian(az, el, r)
                              for az, el, r in mic_positions])

    # Normalize activations
    normalized_mic_data = normalize_mic_data(raw_mic_data)

    # Compute weighted positions for each time step
    weighted_positions = np.dot(normalized_mic_data, mic_cartesian)  # shape: (time_steps, 3)

    # Take median across time steps
    centroid = np.median(weighted_positions, axis=0)
    x, y, z = centroid

    # Calculate the magnitude of the centroid
    magnitude = np.linalg.norm(centroid)

    # If magnitude is zero (empty window), return NaNs
    if magnitude == 0:
        return np.array([np.nan, np.nan, np.nan])

    # Convert centroid to spherical coordinates
    azimuth = np.arctan2(y, x)  # Azimuth
    elevation = np.arcsin(z / magnitude)  # Elevation

    # Convert to degrees
    azimuth_deg = np.degrees(azimuth)
    elevation_deg = np.degrees(elevation)

    # Return the AEM vector (Azimuth, Elevation, Magnitude)
    return np.array([azimuth_deg, elevation_deg, magnitude])

def estimate_source_direction(raw_mic_data, mic_positions, window_size_ms=30, step_size=None, sr=None, **kwargs):
    """
    Compute the instantaneous Azimuth, Elevation, and Magnitude (AEM) from raw mic data
    using a sliding window with optional step size.

    Returns
    -------
    continuous_AEM : np.ndarray
        Array of shape (time_steps, 3), where each row contains the average of all
        window-based AEM estimates whose window includes that time point.
    """
    if sr is None:
        raise ValueError("Sampling rate 'sr' must be provided.")

    raw_mic_data = np.array(raw_mic_data)

    # Convert (n_mics, time_steps) → (time_steps, n_mics) if needed
    if raw_mic_data.shape[0] in [19, 64] and raw_mic_data.shape[1] > 64:
        raw_mic_data = raw_mic_data.T

    if raw_mic_data.ndim != 2 or raw_mic_data.shape[1] not in [19, 64]:
        raise ValueError("raw_mic_data must have shape (time_steps, 19) or (time_steps, 64).")

    if mic_positions.shape == (3, 19) or mic_positions.shape == (3, 64):
        mic_positions = mic_positions.T
    if mic_positions.shape not in [(19, 3), (64, 3)]:
        raise ValueError("mic_positions must have shape (19,3) or (64,3).")

    n_timepoints = raw_mic_data.shape[0]

    # Window + step size in samples
    window_size_samples = int(sr * window_size_ms / 1000)

    if window_size_samples < 1:
        raise ValueError("window_size_ms is too small for the given sampling rate.")

    # Default step_size = half window size
    if step_size is None:
        step_size_ms = window_size_ms / 2
    else:
        step_size_ms = step_size

    step_size_samples = int(sr * step_size_ms / 1000)

    if step_size_samples < 1:
        raise ValueError("step_size is too small for the given sampling rate.")

    # Accumulate overlapping window estimates at each time point
    AEM_sum = np.zeros((n_timepoints, 3), dtype=float)
    AEM_count = np.zeros(n_timepoints, dtype=float)

    for t in tqdm.tqdm(
        range(0, n_timepoints - window_size_samples + 1, step_size_samples),
        desc="Computing source Azimuth/Elevation/Magnitude"
    ):
        activation_window = raw_mic_data[t:t + window_size_samples, :]

        # Preserve original empty-window behavior
        if np.all(activation_window == 0):
            AEM = np.array([np.nan, np.nan, np.nan])
        else:
            AEM = estimate_direction(activation_window, mic_positions)

        # Add this window's estimate to every sample covered by the window,
        # but only if the estimate is valid
        if not np.any(np.isnan(AEM)):
            AEM_sum[t:t + window_size_samples] += AEM
            AEM_count[t:t + window_size_samples] += 1

    # Compute average estimate per time point
    continuous_AEM = np.full((n_timepoints, 3), np.nan, dtype=float)
    valid = AEM_count > 0
    continuous_AEM[valid] = AEM_sum[valid] / AEM_count[valid, None]

    return continuous_AEM
