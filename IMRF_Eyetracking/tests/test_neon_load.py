#!/usr/bin/env python3
"""
Standalone script to test loading a Neon recording without the GUI.

Usage:
    python -m tests.test_neon_load data_output/IMRFSpatialAV/neon/<recording-folder>

Prints stream info and any errors. Helps diagnose 'no field of name event_type'
and similar schema mismatches.
"""

import sys
import os

# Add project root
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

def main():
    if len(sys.argv) < 2:
        print("Usage: python -m tests.test_neon_load <path_to_neon_folder>")
        print(
            "Example: python -m tests.test_neon_load "
            "data_output/IMRFSpatialAV/neon/<recording-folder>"
        )
        sys.exit(1)

    path = os.path.abspath(sys.argv[1])
    if not os.path.isdir(path):
        print(f"Error: Not a directory: {path}")
        sys.exit(1)

    print(f"Testing Neon load: {path}")
    print("-" * 60)

    try:
        from libs.analysis.recording_helpers import load_neon

        rec = load_neon(path)

        print("SUCCESS: Recording loaded.")
        print(f"  Gaze: {rec.gaze.shape if rec.gaze is not None else 'None'}")
        print(f"  Fixations: {rec.fixations.shape if rec.fixations is not None else 'None'}")
        print(f"  Saccades: {rec.saccades.shape if rec.saccades is not None else 'None'}")
        print(f"  Blinks: {rec.blinks.shape if rec.blinks is not None else 'None'}")
        print(f"  Events: {rec.events.shape if rec.events is not None else 'None'}")

        if rec.fixations is not None:
            print(f"  Fixations columns: {list(rec.fixations.columns)}")

    except Exception as e:
        print(f"FAILED: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
