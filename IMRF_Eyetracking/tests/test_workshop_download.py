#!/usr/bin/env python3
"""Manual integration test for the public workshop dataset download.

Run from ``IMRF_Eyetracking``:

    python -m tests.test_workshop_download --replace-local-data --force

The test downloads into a temporary test folder by default, not into the real
``data_output`` used by the notebooks.
"""

from __future__ import annotations

import argparse
import sys
import tempfile
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from scripts.download_workshop_dataset import (  # noqa: E402
    DEFAULT_REPO_ID,
    DEFAULT_EXPECTED_PARTICIPANTS,
    download_workshop_dataset,
)


DEFAULT_TEST_DIR = Path(tempfile.gettempdir()) / "imrf_workshop_download_test"


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Download and verify the public IMRF workshop dataset."
    )
    parser.add_argument(
        "--repo-id",
        default=DEFAULT_REPO_ID,
        help=f"Hugging Face dataset repo id. Default: {DEFAULT_REPO_ID}.",
    )
    parser.add_argument(
        "--local-dir",
        type=Path,
        default=DEFAULT_TEST_DIR,
        help=f"Test download folder. Default: {DEFAULT_TEST_DIR}.",
    )
    parser.add_argument(
        "--revision",
        default=None,
        help="Optional dataset revision, branch, tag, or commit SHA.",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Download even if the expected test files already exist.",
    )
    parser.add_argument(
        "--replace-local-data",
        action="store_true",
        help="Delete the test download folder before downloading.",
    )
    return parser.parse_args()


def _require_file(path: Path, label: str) -> None:
    if not path.is_file():
        raise FileNotFoundError(f"Missing {label}: {path}")


def _require_glob(root: Path, pattern: str, label: str) -> Path:
    try:
        return next(root.glob(pattern))
    except StopIteration as exc:
        raise FileNotFoundError(f"Missing {label}: {root / pattern}") from exc


def verify_workshop_download(local_dir: Path) -> None:
    """Verify the files needed by the workshop notebooks are present."""
    _require_file(local_dir / "dataset_description.json", "dataset description")
    _require_file(local_dir / "participants.tsv", "participants table")
    for participant in DEFAULT_EXPECTED_PARTICIPANTS:
        _require_glob(
            local_dir / "IMRFSpatialAV" / "multimodal",
            f"sub-{participant}_ses-s001_task-imrfspatialav_multimodal.xdf",
            f"{participant} multimodal XDF",
        )
        _require_glob(
            local_dir / "behavioral",
            f"Subject_{participant}_AVLoc_Data_*/IMRFDemo_TrialData_*.csv",
            f"{participant} Unity TrialData CSV",
        )
        _require_glob(
            local_dir / "behavioral",
            f"Subject_{participant}_AVLoc_Data_*/IMRFDemo_FrameData_*.csv",
            f"{participant} Unity FrameData CSV",
        )
    _require_glob(
        local_dir / "IMRFSpatialAV" / "neon",
        "*/info.json",
        "Neon recording info.json",
    )


def main() -> int:
    args = _parse_args()
    try:
        local_dir = download_workshop_dataset(
            repo_id=args.repo_id,
            local_dir=args.local_dir,
            revision=args.revision,
            force=args.force,
            replace_local_data=args.replace_local_data,
        )
        verify_workshop_download(local_dir)
    except Exception as exc:
        print(f"FAILED: {exc}", file=sys.stderr)
        return 1

    print(f"SUCCESS: workshop dataset is available at {local_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
