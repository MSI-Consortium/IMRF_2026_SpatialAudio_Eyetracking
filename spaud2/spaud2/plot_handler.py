import os, time, matplotlib

def _select_gui_backend(preferred=None):
    candidates = [preferred] if preferred else []
    if os.environ.get("PYCHARM_HOSTED") == "1":
        candidates += ["TkAgg", "Qt5Agg", "MacOSX"]
    candidates += ["TkAgg", "Qt5Agg", "MacOSX", "Agg"]
    try:
        import matplotlib.pyplot as plt  # noqa
        for b in candidates:
            try:
                if b: plt.switch_backend(b); return b
            except Exception:
                continue
    except Exception:
        for b in candidates:
            try:
                if b: matplotlib.use(b, force=True); return b
            except Exception:
                continue
    return matplotlib.get_backend()

def PlotHandler(fig, *, display=False, save=True, displayAutoPause=None, savePath=None, backend=None, **kwargs):
    import matplotlib.pyplot as plt
    # Save first
    if save and savePath:
        try:
            fig.savefig(savePath, dpi=kwargs.get("dpi", 100))
            print(f"[PLOT] Saved to {savePath}")
        except Exception as e:
            print(f"[WARN] Save failed: {e}")

    if not display:
        plt.close(fig); return

    _select_gui_backend(backend)
    try:
        if displayAutoPause is None:
            plt.show()  # blocking
        else:
            plt.show(block=False)
            try:
                plt.pause(float(displayAutoPause))
            except Exception:
                time.sleep(float(displayAutoPause))
    finally:
        plt.close(fig)
