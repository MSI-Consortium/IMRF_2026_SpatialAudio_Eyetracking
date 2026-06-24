"""
Results storage and comparison plotting.
"""

import numpy as np
import json
import os
from datetime import datetime
import matplotlib.pyplot as plt


def save_results(all_results: list, output_dir: str):
    """Save all results to a JSON file with timestamp."""
    os.makedirs(output_dir, exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filepath = os.path.join(output_dir, f"optimization_results_{timestamp}.json")

    # Make JSON-serializable (strip convergence logs to keep file size down)
    serializable = []
    for r in all_results:
        sr = {}
        for k, v in r.items():
            if k == "convergence_log":
                continue  # skip large log
            if isinstance(v, np.ndarray):
                sr[k] = v.tolist()
            elif isinstance(v, dict):
                sr[k] = {
                    kk: (vv.tolist() if isinstance(vv, np.ndarray) else vv)
                    for kk, vv in v.items()
                }
            else:
                sr[k] = v
        serializable.append(sr)

    with open(filepath, "w") as f:
        json.dump(serializable, f, indent=2)
    print(f"Results saved to {filepath}")
    return filepath


def plot_comparison(all_results: list, output_dir: str = "results"):
    """Generate comparison plots across speaker counts."""
    os.makedirs(output_dir, exist_ok=True)

    ns = [r["n_speakers"] for r in all_results]
    costs = [r["best_cost"] for r in all_results]
    coverages = [r["metrics"].get("mean_coverage", 0) for r in all_results]
    loc_errors = [r["metrics"].get("mean_mean_loc_error", 0) for r in all_results]
    max_gaps = [r["metrics"].get("mean_max_gap", 0) for r in all_results]

    fig, axes = plt.subplots(2, 2, figsize=(14, 10))

    axes[0, 0].plot(ns, costs, "bo-", linewidth=2, markersize=8)
    axes[0, 0].set_xlabel("Number of Speakers")
    axes[0, 0].set_ylabel("Total Cost")
    axes[0, 0].set_title("Total Cost vs Speaker Count")
    axes[0, 0].grid(True)

    axes[0, 1].plot(ns, coverages, "go-", linewidth=2, markersize=8)
    axes[0, 1].set_xlabel("Number of Speakers")
    axes[0, 1].set_ylabel("Mean Coverage")
    axes[0, 1].set_title("VBAP Coverage vs Speaker Count")
    axes[0, 1].set_ylim(0, 1.05)
    axes[0, 1].grid(True)

    axes[1, 0].plot(ns, loc_errors, "ro-", linewidth=2, markersize=8)
    axes[1, 0].set_xlabel("Number of Speakers")
    axes[1, 0].set_ylabel("Mean Localization Error")
    axes[1, 0].set_title("Localization Error vs Speaker Count")
    axes[1, 0].grid(True)

    axes[1, 1].plot(ns, max_gaps, "mo-", linewidth=2, markersize=8)
    axes[1, 1].set_xlabel("Number of Speakers")
    axes[1, 1].set_ylabel("Mean Max Gap (normalized)")
    axes[1, 1].set_title("Max Angular Gap vs Speaker Count")
    axes[1, 1].grid(True)

    plt.tight_layout()
    filepath = os.path.join(output_dir, "comparison_plot.png")
    plt.savefig(filepath, dpi=150)
    plt.close()
    print(f"Comparison plot saved to {filepath}")
