"""
Load a Pupil Labs Neon recording into a simple data structure.

All timestamps are in seconds. All streams are read via pupil-labs-neon-recording.
"""

from __future__ import annotations

import json
import logging
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

import numpy as np
import pandas as pd

logger = logging.getLogger(__name__)

_NS_TO_S = 1e-9


@dataclass
class NeonRecording:
    """
    Streams from one Neon recording.

    gaze      — timestamp, x, y
    pupil     — timestamp, diameter_left, diameter_right
    imu       — timestamp, + IMU fields
    blinks    — timestamp, start_timestamp, end_timestamp
    fixations — start_timestamp, end_timestamp, start_gaze_x, start_gaze_y, end_gaze_x, end_gaze_y, ...
    saccades  — start_timestamp, end_timestamp, start_gaze_x, start_gaze_y, amplitude_angle,
                mean_velocity, max_velocity
    events    — timestamp, event
    """
    gaze: Optional[pd.DataFrame] = None
    pupil: Optional[pd.DataFrame] = None
    imu: Optional[pd.DataFrame] = None
    blinks: Optional[pd.DataFrame] = None
    fixations: Optional[pd.DataFrame] = None
    saccades: Optional[pd.DataFrame] = None
    events: Optional[pd.DataFrame] = None
    metadata: dict = field(default_factory=dict)

    @property
    def has_gaze(self) -> bool:
        return self.gaze is not None and not self.gaze.empty

    @property
    def has_pupil(self) -> bool:
        return self.pupil is not None and not self.pupil.empty

    @property
    def has_blinks(self) -> bool:
        return self.blinks is not None and not self.blinks.empty

    @property
    def has_events(self) -> bool:
        return self.events is not None and not self.events.empty

    @property
    def duration_seconds(self) -> float:
        if self.has_gaze:
            return float(self.gaze['timestamp'].max() - self.gaze['timestamp'].min())
        return 0.0

    @property
    def sampling_rate(self) -> float:
        if self.has_gaze and len(self.gaze) > 1:
            dt = np.median(np.diff(self.gaze['timestamp'].to_numpy()))
            return 1.0 / dt if dt > 0 else 0.0
        return 0.0

    def get_time_range(self) -> tuple[float, float]:
        if self.has_gaze:
            return (float(self.gaze['timestamp'].min()), float(self.gaze['timestamp'].max()))
        return (0.0, 0.0)


def load_neon(path: str) -> NeonRecording:
    """
    Load a Neon recording folder into a NeonRecording.

    Args:
        path: Path to the Neon recording folder.

    Returns:
        NeonRecording with all available streams. All timestamps in seconds.
    """
    import pupil_labs.neon_recording as nr

    rec_path = Path(path)
    logger.info("Loading Neon recording from: %s", rec_path)
    raw = nr.open(str(rec_path))

    recording = NeonRecording()
    recording.metadata['source'] = str(rec_path)

    # Native column names → desired names. All `time`, `start_time`, `stop_time` are in nanoseconds.
    recording.gaze = _stream_to_df(
        raw.gaze,
        ns_cols=['time'],
        rename={'time': 'timestamp', 'point_x': 'x', 'point_y': 'y'},
    )
    recording.pupil = _stream_to_df(
        raw.pupil,
        ns_cols=['time'],
        rename={'time': 'timestamp'},
    )
    recording.imu = _stream_to_df(
        raw.imu,
        ns_cols=['time'],
        rename={'time': 'timestamp'},
    )
    recording.blinks = _stream_to_df(
        raw.blinks,
        ns_cols=['time', 'start_time', 'stop_time'],
        rename={'time': 'timestamp', 'start_time': 'start_timestamp', 'stop_time': 'end_timestamp'},
    )
    recording.fixations = _stream_to_df(
        raw.fixations,
        ns_cols=['start_time', 'stop_time'],
        rename={'start_time': 'start_timestamp', 'stop_time': 'end_timestamp'},
    )
    recording.saccades = _stream_to_df(
        raw.saccades,
        ns_cols=['start_time', 'stop_time'],
        rename={'start_time': 'start_timestamp', 'stop_time': 'end_timestamp'},
    )
    recording.events = _stream_to_df(
        raw.events,
        ns_cols=['time'],
        rename={'time': 'timestamp'},
    )

    return recording


def latest_neon_recording(root: Path) -> Path | None:
    """Return the most recently modified subdirectory under root, or None."""
    if not root.is_dir():
        return None
    recordings = [p for p in root.iterdir() if p.is_dir()]
    return max(recordings, key=lambda p: p.stat().st_mtime) if recordings else None


def normalize_participant_id(participant_id: str | None) -> str | None:
    """Normalize workshop participant ids to the ``p0099`` style."""
    if participant_id is None:
        return None
    value = participant_id.strip().lower()
    if value.startswith("sub-"):
        value = value[4:]
    return value or None


def neon_participant_id(recording_path: Path) -> str | None:
    """Return the participant id stored in a Neon recording's wearer.json."""
    wearer_path = recording_path / "wearer.json"
    if not wearer_path.is_file():
        return None
    try:
        wearer = json.loads(wearer_path.read_text())
    except (OSError, json.JSONDecodeError):
        return None
    return normalize_participant_id(wearer.get("name"))


def find_neon_recording(
    root: Path,
    participant_id: str | None = None,
    recording_id: str | None = None,
) -> Path | None:
    """Find a Neon recording by explicit recording id or participant id.

    If neither selector is given, the newest recording under ``root`` is used.
    """
    if recording_id:
        path = root / recording_id
        return path if path.is_dir() else None

    participant = normalize_participant_id(participant_id)
    if participant is None:
        return latest_neon_recording(root)
    if not root.is_dir():
        return None

    for recording_path in sorted(p for p in root.iterdir() if p.is_dir()):
        if neon_participant_id(recording_path) == participant:
            return recording_path
    return None


def _stream_to_df(
    stream,
    ns_cols: list[str] | None = None,
    rename: dict | None = None,
) -> Optional[pd.DataFrame]:
    """Convert a neon_recording stream to a DataFrame, converting ns columns to seconds."""
    if stream is None:
        return None
    try:
        df = stream.pd
        if df is None or len(df) == 0:
            return None
        df = df.copy()
        for col in (ns_cols or []):
            if col in df.columns:
                df[col] = df[col] * _NS_TO_S
        if rename:
            df = df.rename(columns=rename)
        return df
    except Exception as e:
        logger.warning("Could not read stream: %s", e)
        return None
