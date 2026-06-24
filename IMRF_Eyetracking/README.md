# IMRF Eye Tracking

Python tools for the IMRF 2026 spatial audio and eye-tracking workshop.

This folder contains the online acquisition GUI, Neon/LabRecorder integration,
and offline notebooks for mapping Neon scene-camera gaze onto the IMRF Unity
screen coordinates.

## Setup

Use Python 3.10 or 3.11 for the most predictable workshop environment.

```bash
cd IMRF_Eyetracking
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Or with conda:

```bash
cd IMRF_Eyetracking
conda env create -f environment.yml
conda activate imrf-eyetracking
```

Pupil Cloud credentials are not required. Neon recording control uses the
Pupil Labs realtime API over the local network, so the GUI can discover the
device, start/stop recordings, and send event markers without a `.env` file.
If a Neon account/device has mandatory recording-template questions configured,
clear them or answer them outside this GUI before saving; this app no longer
fills Pupil recording templates automatically.

## Data Folders

Runtime acquisition writes raw/local data under:

```text
data_output/IMRFSpatialAV/
  multimodal/    # LabRecorder .xdf files
  neon/          # Native Neon recording folders
```

Workshop notebooks write generated artifacts under:

```text
notebooks/workshop_output/   # mapped gaze, fixations, scanpaths, videos
notebooks/reports/           # AOI and race-model summary exports
```

`data_output`, `workshop_output`, and `reports` are generated folders and are
ignored by Git.

## Upload Workshop Data

To publish a workshop/demo dataset to Hugging Face while preserving the
`data_output` layout plus the matched Unity behavioral CSVs, first log in:

```bash
hf auth login
```

Then preview the upload:

```bash
python scripts/upload_workshop_dataset.py \
  --repo-id <user-or-org>/imrf-eyetracking-workshop-demo \
  --dry-run
```

Upload to a public dataset repo. By default this includes the Neon video files
inside `data_output`, so the surface-mapping notebook can recompute AprilTag
homographies from the scene camera recording. The uploader also looks for the
Unity `IMRFDemoData` session closest in time to the Neon recording and uploads
its `IMRFDemo_TrialData_*.csv`, `IMRFDemo_FrameData_*.csv`, and
`IMRFDemo_Metadata_*.csv` files under `behavioral/`.

```bash
python scripts/upload_workshop_dataset.py \
  --repo-id <user-or-org>/imrf-eyetracking-workshop-demo \
  --yes
```

Useful options:

- `--private`: create/use a private dataset repo instead of public.
- `--exclude-videos`: skip all video files when you only want lightweight derived streams.
- `--exclude-sensor-video`: keep the scene-camera video but skip Neon Sensor Module video files.
- `--exclude '**/wearer.json'`: skip any extra sensitive file pattern.
- `--behavioral-session <folder-name>`: manually choose a Unity `IMRFDemoData` session if timestamp matching is not what you want.
- `--no-behavioral`: upload only `data_output`.

## Download Workshop Data

Students do not need a Hugging Face account or token when the dataset repo is
public. The notebooks that need raw/demo data call `ensure_workshop_data(...)`
in their setup cell and download the public dataset automatically when
`data_output` is missing.

You can also download or refresh the dataset manually:

```bash
python scripts/download_workshop_dataset.py \
  --repo-id Edudro/imrf-eyetracking-workshop-demo
```

If you already have an older workshop download, refresh it cleanly so removed
or renamed files do not remain on disk:

```bash
python scripts/download_workshop_dataset.py \
  --repo-id Edudro/imrf-eyetracking-workshop-demo \
  --replace-local-data \
  --force
```

The downloader writes the Hugging Face dataset into:

```text
data_output/
  dataset_description.json
  participants.tsv
  IMRFSpatialAV/
  behavioral/
```

Use `--force` if you want to re-download over an existing local copy.

## Online Acquisition

Launch the GUI from this folder:

```bash
python main.py
```

On macOS/Linux, the helper launcher can also activate a local environment and
open LabRecorder when available:

```bash
./launch.sh
```

The default Unity task is `IMRFSpatialAV`, and the default Unity LSL marker
stream is `AV_Localization`.

## Workshop Notebooks

Run these notebooks from `IMRF_Eyetracking/notebooks`. Most workshops have a
student copy with implementation gaps and a solved copy with one reference
solution.

Recommended sequence:

1. `00_data_visualisation_workshop_student.ipynb`: first look at raw gaze, pupil, blink, fixation, and ROI streams.
2. `01_interpolation_methods_workshop_student.ipynb`: implement gap masks, linear interpolation, and held-out gap scoring.
3. `02_surface_mapping_workshop_student.ipynb`: map Neon scene-camera gaze to screen coordinates with AprilTags and homographies.
4. `03_aoi_dispersion_workshop_student.ipynb`: assign mapped fixations to IMRF target AOIs and quantify accuracy/precision.
5. `04_race_single_session_workshop_student.ipynb`: compare Unity button RT and gaze-derived time-to-first-fixation with a single-session race-model workflow.

Reference notebooks:

- `00_data_visualisation_workshop_solved.ipynb`, `01_interpolation_methods_workshop_solved.ipynb`, `02_surface_mapping_workshop_solved.ipynb`, `03_aoi_dispersion_workshop_solved.ipynb`, and `04_race_single_session_workshop_solved.ipynb`: solved copies for live teaching or self-checking.

Older compact analysis/check notebooks live in `notebooks/archive/`. They are
kept for reference, but they are not needed for the workshop sequence.

Run `02_surface_mapping_workshop_student.ipynb` through its export section before
running `03_aoi_dispersion_workshop_student.ipynb`. Run the AOI export before
the race-model notebook if you want to analyse gaze-derived time to first
fixation (`ttff`).

The main notebooks set `PARTICIPANT_ID = DEFAULT_PARTICIPANT_ID` near their
data-loading cell. The shared default lives in `notebooks/nb_setup.py` and is
currently `"p0097"`. Change the notebook value to `"p0096"` or `"p0099"` to run
one notebook on another subject, or change `DEFAULT_PARTICIPANT_ID` to switch
the workshop-wide default. Keep the same `PARTICIPANT_ID` through notebooks
`02`, `03`, and `04` so mapped gaze, AOI output, and behavioral TrialData stay
aligned.

## Checks

Syntax-only check:

```bash
python -m compileall -q .
```

Hardware/data smoke scripts:

```bash
python -m tests.test_workshop_download --replace-local-data --force
python -m tests.test_connect_device
python -m tests.test_neon_load data_output/IMRFSpatialAV/neon/<recording-folder>
python -m tests.test_with_real_data
```
