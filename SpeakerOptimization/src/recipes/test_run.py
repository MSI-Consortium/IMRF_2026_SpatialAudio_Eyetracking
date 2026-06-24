"""
Main orchestration script.

Runs Differential Evolution optimization over multiple speaker counts,
evaluates across a listener grid, and saves/plots results.
"""

import numpy as np
import os

from ..geometry.define_spaces import define_spaces
from ..optimization.objective import generate_test_directions, score_layout
from ..optimization.search import optimize_layout_de, optimize_layout_multistart
from ..utils.plot_layout import plot_room_layout
from ..utils.results_summary import save_results, plot_comparison
from ..config import config


def make_listener_grid() -> np.ndarray:
    """Generate 3D listener positions in the center of the CAVE volume."""
    grid_size = config.LISTENER_GRID_SIZE
    cave_w = config.SPACE_DEFINITION["cave_dims"]["width"]
    cave_d = config.SPACE_DEFINITION["cave_dims"]["depth"]
    margin = 0.4  # stay away from walls

    xs = np.linspace(-cave_w / 2 + margin, cave_w / 2 - margin, grid_size[0])
    ys = np.linspace(-cave_d / 2 + margin, cave_d / 2 - margin, grid_size[1])

    if len(grid_size) == 3 and grid_size[2] > 1:
        h_lo, h_hi = config.LISTENER_HEIGHT_RANGE
        zs = np.linspace(h_lo, h_hi, grid_size[2])
    else:
        zs = np.array([config.LISTENER_HEAD_HEIGHT])

    grid = np.array(np.meshgrid(xs, ys, zs)).T.reshape(-1, 3)
    return grid


def run_single_optimization(
    n_speakers: int,
    feasible_boxes,
    forbidden_boxes,
    listener_positions: np.ndarray,
    test_directions: np.ndarray,
    optimizer: str = "multistart",
) -> dict:
    """Run optimization for a single speaker count.

    Parameters
    ----------
    optimizer : 'multistart' (L-BFGS-B from random starts), 'de' (differential evolution)
    """
    print(f"\n{'=' * 60}")
    print(f"Optimizing for N = {n_speakers} speakers ({optimizer})")
    print(f"Dimensionality: {n_speakers * 3}D")
    print(f"{'=' * 60}")

    convergence_log = []
    seed = config.DE_PARAMS.get("seed", 42)

    if optimizer == "multistart":
        best_layout, best_cost, result = optimize_layout_multistart(
            feasible_boxes=feasible_boxes,
            forbidden_boxes=forbidden_boxes,
            n_speakers=n_speakers,
            listener_positions=listener_positions,
            test_directions=test_directions,
            cost_weights=config.COST_WEIGHTS,
            min_speaker_distance=config.MIN_SPEAKER_DISTANCE,
            num_starts=30,
            seed=seed,
            convergence_log=convergence_log,
        )
    else:
        de_params = config.DE_PARAMS.copy()
        seed = de_params.pop("seed", 42)
        best_layout, best_cost, result = optimize_layout_de(
            feasible_boxes=feasible_boxes,
            forbidden_boxes=forbidden_boxes,
            n_speakers=n_speakers,
            listener_positions=listener_positions,
            test_directions=test_directions,
            cost_weights=config.COST_WEIGHTS,
            de_params=de_params,
            min_speaker_distance=config.MIN_SPEAKER_DISTANCE,
            seed=seed,
            convergence_log=convergence_log,
        )

    # Detailed evaluation of final layout
    final_metrics = score_layout(
        best_layout, listener_positions, test_directions, config.COST_WEIGHTS
    )

    return {
        "n_speakers": n_speakers,
        "best_cost": float(best_cost),
        "best_layout": best_layout.tolist(),
        "de_nfev": int(result.nfev),
        "de_nit": int(result.nit),
        "de_success": bool(result.success),
        "de_message": str(result.message),
        "metrics": final_metrics,
        "convergence_log": convergence_log,
    }


def main():
    """Main entry point: optimize over multiple speaker counts."""
    os.makedirs(config.OUTPUT_DIR, exist_ok=True)

    allowed_boxes, forbidden_boxes = define_spaces()
    listener_positions = make_listener_grid()
    test_directions = generate_test_directions(config.NUM_TEST_DIRECTIONS)

    print(f"CAVE room: {config.SPACE_DEFINITION['cave_dims']}")
    print(f"Listener grid: {len(listener_positions)} positions")
    print(f"Test directions: {len(test_directions)}")
    print(f"Speaker counts to evaluate: {config.SPEAKER_COUNTS}")

    all_results = []
    for n in config.SPEAKER_COUNTS:
        result = run_single_optimization(
            n_speakers=n,
            feasible_boxes=allowed_boxes,
            forbidden_boxes=forbidden_boxes,
            listener_positions=listener_positions,
            test_directions=test_directions,
        )
        all_results.append(result)

        # Plot each result
        plot_room_layout(
            allowed_boxes,
            forbidden_boxes,
            listener_positions,
            np.array(result["best_layout"]),
        )

    # Save and compare
    save_results(all_results, config.OUTPUT_DIR)
    plot_comparison(all_results, config.OUTPUT_DIR)

    # Summary table
    print(f"\n{'=' * 90}")
    print(
        f"{'N':>4} | {'Cost':>10} | {'Coverage':>10} | {'Loc Error':>10} | "
        f"{'Max Gap':>10} | {'FuncEvals':>10}"
    )
    print(f"{'-' * 90}")
    for r in all_results:
        m = r["metrics"]
        print(
            f"{r['n_speakers']:>4} | {r['best_cost']:>10.6f} | "
            f"{m.get('mean_coverage', 0):>10.4f} | "
            f"{m.get('mean_mean_loc_error', 0):>10.4f} | "
            f"{m.get('mean_max_gap', 0):>10.4f} | "
            f"{r['de_nfev']:>10}"
        )


if __name__ == "__main__":
    main()
