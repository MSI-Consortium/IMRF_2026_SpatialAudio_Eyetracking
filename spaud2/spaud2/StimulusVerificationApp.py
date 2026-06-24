import wx
import os
import numpy as np
import pandas as pd
from scipy.io import wavfile
import matplotlib
from estimate_continuous_source_direction import estimate_source_direction, estimate_direction
from extract_mic_positions_from_sofa import extract_mic_positions_from_sofa
matplotlib.use('WXAgg')
from matplotlib.backends.backend_wxagg import FigureCanvasWxAgg as FigureCanvas
from matplotlib.figure import Figure
from scipy.stats import circmean
import matplotlib.pyplot as plt
from plot_intervals import plot_intervals

# =====================================
# Utilities
# =====================================

def parse_position_string(pos_str):
    vals = pos_str.strip("()").split(",")
    return float(vals[0]), float(vals[1]), float(vals[2])

def cartesian_to_spherical(x, y, z):
    vec = np.array([x, y, z]) - np.array([0, 0, 1.2])

    dist = np.linalg.norm(vec)
    azimuth = np.degrees(np.arctan2(vec[0], vec[1]))
    elevation = np.degrees(np.arctan2(vec[2], np.sqrt(vec[0]**2 + vec[1]**2)))

    return azimuth, elevation, dist

def downsample_minmax(time, data, max_points=2000):
    n = len(time)
    if n <= max_points:
        return time, data

    bucket = n // max_points
    trimmed = bucket * max_points

    t = time[:trimmed]
    d = data[:trimmed]

    t = t.reshape(max_points, bucket).mean(axis=1)

    if d.ndim == 1:
        d = d.reshape(max_points, bucket)
        dmin = d.min(axis=1)
        dmax = d.max(axis=1)
        d = np.vstack((dmin, dmax)).T.reshape(-1)
        t = np.repeat(t, 2)
    else:
        channels = []
        for i in range(d.shape[1]):
            ch = d[:, i].reshape(max_points, bucket)
            dmin = ch.min(axis=1)
            dmax = ch.max(axis=1)
            ch = np.vstack((dmin, dmax)).T.reshape(-1)
            channels.append(ch)
        d = np.stack(channels, axis=1)
        t = np.repeat(t, 2)

    return t, d


# =====================================
# Main App
# =====================================

