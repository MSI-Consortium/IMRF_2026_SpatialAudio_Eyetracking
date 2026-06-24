import numpy as np
import math
import matplotlib.pyplot as plt
from tqdm import tqdm
from .objective import score_layout
from .speaker_placement import initial_layout, perturb_layout_continuous
from ..utils.plot_layout import plot_room_layout, plot_multiple_layouts
from ..config import config


def local_search_optimize_layout(feasible_boxes, forbidden_boxes, test_positions):
    """
    Optimizes layout using stochastic local search with temperature-based acceptance.
    Now handles forbidden regions to ensure speakers are not placed in those regions.
    """

    n_speakers = config.NUM_SPEAKERS
    weights = config.COST_TERM_WEIGHTS
    hoa_weights = config.HOA_ARGS
    min_speaker_distance = config.MIN_SPEAKER_DISTANCE
    listener_positions = config.LISTENER_POSITIONS

    rng = config.OPTIMIZATION_SETTINGS["rng"]
    n_iterations = config.OPTIMIZATION_SETTINGS["n_iterations"]
    initial_step_scale = config.OPTIMIZATION_SETTINGS['initial_step_scale']
    patience = config.OPTIMIZATION_SETTINGS['patience']
    shrink_factor = config.OPTIMIZATION_SETTINGS['shrink_factor']
    grow_factor = config.OPTIMIZATION_SETTINGS["grow_factor"]
    initial_temperature = config.OPTIMIZATION_SETTINGS['initial_temperature']
    final_temperature = config.OPTIMIZATION_SETTINGS['final_temperature']

    if rng is None:
        rng = np.random.default_rng()

    # Sample initial layout if not provided
    current_layout = initial_layout(
        feasible_boxes, n_speakers, min_speaker_distance, rng, forbidden_boxes
    )

    current_breakdown = score_layout(current_layout, listener_positions, test_positions, weights, hoa_weights)
    current_score = current_breakdown["total_cost"]

    best_layout = current_layout
    best_score = current_score
    step_scale = initial_step_scale
    no_improve_counter = 0

    layouts = []  # This will store the layouts at different stages
    scores = []  # To store the corresponding scores

    for it in tqdm(range(n_iterations), desc="Optimization Progress", unit="iteration"):

        temperature = final_temperature if n_iterations <= 1 else (1 - it / (
                    n_iterations - 1)) * initial_temperature + (it / (n_iterations - 1)) * final_temperature

        candidate_layout = perturb_layout_continuous(
            current_layout, feasible_boxes, forbidden_boxes, step_scale, rng, min_speaker_distance
        )
        candidate_breakdown = score_layout(candidate_layout, listener_positions, test_positions, weights, hoa_weights)
        candidate_score = candidate_breakdown["total_cost"]

        delta = candidate_score - current_score
        accepted = False

        if delta <= 0:
            accepted = True
        elif temperature > 0:
            accept_prob = math.exp(-delta / max(temperature, 1e-12))
            if rng.random() < accept_prob:
                accepted = True

        if accepted:
            current_layout = candidate_layout
            current_breakdown = candidate_breakdown
            current_score = candidate_score
            step_scale = min(step_scale * grow_factor, 1.0)
        else:
            no_improve_counter += 1

        if candidate_score < best_score:
            best_layout = candidate_layout
            best_score = candidate_score
            no_improve_counter = 0

        if no_improve_counter >= patience:
            step_scale = max(step_scale * shrink_factor, 0.01)
            no_improve_counter = 0


    # Plot the layouts
    plot_multiple_layouts(feasible_boxes, forbidden_boxes, listener_positions, layouts, scores)

    return best_layout, best_score


def plot_cost_terms_over_time(cost_terms_over_time):
    """
    Plot the cost terms over time for each cost term (e.g., e_rV_ang, e_rV_mag, etc.).
    """
    plt.figure(figsize=(10, 6))

    for term, values in cost_terms_over_time.items():
        plt.plot(values, label=term)

    plt.xlabel("Iterations")
    plt.ylabel("Cost Term Value")
    plt.title("Cost Terms Over Time")
    plt.legend()
    plt.grid(True)
    plt.show()


