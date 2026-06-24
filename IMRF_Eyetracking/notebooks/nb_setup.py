"""Shared notebook bootstrap — import at the top of every workshop notebook.

Jupyter adds the notebook's own directory to sys.path, so this file is
importable from any notebook in notebooks/ without any prior path setup.
"""
from pathlib import Path
import json
import sys

_HERE = Path(__file__).resolve().parent   # notebooks/
_PROJECT_ROOT = _HERE.parent              # IMRF_Eyetracking/
_REPO_ROOT = _PROJECT_ROOT.parent        # repo root (contains both sub-projects)
DEFAULT_DATASET_REPO_ID = "Edudro/imrf-eyetracking-workshop-demo"
DEFAULT_WORKSHOP_PARTICIPANTS = ("p0096", "p0097", "p0099")
DEFAULT_PARTICIPANT_ID = "p0097"
_UNITY_BEHAVIORAL_ROOT = _REPO_ROOT / "IMRF_SpatialAVDemo_Unity" / "IMRFDemoData"


def setup(sentinel: str = "preprocessing.py") -> Path:
    """Add IMRF_Eyetracking project root to sys.path and return it."""
    root = _PROJECT_ROOT
    if not (root / "libs" / "analysis" / sentinel).is_file():
        raise RuntimeError(
            f"Setup failed: {root / 'libs' / 'analysis' / sentinel} not found.\n"
            "Is nb_setup.py located in the notebooks/ directory?"
        )
    if str(root) not in sys.path:
        sys.path.insert(0, str(root))
    print(f"Project root: {root}")
    return root


def setup_repo() -> tuple:
    """Add IMRF_Eyetracking to sys.path; return (REPO_ROOT, EYE_ROOT).

    Use for notebooks that reference both the eyetracking and Unity projects.
    """
    eye_root = _PROJECT_ROOT
    repo_root = _REPO_ROOT
    if str(eye_root) not in sys.path:
        sys.path.insert(0, str(eye_root))
    print(f"Repo root: {repo_root}")
    return repo_root, eye_root


def has_workshop_data(
    project_root: Path | None = None,
    experiment: str = "IMRFSpatialAV",
    require_behavioral: bool = False,
    expected_participants: tuple[str, ...] = DEFAULT_WORKSHOP_PARTICIPANTS,
) -> bool:
    """Return True when the expected downloaded workshop data is present."""
    root = project_root or _PROJECT_ROOT
    data_root = root / "data_output"
    neon_root = data_root / experiment / "neon"
    has_core_data = (
        (data_root / "dataset_description.json").is_file()
        and (data_root / "participants.tsv").is_file()
        and neon_root.is_dir()
        and any(neon_root.glob("*/info.json"))
    )
    if not has_core_data:
        return False
    expected = {_normalize_participant_id(p) for p in expected_participants}
    expected.discard(None)
    if expected and not expected.issubset(_neon_participants(neon_root)):
        return False
    if require_behavioral:
        behavioral_participants = _behavioral_participants(data_root / "behavioral")
        behavioral_participants.update(_behavioral_participants(_UNITY_BEHAVIORAL_ROOT))
        return bool(behavioral_participants) and (
            not expected or expected.issubset(behavioral_participants)
        )
    return True


def ensure_workshop_data(
    project_root: Path | None = None,
    repo_id: str = DEFAULT_DATASET_REPO_ID,
    revision: str | None = None,
    experiment: str = "IMRFSpatialAV",
    require_behavioral: bool = False,
    expected_participants: tuple[str, ...] = DEFAULT_WORKSHOP_PARTICIPANTS,
    force: bool = False,
) -> Path:
    """Download the public workshop dataset if ``data_output`` is missing.

    Public Hugging Face datasets do not require a student account or token.
    """
    root = project_root or _PROJECT_ROOT
    data_root = root / "data_output"

    if (
        has_workshop_data(
            root,
            experiment=experiment,
            require_behavioral=require_behavioral,
            expected_participants=expected_participants,
        )
        and not force
    ):
        print(f"Workshop data ready: {data_root}")
        return data_root

    try:
        from huggingface_hub import snapshot_download
    except ImportError as exc:
        install_cmd = f'"{sys.executable}" -m pip install -U huggingface_hub'
        raise RuntimeError(
            "Workshop data is missing and huggingface_hub is not installed. "
            "Install it into this notebook kernel with:\n"
            f"    {install_cmd}\n"
            "Or switch the notebook kernel to Python (imrf_env)."
        ) from exc

    data_root.mkdir(parents=True, exist_ok=True)
    print(f"Downloading workshop data from hf://datasets/{repo_id} -> {data_root}")
    snapshot_download(
        repo_id=repo_id,
        repo_type="dataset",
        revision=revision,
        local_dir=str(data_root),
    )

    if not has_workshop_data(
        root,
        experiment=experiment,
        require_behavioral=require_behavioral,
        expected_participants=expected_participants,
    ):
        raise RuntimeError(
            f"Downloaded dataset did not contain the expected {experiment} "
            f"workshop files under {data_root}."
        )
    print(f"Workshop data ready: {data_root}")
    return data_root


def _normalize_participant_id(participant_id: str | None) -> str | None:
    if participant_id is None:
        return None
    value = participant_id.strip().lower()
    if value.startswith("sub-"):
        value = value[4:]
    return value or None


def _neon_participants(neon_root: Path) -> set[str]:
    participants: set[str] = set()
    for wearer_path in neon_root.glob("*/wearer.json"):
        try:
            wearer = json.loads(wearer_path.read_text())
        except (OSError, json.JSONDecodeError):
            continue
        participant = _normalize_participant_id(wearer.get("name"))
        if participant:
            participants.add(participant)
    return participants


def _behavioral_participants(root: Path) -> set[str]:
    participants: set[str] = set()
    for path in root.glob("Subject_p*_AVLoc_Data_*"):
        if not path.is_dir():
            continue
        subject = path.name.split("_AVLoc_Data_", 1)[0].replace("Subject_", "")
        participant = _normalize_participant_id(subject)
        if participant:
            participants.add(participant)
    return participants