class StimulusApp(wx.Frame):
    def __init__(self):
        super().__init__(None, title="Stimulus Verifier", size=(1100, 750))
        self.panel = wx.Panel(self)

        # Data
        self.trial_data = None
        self.frame_data = None
        self.audio = None
        self.sample_rate = None
        self.time = None
        self.stim_periods = None
        self.stim_df = None
        self.folder = None

        # State
        self.mode = "INIT"  # INIT, ZOOM, AUTO, MANUAL
        self.current_xlim = [0, 1]
        self.current_idx = 0
        self.zoom_scale = 2
        self.first_click_time = None
        self.first_click_set = False
        self.timer = wx.Timer(self)

        self._build_ui()
        self._bind()

        self.Show()

    # =====================================
    # UI
    # =====================================
    def _build_ui(self):
        vbox = wx.BoxSizer(wx.VERTICAL)

        self.fig = Figure()
        self.ax = self.fig.add_subplot(111)
        self.canvas = FigureCanvas(self.panel, -1, self.fig)

        vbox.Add(self.canvas, 1, wx.EXPAND | wx.ALL, 5)

        hbox = wx.BoxSizer(wx.HORIZONTAL)

        btn_box = wx.BoxSizer(wx.VERTICAL)
        self.btn_load = wx.Button(self.panel, label="1. Load Data")
        self.btn_verify = wx.Button(self.panel, label="2. Verify Stimuli")
        self.btn_generate_scatter = wx.Button(self.panel, label="3. Save Scatterplots")
        self.btn_save = wx.Button(self.panel, label="4. Save Stimulus Plots")

        self.btn_verify.Disable()
        self.btn_save.Disable()
        self.btn_generate_scatter.Disable()

        btn_box.Add(self.btn_load, 0, wx.ALL, 5)
        btn_box.Add(self.btn_verify, 0, wx.ALL, 5)
        btn_box.Add(self.btn_generate_scatter, 0, wx.ALL, 5)
        btn_box.Add(self.btn_save, 0, wx.ALL, 5)

        right = wx.BoxSizer(wx.VERTICAL)

        zoom_row = wx.BoxSizer(wx.HORIZONTAL)
        zoom_row.Add(wx.StaticText(self.panel, label="Zoom Scale"), 0, wx.ALL, 5)
        self.zoom_box = wx.TextCtrl(self.panel, value="2")
        zoom_row.Add(self.zoom_box, 0, wx.ALL, 5)

        self.instructions = wx.StaticText(
            self.panel,
            label="Press the Load Data button to select data folder."
        )

        self.flag_checkbox = wx.CheckBox(self.panel, label="Stimulus Flagged")
        self.flag_checkbox.Hide()

        self.quit_btn = wx.Button(self.panel, label="Quit App")

        right.Add(zoom_row)
        right.Add(self.instructions, 0, wx.ALL, 10)
        right.Add(self.flag_checkbox, 0, wx.ALL, 5)
        right.AddStretchSpacer()
        right.Add(self.quit_btn, 0, wx.ALIGN_RIGHT | wx.ALL, 5)

        hbox.Add(btn_box, 0)
        hbox.Add(right, 1, wx.EXPAND)

        vbox.Add(hbox, 0, wx.EXPAND)

        self.panel.SetSizer(vbox)

    def _bind(self):
        self.btn_load.Bind(wx.EVT_BUTTON, self.on_load)
        self.btn_verify.Bind(wx.EVT_BUTTON, self.on_verify)
        self.btn_save.Bind(wx.EVT_BUTTON, self.on_save)
        self.btn_generate_scatter.Bind(wx.EVT_BUTTON, self.on_generate_scatter)
        self.quit_btn.Bind(wx.EVT_BUTTON, self.on_quit)

        self.canvas.mpl_connect("button_press_event", self.on_mouse)

        self.Bind(wx.EVT_TIMER, self.on_timer)
        self.Bind(wx.EVT_CHAR_HOOK, self.on_key)
        self.flag_checkbox.Bind(wx.EVT_CHECKBOX, self.on_flag)

    # =====================================
    # Load Data
    # =====================================
    def on_load(self, evt):
        dlg = wx.DirDialog(self, "Select data folder")
        if dlg.ShowModal() != wx.ID_OK:
            return

        folder = dlg.GetPath()
        self.folder = folder
        files = os.listdir(folder)

        trial = [f for f in files if "TrialData" in f][0]
        frame = [f for f in files if "FrameData" in f][0]
        wav = [f for f in files if f.endswith(".wav")][0]

        self.trial_data = pd.read_csv(os.path.join(folder, trial), sep="\t")
        self.frame_data = pd.read_csv(os.path.join(folder, frame), sep="\t")

        sr, audio = wavfile.read(os.path.join(folder, wav))
        self.audio = audio

        if not any("time" in c.lower() for c in self.frame_data.columns):
            dlg = wx.TextEntryDialog(
                self,
                "No timestamps in audio file, please enter the sample rate",
                value="48000"
            )
            if dlg.ShowModal() == wx.ID_OK:
                sr = float(dlg.GetValue())

        self.sample_rate = sr
        self.time = np.arange(len(audio)) / sr

        self.mode = "ZOOM"
        self.plot_window(0, min(100, self.time[-1]))

        self.instructions.SetLabel(
            "Click left to zoom in on the first stimulus onset.\n"
            "Click right to zoom out.\n"
            "Change precision with Zoom Scale.\n"
            "Press Verify Stimuli when satisfied."
        )

        self.btn_verify.Enable()
        self.btn_generate_scatter.Enable()

    # =====================================
    # Plotting
    # =====================================
    def plot_window(self, start, end):
        mask = (self.time >= start) & (self.time <= end)

        t = self.time[mask]
        d = self.audio[mask]

        self.ax.clear()

        if len(t) > 0:
            t, d = downsample_minmax(t, d)

            if d.ndim == 1:
                self.ax.plot(t, d)
            else:
                for i in range(d.shape[1]):
                    self.ax.plot(t, d[:, i])

            ymin, ymax = np.min(d), np.max(d)
            buffer = 0.1 * (ymax - ymin)
            self.ax.set_ylim(ymin - buffer, ymax + buffer)
        else:
            # No data in view → safe default
            self.ax.set_ylim(-1, 1)

        self.ax.set_xlim(start, end)
        self.ax.set_xticks(np.linspace(start, end, 5))

        self.current_xlim = [start, end]
        # Draw persistent green center line if set
        # if self.first_click_set:
        #     center = (start + end) / 2
        #     self.ax.axvline(center, color="green", linestyle=":")

        if self.mode == "ZOOM" and self.first_click_set:
            self.ax.axvline(self.first_click_time, color="green", linestyle=":")
            # center = (start + end) / 2
            # self.ax.axvline(center, color="green", linestyle=":")
        self.canvas.draw()

    # =====================================
    # Mouse Interaction
    # =====================================
    def on_mouse(self, event):
        if event.xdata is None:
            return

        # ZOOM
        if self.mode == "ZOOM":
            try:
                self.zoom_scale = float(self.zoom_box.GetValue())
            except:
                self.zoom_scale = 2

            xmin, xmax = self.current_xlim
            width = xmax - xmin

            # Determine new width
            if event.button == 1:
                new_width = width / self.zoom_scale
            elif event.button == 3:
                new_width = width * self.zoom_scale
            else:
                return

            # Enforce limits ONLY on width (not position)
            min_width = 1000 / self.sample_rate
            max_width = self.time[-1]

            new_width = max(min_width, new_width)
            new_width = min(max_width, new_width)

            # TRUE CENTERING (no clamping to data bounds)
            center = event.xdata
            start = center - new_width / 2
            end = center + new_width / 2


            # ----------------------------------
            # FIRST CLICK: set reference + line
            # ----------------------------------
            if event.button == 1: #and not self.first_click_set:
                self.first_click_time = center
                self.first_click_set = True

                self.btn_verify.Enable()

            # Apply zoom
            self.plot_window(start, end)

    def enter_manual_mode(self, from_auto=False):
        if self.timer.IsRunning():
            self.timer.Stop()

        self.mode = "MANUAL"

        # During AUTO, current_idx has already been advanced after drawing.
        # Move back to the stimulus currently visible.
        if from_auto and self.stim_df is not None:
            self.current_idx = max(0, min(self.current_idx - 1, n - 1))

        self.instructions.SetLabel(
            "← Previous\n→ Next\n↓ Back\n↑ Forward\n"
            "Left click: onset\nRight click: offset\nSpace: auto"
        )

        if self.stim_df is not None:
            self.show_stimulus(self.current_idx)

    # =====================================
    # Constraint-safe editing
    # =====================================
    def adjust_onset(self, idx, new_onset):
        df = self.stim_df

        if idx > 0:
            new_onset = max(new_onset, df.loc[idx-1, "OffsetMic"])

        new_onset = min(new_onset, df.loc[idx, "OffsetMic"] - 1e-4)

        delta = new_onset - df.loc[idx, "OnsetMic"]

        df.loc[idx:, "OnsetMic"] += delta
        df.loc[idx:, "OffsetMic"] += delta

        df["DurationMic"] = df["OffsetMic"] - df["OnsetMic"]

    def adjust_offset(self, idx, new_offset):
        df = self.stim_df

        new_offset = max(new_offset, df.loc[idx, "OnsetMic"] + 1e-4)

        if idx < len(df)-1:
            new_offset = min(new_offset, df.loc[idx+1, "OnsetMic"])

        delta = new_offset - df.loc[idx, "OffsetMic"]

        df.loc[idx, "OffsetMic"] = new_offset

        if idx < len(df)-1:
            df.loc[idx+1:, "OnsetMic"] += delta
            df.loc[idx+1:, "OffsetMic"] += delta

        df["DurationMic"] = df["OffsetMic"] - df["OnsetMic"]

    # =====================================
    # Verify Stimuli
    # =====================================
    def on_verify(self, evt):
        onsets = []
        offsets = []

        trial_state = self.frame_data["TrialState"].values
        frame_start = self.frame_data["FrameStart"].values

        in_stim = False

        for i in range(len(trial_state)):
            if trial_state[i] == "StimOn":
                if not in_stim:
                    # Start of a new stimulus
                    onset = frame_start[i]
                    in_stim = True
            else:
                if in_stim:
                    # End of stimulus → use THIS frame's start as offset
                    offset = frame_start[i]
                    onsets.append(onset)
                    offsets.append(offset)
                    in_stim = False

        # Handle case where file ends during StimOn
        if in_stim:
            onsets.append(onset)
            offsets.append(frame_start[-1])

        # if len(onsets) != len(self.trial_data):
        #     wx.MessageBox(
        #         f"Stimulus count mismatch:\n"
        #         f"FrameData stimuli: {len(onsets)}\n"
        #         f"TrialData rows: {len(self.trial_data)}",
        #         "Error",
        #         wx.OK | wx.ICON_ERROR
        #     )
        #     return
        if self.first_click_time is None:
            wx.MessageBox(
                "Please left-click the exact first stimulus onset before verifying.",
                "First onset not selected",
                wx.OK | wx.ICON_WARNING
            )
            return

        base = self.first_click_time

        rows = []
        for i in range(len(onsets)):
            print(i)
            x, y, z = parse_position_string(self.trial_data.iloc[i]["AudioTargetPosition"])
            az, el, dist = cartesian_to_spherical(x, y, z)

            shift = onsets[i] - onsets[0]

            rows.append({
                "OnsetUnity": onsets[i],
                "OffsetUnity": offsets[i],
                "DurationUnity": offsets[i]-onsets[i],
                "X_Unity": x,
                "Y_Unity": y,
                "Z_Unity": z,
                "AzimuthUnity": az,
                "ElevationUnity": el,
                "DistanceUnity": dist,
                "AudioStimType": self.trial_data.iloc[i]["AudioStimType"],
                "OnsetMic": base + shift,
                "OffsetMic": base + shift + (offsets[i]-onsets[i]),
                "DurationMic": offsets[i]-onsets[i],
                "Flagged": 0
            })

        self.stim_df = pd.DataFrame(rows)

        self.build_stimulus_cache()
        self.current_idx = 0
        self.mode = "AUTO"
        self.flag_checkbox.Show()
        self.btn_save.Enable()
        self.timer.Start(100)
        self.show_cached_stimulus(self.current_idx)


    # =====================================
    # Auto mode
    # =====================================
    def on_timer(self, evt):
        if self.mode != "AUTO":
            return

        if self.current_idx >= len(self.stim_cache):
            self.timer.Stop()
            self.btn_save.Enable()
            return

        self.show_cached_stimulus(self.current_idx)
        self.current_idx += 1

    # =====================================
    # Manual mode + navigation
    # =====================================
    def on_key(self, evt):
        key = evt.GetKeyCode()

        # SPACE toggles AUTO <-> MANUAL
        if key == wx.WXK_SPACE:
            if self.mode == "AUTO":
                self.mode = "MANUAL"
                if self.timer.IsRunning():
                    self.timer.Stop()
                self.current_idx = max(0, self.current_idx - 1)
            else:
                self.mode = "AUTO"
                self.timer.Start(333)
            return

        if self.mode != "MANUAL":
            evt.Skip()
            return

        if key == wx.WXK_LEFT:
            self.current_idx = max(0, self.current_idx - 1)
        elif key == wx.WXK_RIGHT:
            self.current_idx = min(len(self.stim_cache) - 1, self.current_idx + 1)
        elif key == wx.WXK_DOWN:
            self.pan_view(-0.1 * self.stim_cache[self.current_idx]["duration"])
        elif key == wx.WXK_UP:
            self.pan_view(0.1 * self.stim_cache[self.current_idx]["duration"])

        self.show_cached_stimulus(self.current_idx)

    def pan_view(self, shift):
        start, end = self.current_xlim
        width = end - start

        new_start = start + shift
        new_end = end + shift

        if self.current_idx > 0:
            prev_offset = self.stim_df.loc[self.current_idx-1, "OffsetMic"]
            if new_start < prev_offset:
                new_start = prev_offset
                new_end = new_start + width

        if self.current_idx < n-1:
            next_onset = self.stim_df.loc[self.current_idx+1, "OnsetMic"]
            if new_end > next_onset:
                new_end = next_onset
                new_start = new_end - width

        self.plot_window(new_start, new_end)

    # =====================================
    # Stimulus Display
    # =====================================

    def draw_stimulus_box(self, onset, offset, width=0.300, color="green", alpha=0.18):
        """Draw a full-height rectangle centered on a stimulus."""
        center = (onset + offset) / 2.0
        half_width = width / 2.0

        left = max(0, center - half_width)
        right = min(self.time[-1], center + half_width)

        self.ax.axvspan(
            left,
            right,
            ymin=0,
            ymax=1,
            facecolor=color,
            edgecolor="none",
            alpha=alpha,
            zorder=0
        )

    def build_stimulus_cache(self):
        n = len(self.stim_df)
        self.stim_cache = []

        progress = wx.ProgressDialog(
            "Building stimulus cache",
            "Starting...",
            maximum=n,
            parent=self,
            style=wx.PD_APP_MODAL | wx.PD_AUTO_HIDE | wx.PD_ELAPSED_TIME | wx.PD_REMAINING_TIME
        )
        progress.CenterOnScreen()

        try:
            for idx in range(n):
                stim = self.stim_df.iloc[idx]

                center = stim["OnsetMic"] + stim["DurationMic"] / 2
                start = center - 0.5
                end = center + 0.5

                mask = (self.time >= start) & (self.time <= end)
                t = self.time[mask]
                d = self.audio[mask]

                if len(t) > 0:
                    t, d = downsample_minmax(t, d)

                    if d.ndim == 1:
                        ymin, ymax = np.min(d), np.max(d)
                    else:
                        ymin, ymax = np.min(d), np.max(d)
                else:
                    ymin, ymax = -1, 1

                self.stim_cache.append({
                    "idx": idx,
                    "start": start,
                    "end": end,
                    "t": t,
                    "d": d,
                    "duration": stim["DurationMic"],
                    "onset": stim["OnsetMic"],
                    "offset": stim["OffsetMic"],
                    "flagged": int(stim["Flagged"]),
                    "ymin": ymin,
                    "ymax": ymax,
                })

                cont, _ = progress.Update(idx + 1, f"Building stimulus {idx + 1} of {n}")
                if not cont:
                    break
        finally:
            progress.Destroy()


    def show_cached_stimulus(self, idx):
        item = self.stim_cache[idx]
        stim = self.stim_df.iloc[idx]

        self.current_idx = idx
        self.ax.clear()

        t = item["t"]
        d = item["d"]

        if len(t) > 0:
            if d.ndim == 1:
                self.ax.plot(t, d)
            else:
                for i in range(d.shape[1]):
                    self.ax.plot(t, d[:, i])

            ymin, ymax = np.min(d), np.max(d)
            buffer = 0.1 * (ymax - ymin) if ymax > ymin else 1
            self.ax.set_ylim(ymin - buffer, ymax + buffer)
        else:
            self.ax.set_ylim(-1, 1)

        self.ax.set_xlim(item["start"], item["end"])
        self.current_xlim = [item["start"], item["end"]]

        self.draw_stimulus_box(stim["OnsetMic"], stim["OffsetMic"], width=0.300)
        self.ax.axvline(stim["OnsetMic"], color="green", linestyle=":")
        self.ax.axvline(stim["OffsetMic"], color="green", linestyle=":")

        if idx > 0:
            prev = self.stim_df.iloc[idx - 1]
            if prev["OffsetMic"] >= item["start"]:
                self.ax.axvline(prev["OnsetMic"], color="red", linestyle=":")
                self.ax.axvline(prev["OffsetMic"], color="red", linestyle=":")

        if idx < len(self.stim_df) - 1:
            nxt = self.stim_df.iloc[idx + 1]
            if nxt["OnsetMic"] <= item["end"]:
                self.ax.axvline(nxt["OnsetMic"], color="red", linestyle=":")
                self.ax.axvline(nxt["OffsetMic"], color="red", linestyle=":")

        self.ax.set_title(f"Stimulus {idx + 1} of {len(self.stim_cache)}")
        self.flag_checkbox.SetValue(bool(stim["Flagged"]))
        self.canvas.draw()

    # =====================================
    # Flagging
    # =====================================
    def on_flag(self, evt):
        if self.stim_df is not None:
            self.stim_df.loc[self.current_idx, "Flagged"] = int(self.flag_checkbox.GetValue())

    # =====================================
    # Save Stimulus Plots
    # =====================================
    def on_save(self, evt):
        dlg = wx.DirDialog(self, "Choose stimulus plot folder")
        if dlg.ShowModal() == wx.ID_OK:
            folder = dlg.GetPath()
            self.save_all_plots(folder)

    def save_all_plots(self, folder):
        os.makedirs(folder, exist_ok=True)

        n = len(self.stim_df)

        progress = wx.ProgressDialog(
            "Saving stimulus plots",
            "Starting...",
            maximum=n,
            parent=self,
            style=wx.PD_APP_MODAL
                | wx.PD_AUTO_HIDE
                | wx.PD_ELAPSED_TIME
                | wx.PD_REMAINING_TIME
        )

        try:
            for idx in range(n):
                stim = self.stim_df.iloc[idx]

                center = stim["OnsetMic"] + stim["DurationMic"] / 2
                start = center - 0.5
                end = center + 0.5

                mask = (self.time >= start) & (self.time <= end)
                t = self.time[mask]
                d = self.audio[mask]

                fig = Figure(figsize=(10, 5))
                ax = fig.add_subplot(111)

                if len(t) > 0:
                    t, d = downsample_minmax(t, d)

                    if d.ndim == 1:
                        ax.plot(t, d)
                    else:
                        for ch in range(d.shape[1]):
                            ax.plot(t, d[:, ch])

                    ymin, ymax = np.min(d), np.max(d)
                    buffer = 0.1 * (ymax - ymin) if ymax > ymin else 1
                    ax.set_ylim(ymin - buffer, ymax + buffer)
                else:
                    ax.set_ylim(-1, 1)

                ax.set_xlim(start, end)

                # stimulus box
                center_box = (stim["OnsetMic"] + stim["OffsetMic"]) / 2
                ax.axvspan(
                    center_box - 0.150,
                    center_box + 0.150,
                    facecolor="green",
                    alpha=0.18,
                    edgecolor="none"
                )

                # current stimulus
                ax.axvline(stim["OnsetMic"], color="green", linestyle=":")
                ax.axvline(stim["OffsetMic"], color="green", linestyle=":")

                # previous stimulus
                if idx > 0:
                    prev = self.stim_df.iloc[idx - 1]
                    if prev["OffsetMic"] >= start:
                        ax.axvline(prev["OnsetMic"], color="red", linestyle=":")
                        ax.axvline(prev["OffsetMic"], color="red", linestyle=":")

                # next stimulus
                if idx < n - 1:
                    nxt = self.stim_df.iloc[idx + 1]
                    if nxt["OnsetMic"] <= end:
                        ax.axvline(nxt["OnsetMic"], color="red", linestyle=":")
                        ax.axvline(nxt["OffsetMic"], color="red", linestyle=":")

                ax.set_title(f"Stimulus {idx + 1} of {n}")

                filename = os.path.join(
                    folder,
                    f"stimulus_{idx + 1:04d}.png"
                )

                fig.savefig(
                    filename,
                    dpi=300,
                    bbox_inches="tight"
                )

                progress.Update(
                    idx + 1,
                    f"Saving stimulus {idx + 1} of {n}"
                )

                fig.clear()

        finally:
            progress.Destroy()

    # =====================================
    # Generate Scatterplots
    # =====================================
    def on_generate_scatter(self, evt):
        dlg = wx.DirDialog(self, "Choose scatterplot folder")
        if dlg.ShowModal() == wx.ID_OK:
            folder = dlg.GetPath()
            self.plot_trials(folder)
        

    def plot_trials(self, output_folder):
        files = os.listdir(self.folder)
        
        wav = [f for f in files if f.endswith(".wav")][0]

        # sofa = [f for f in files if f.endswith(".sofa")][0]

        # mic_positions = extract_mic_positions_from_sofa(os.path.join(self.folder, sofa))

        # np.save(os.path.join(self.folder,'ZyliaMicPositions.npy'), mic_positions)

        mic_positions = np.load(os.path.join(self.folder,'ZyliaMicPositions.npy'))

        # 1) Load data
        sr, raw = wavfile.read(os.path.join(self.folder, wav))

        # If WAV is shaped (n_mics, n_time), transpose to (n_time, n_mics)
        raw_mic_data = raw
        if raw_mic_data.ndim == 2 and raw_mic_data.shape[0] in [19, 64] and raw_mic_data.shape[1] > 64:
            raw_mic_data = raw_mic_data.T

        # mic_positions = estimate_direction(raw_mic_data, mic_positions)

        # x = [v[0] for v in mic_positions]
        # y = [v[1] for v in mic_positions]
        # z = [v[2] for v in mic_positions]
        #
        # fig = plt.figure()
        # ax = fig.add_subplot(projection='3d')
        #
        # ax.scatter(x, y, z)
        #
        # ax.set_xlabel('X Label')
        # ax.set_ylabel('Y Label')
        # ax.set_zlabel('Z Label')
        #
        # plt.show()
        # mic_positions must match the array layout used by your script
        # shape should be (19, 3) or (64, 3)
        continuous_AEM = estimate_source_direction(
            raw_mic_data,
            sr=sr,
            mic_positions=mic_positions
        )

        # 2) Build stim_periods from FrameData
        frame_data = self.frame_data
        trial_data = self.trial_data

        trial_data = trial_data[trial_data["AudioStimType"] == "mono"].copy()

        trial_nums = trial_data["TrialCountInExpt"]

        for i, val in trial_nums.items():
            trial_nums.at[i] = trial_nums.at[i] - 1

        frame_data = frame_data[frame_data["TrialCountInExpt"].isin(trial_nums)].copy()

        is_stim = frame_data["TrialState"].eq("StimOn")
        run_id = (is_stim != is_stim.shift(fill_value=False)).cumsum()

        stim_periods = []
        for _, g in frame_data[is_stim].groupby(run_id[is_stim]):
            start_t = float(g["FrameStart"].iloc[0])
            last_idx = g.index[-1]
            if last_idx + 1 < len(frame_data):
                end_t = float(frame_data.loc[last_idx + 1, "FrameStart"])
            else:
                end_t = float(g["FrameStart"].iloc[-1])
            stim_periods.append((start_t, end_t))

        stim_periods = np.array(stim_periods)

        # 3) One estimated azimuth/elevation per stimulus
        est_az = []
        est_el = []

        for i, (start_t, end_t) in enumerate(stim_periods):
            start_i = int(round(start_t * sr))
            end_i = int(round(end_t * sr))

            # bounds checks
            start_i = max(0, start_i)
            end_i = min(len(continuous_AEM), end_i)

            if end_i <= start_i:
                print(f"Skipping stim {i}: bad slice {start_i}:{end_i}")
                est_az.append(np.nan)
                est_el.append(np.nan)
                continue

            seg = continuous_AEM[start_i:end_i]

            if seg.size == 0 or np.all(np.isnan(seg)):
                print(f"Skipping stim {i}: empty/NaN slice")
                est_az.append(np.nan)
                est_el.append(np.nan)
                continue

            valid = seg[np.isfinite(seg[:,0]), 0]

            est_az.append(
                circmean(valid, high=180, low=-180)
            )
            est_el.append(np.nanmedian(seg[:, 1]))

        est_az = np.array(est_az)
        est_el = np.array(est_el)

        # Parse AudioTargetPosition into x, y, z
        # Unity y vs python z
        xyz = trial_data["AudioTargetPosition"].apply(parse_position_string)
        trial_data["x"] = [v[0] for v in xyz]
        trial_data["y"] = [v[2] for v in xyz]
        trial_data["z"] = [v[1] for v in xyz]

        # Convert each row to azimuth and elevation
        reported_az = []
        reported_el = []
        valid_trial_idx = []

        for i, (x, y, z) in enumerate(trial_data[["x", "y", "z"]].to_numpy()):
            az, el, dist = cartesian_to_spherical(x, y, z)

            reported_az.append(az)

            # if -25 <= el <= 25:
            reported_el.append(el)
            valid_trial_idx.append(i)

        reported_az = np.array(reported_az)
        reported_el = np.array(reported_el)

        # Keep only estimated elevations from those same trials
        est_el = est_el[valid_trial_idx]

        az_mask = np.isfinite(reported_az) & np.isfinite(est_az)
        el_mask = np.isfinite(reported_el) & np.isfinite(est_el)

        reported_az = reported_az[az_mask]
        reported_el = reported_el[el_mask]

        # Azimuth scatter
        plt.figure(figsize=(6, 6))
        plt.scatter(reported_az, est_az, alpha=0.7)
        lims = [
            min(np.nanmin(reported_az), np.nanmin(est_az)),
            max(np.nanmax(reported_az), np.nanmax(est_az)),
        ]

        m, b = np.polyfit(
            reported_az,
            est_az,
            1
        )

        xfit = np.linspace(
            np.min(reported_az),
            np.max(reported_az),
            100
        )

        yfit = m * xfit + b

        plt.plot(xfit, yfit, "r-", label=f"Fit: y={m:.2f}x+{b:.2f}")
        plt.plot(lims, lims, "k--", label="y=x")
        plt.xlabel("Reported Azimuth (deg)")
        plt.ylabel("Estimated Azimuth (deg)")
        plt.title("Estimated vs Reported Azimuth")
        plt.grid(True)
        plt.legend()
        plt.tight_layout()
        plt.savefig(os.path.join(output_folder, "azimuth_scatter.png"), dpi=300, bbox_inches="tight")
        plt.close()

        # Elevation scatter
        m, b = np.polyfit(reported_el, est_el, 1)

        xfit = np.linspace(
            np.min(reported_el),
            np.max(reported_el),
            100
        )
        yfit = m * xfit + b

        plt.figure(figsize=(6, 6))
        plt.scatter(reported_el, est_el, alpha=0.7)
        plt.plot(xfit, yfit, "r-", label=f"Fit: y={m:.2f}x+{b:.2f}")

        lims = [
            min(np.nanmin(reported_el), np.nanmin(est_el)),
            max(np.nanmax(reported_el), np.nanmax(est_el)),
        ]
        plt.plot(lims, lims, "k--", label="y=x")

        plt.xlabel("Reported Elevation (deg)")
        plt.ylabel("Estimated Elevation (deg)")
        plt.title("Estimated vs Reported Elevation")
        plt.grid(True)
        plt.legend()
        plt.tight_layout()
        plt.savefig(os.path.join(output_folder, "elevation_scatter.png"), dpi=300, bbox_inches="tight")
        plt.close()

    # =====================================
    # Quit
    # =====================================
    def on_quit(self, evt):
        if self.timer.IsRunning():
            self.timer.Stop()
        self.Close()


# =====================================
# Run
# =====================================
if __name__ == "__main__":
    app = wx.App(False)
    frame = StimulusApp()
    app.MainLoop()