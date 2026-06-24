from pathlib import Path

import numpy as np
import pandas as pd
from scipy.io import wavfile


# -----------------------
# User settings
# -----------------------
trial_csv = Path("C:/Users/marwa/Desktop/ZyliaTemp/AVLoc_TrialData_Subject_zylia__2026__04_21__14_45_19.csv")
frame_csv = Path("C:/Users/marwa/Desktop/ZyliaTemp/AVLoc_FrameData_Subject_zylia__2026__04_21__14_45_19.csv")
wav_path = Path("C:/Users/marwa/Desktop/ZyliaTemp/Take_20260421_14_45.wav")  # change if needed

N = 50  # keep first 50 trials


# Read data
trial_df = pd.read_csv(trial_csv, sep="\t")
frame_df = pd.read_csv(frame_csv, sep="\t")
sr, audio = wavfile.read(wav_path)

# Basic checks
required_trial_cols = {"AudioTargetPosition"}
required_frame_cols = {"TrialCountInExpt", "FrameStart"}

missing_trial = required_trial_cols - set(trial_df.columns)
missing_frame = required_frame_cols - set(frame_df.columns)

if missing_trial:
    raise KeyError(f"TrialData missing columns: {missing_trial}")
if missing_frame:
    raise KeyError(f"FrameData missing columns: {missing_frame}")

# Cut TrialData
trial_small = trial_df.iloc[:N].copy()

# Keep frame rows for trials 0..N
frame_small = frame_df[frame_df["TrialCountInExpt"] <= N].copy()

# Find the first frame AFTER the kept region, so audio ends cleanly
future_frames = frame_df[frame_df["TrialCountInExpt"] > N]

if len(future_frames) > 0:
    end_time_sec = future_frames["FrameStart"].min()
else:
    # Fallback if no later frame exists
    end_time_sec = frame_small["FrameStart"].max()

# Trim audio
end_sample = min(len(audio), int(np.ceil(end_time_sec * sr)))
audio_small = audio[:end_sample]

# Save outputs
trial_out = trial_csv.with_name(trial_csv.stem + f"_first{N}.csv")
frame_out = frame_csv.with_name(frame_csv.stem + f"_first{N}.csv")
wav_out = wav_path.with_name(wav_path.stem + f"_first{N}.wav")

trial_small.to_csv(trial_out, sep="\t", index=False)
frame_small.to_csv(frame_out, sep="\t", index=False)
wavfile.write(wav_out, sr, audio_small)

print("Saved:")
print(trial_out)
print(frame_out)
print(wav_out)
print(f"Trial rows: {len(trial_small)}")
print(f"Frame rows: {len(frame_small)}")
print(f"Audio samples: {len(audio_small)}")