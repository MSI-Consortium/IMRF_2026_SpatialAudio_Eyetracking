from typing import Any
import numpy as np

def value_size_str(v: Any) -> str:
    """Human-ish description of variable 'size'."""
    if isinstance(v, np.ndarray):
        return f"ndarray{v.shape}, dtype={v.dtype}"
    if isinstance(v, (list, tuple, dict, set)):
        return f"{type(v).__name__} len={len(v)}"
    if isinstance(v, (str, bytes)):
        return f"{type(v).__name__} len={len(v)}"
    if np.isscalar(v):
        return f"scalar={v}"
    return type(v).__name__

def pick_visual_channel(segment):
    """Return 1-D signal for plotting (first channel if multi)."""
    import numpy as np
    if segment.ndim == 1:
        return segment
    return segment[:, 0]
