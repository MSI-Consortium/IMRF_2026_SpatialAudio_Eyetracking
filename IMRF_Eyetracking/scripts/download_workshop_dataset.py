#!/usr/bin/env python3
"""Download the public IMRF workshop dataset from Hugging Face.

The dataset is downloaded into ``data_output`` so notebooks can keep using
their normal local paths:

    data_output/
      dataset_description.json
      participants.tsv
      IMRFSpatialAV/
      behavioral/
"""

from __future__ import annotations

import argparse
import json
import shutil
import sys
from pathlib import Path


DEFAULT_REPO_ID = "Edudro/imrf-eyetracking-workshop-demo"
DEFAULT_EXPECTED_PARTICIPANTS = ("p0096", "p0097", "p0099")


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Download the IMRF workshop dataset from Hugging Face."
    )
    parser.add_argument(
        "--repo-id",
        default=DEFAULT_REPO_ID,
        help=f"Hugging Face dataset repo id. Default: {DEFAULT_REPO_ID}.",
    )
    parser.add_argument(
        "--local-dir",
        type=Path,
        default=Path("data_output"),
        help="Destination folder. Default: data_output.",
    )
    parser.add_argument(
        "--revision",
        default=None,
        help="Optional dataset revision, branch, tag, or commit SHA.",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Download even if the expected workshop files already exist.",
    )
    parser.add_argument(
        "--replace-local-data",
        action="store_true",
        help=(
            "Delete local-dir before downloading. Use this to remove stale files "
            "from older workshop dataset uploads."
        ),
    )
    return parser.parse_args()


def _normalize_participant_id(participant_id: str | None) -> str | None:
    if participant_id is None:
        return None
    value = participant_id.strip().lower()
    if value.startswith("sub-"):
        value = value[4:]
    return value or None


def _neon_participants(local_dir: Path) -> set[str]:
    participants: set[str] = set()
    for wearer_path in (local_dir / "IMRFSpatialAV" / "neon").glob("*/wearer.json"):
        try:
            wearer = json.loads(wearer_path.read_text())
        except (OSError, json.JSONDecodeError):
            continue
        participant = _normalize_participant_id(wearer.get("name"))
        if participant:
            participants.add(participant)
    return participants


def _behavioral_participants(local_dir: Path) -> set[str]:
    participants: set[str] = set()
    for path in (local_dir / "behavioral").glob("Subject_p*_AVLoc_Data_*"):
        if not path.is_dir():
            continue
        subject = path.name.split("_AVLoc_Data_", 1)[0].replace("Subject_", "")
        participant = _normalize_participant_id(subject)
        if participant:
            participants.add(participant)
    return participants


def _has_expected_data(
    local_dir: Path,
    expected_participants: tuple[str, ...] = DEFAULT_EXPECTED_PARTICIPANTS,
) -> bool:
    expected = {_normalize_participant_id(p) for p in expected_participants}
    expected.discard(None)
    has_layout = (
        (local_dir / "dataset_description.json").is_file()
        and (local_dir / "participants.tsv").is_file()
        and (local_dir / "IMRFSpatialAV" / "neon").is_dir()
        and any((local_dir / "IMRFSpatialAV" / "neon").glob("*/info.json"))
        and any((local_dir / "behavioral").glob("*/IMRFDemo_TrialData_*.csv"))
    )
    if not has_layout:
        return False
    if not expected:
        return True
    return expected.issubset(_neon_participants(local_dir)) and expected.issubset(
        _behavioral_participants(local_dir)
    )


def download_workshop_dataset(
    repo_id: str = DEFAULT_REPO_ID,
    local_dir: Path | str = Path("data_output"),
    revision: str | None = None,
    force: bool = False,
    replace_local_data: bool = False,
    expected_participants: tuple[str, ...] = DEFAULT_EXPECTED_PARTICIPANTS,
) -> Path:
    """Download the workshop dataset and return the local directory."""
    local_path = Path(local_dir).expanduser().resolve()
    if _has_expected_data(local_path, expected_participants) and not force:
        print(f"Workshop data already present: {local_path}")
        return local_path

    try:
        from huggingface_hub import snapshot_download
    except ImportError as exc:
        raise RuntimeError(
            "Missing dependency: huggingface_hub. Install with "
            "`python -m pip install -U huggingface_hub`."
        ) from exc

    if replace_local_data and local_path.exists():
        shutil.rmtree(local_path)
    local_path.mkdir(parents=True, exist_ok=True)
    print(f"Downloading hf://datasets/{repo_id} -> {local_path}")
    snapshot_download(
        repo_id=repo_id,
        repo_type="dataset",
        revision=revision,
        local_dir=str(local_path),
    )
    if not _has_expected_data(local_path, expected_participants):
        expected = ", ".join(expected_participants)
        raise RuntimeError(
            f"Downloaded dataset is incomplete. Expected participants: {expected}."
        )
    return local_path


def main() -> int:
    args = _parse_args()
    try:
        download_workshop_dataset(
            repo_id=args.repo_id,
            local_dir=args.local_dir,
            revision=args.revision,
            force=args.force,
            replace_local_data=args.replace_local_data,
        )
        return 0
    except Exception as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
