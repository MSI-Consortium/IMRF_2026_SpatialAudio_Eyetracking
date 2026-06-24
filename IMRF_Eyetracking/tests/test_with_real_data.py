#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Manual integration test: load a real Neon recording, run it through
the preprocessing pipeline, and save before/after comparison plots.

This is a standalone script — not a unittest — because it requires
a real Neon recording on disk.

Run directly:
    python -m tests.test_with_real_data
"""

import os
import sys
from pathlib import Path

# Ensure project root is on path
PROJECT_ROOT = str(Path(__file__).resolve().parent.parent)
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

def test_real_neon_data(recording_path: str):
    """
    Loads a real Neon recording, runs it through the preprocessing pipeline,
    and saves plots comparing raw and processed pupil and gaze data.
    """
    try:
        import matplotlib
        matplotlib.use('Agg')  # Non-interactive backend for CLI
        import matplotlib.pyplot as plt
    except ImportError as e:
        print(f"Error: matplotlib is not available: {e}")
        return

    try:
        from libs.analysis.recording_helpers import load_neon
        from libs.analysis.preprocessing import (
            PreprocessingPipeline,
            preprocess_recording,
        )
    except ImportError as e:
        print(f"Error: analysis dependencies are not available: {e}")
        return

    print(f"--- Testing with real data from: {recording_path} ---")

    if not os.path.isdir(recording_path):
        print(f"Error: Recording path not found at '{recording_path}'")
        return

    pipeline = PreprocessingPipeline()

    # 1. Load the recording
    try:
        print("\n[Step 1/5] Loading recording...")
        recording = load_neon(recording_path)
        print("...Loading complete.")
        print(f"  - Duration: {recording.duration_seconds:.2f} seconds")
        print(f"  - Sampling Rate: {recording.sampling_rate:.2f} Hz")

    except Exception as e:
        print(f"An error occurred during loading: {e}")
        import traceback
        traceback.print_exc()
        return

    # --- Part 1: Process and Plot Pupil Data ---
    if recording.has_pupil:
        print("\n--- Processing Pupil Data ---")
        original_pupil = recording.pupil.copy()

        print("[Step 2/5] Running pupil preprocessing...")
        preprocessed_recording = preprocess_recording(recording)

        print("[Step 3/5] Generating pupil comparison plot...")
        fig_pupil, (ax1, ax2) = plt.subplots(2, 1, figsize=(15, 10), sharex=True)
        fig_pupil.suptitle('Pupil Data Preprocessing Comparison', fontsize=16)
        ax1.plot(original_pupil['timestamp'], original_pupil['pupil_left'],
                 label='Original Pupil Data', alpha=0.8)
        ax1.set_title('Before Preprocessing')
        ax1.set_ylabel('Pupil Diameter')
        ax1.legend()
        ax1.grid(True, linestyle=':')
        ax2.plot(preprocessed_recording.pupil['timestamp'],
                 preprocessed_recording.pupil['pupil_left'],
                 label='Processed Pupil Data', color='green')
        ax2.set_title('After Preprocessing (Interpolated & Low-Pass Filtered)')
        ax2.set_xlabel('Time (s)')
        ax2.set_ylabel('Pupil Diameter')
        ax2.legend()
        ax2.grid(True, linestyle=':')

        pupil_plot_file = "pupil_preprocessing_comparison.png"
        plt.savefig(pupil_plot_file)
        print(f"...Pupil plot saved to '{os.path.abspath(pupil_plot_file)}'")
        plt.close(fig_pupil)
    else:
        print("\n--- No pupil data found, skipping pupil processing. ---")

    # --- Part 2: Process and Plot Gaze Data ---
    if recording.has_gaze:
        print("\n--- Processing Gaze Data ---")
        original_gaze = recording.gaze.copy()

        print("[Step 4/5] Running gaze preprocessing (Low-Pass Filter)...")
        filtered_gaze = pipeline.lowpass_filter(
            original_gaze,
            columns=['x', 'y'],
            cutoff_hz=15,
            fs=recording.sampling_rate,
        )

        print("[Step 5/5] Generating gaze path comparison plot...")
        fig_gaze, ax = plt.subplots(figsize=(10, 10))
        fig_gaze.suptitle('Gaze Path Smoothing Comparison', fontsize=16)

        segment = slice(500, 1500)
        ax.plot(
            original_gaze['x'][segment], original_gaze['y'][segment],
            label='Original Gaze Path', color='blue', alpha=0.6,
            marker='o', markersize=2, linestyle='-',
        )
        ax.plot(
            filtered_gaze['x'][segment], filtered_gaze['y'][segment],
            label='Smoothed Gaze Path (15Hz LP)', color='red', alpha=0.8,
            marker='o', markersize=2, linestyle='-',
        )

        ax.set_xlabel('Gaze X Coordinate')
        ax.set_ylabel('Gaze Y Coordinate')
        ax.set_title('Original vs. Smoothed Gaze Path (1-second segment)')
        ax.legend()
        ax.grid(True, linestyle=':')
        ax.set_aspect('equal', 'box')

        gaze_plot_file = "gaze_preprocessing_comparison.png"
        plt.savefig(gaze_plot_file)
        print(f"...Gaze plot saved to '{os.path.abspath(gaze_plot_file)}'")
        plt.close(fig_gaze)
    else:
        print("\n--- No gaze data found, skipping gaze processing. ---")


if __name__ == '__main__':
    # Update this path to point to your local IMRF Neon recording.
    NEON_DATA_PATH = os.getenv(
        "IMRF_NEON_RECORDING",
        "data_output/IMRFSpatialAV/neon/<recording-folder>",
    )

    test_real_neon_data(NEON_DATA_PATH)
