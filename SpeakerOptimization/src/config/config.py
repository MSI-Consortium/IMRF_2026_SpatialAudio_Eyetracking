import numpy as np

# ============================================================
# Speaker Counts
# ============================================================
# SPEAKER_COUNTS = [16, 18, 20, 22, 24]
SPEAKER_COUNTS = [24]
NUM_SPEAKERS = 24  # default for single-run mode
MIN_SPEAKER_DISTANCE = 0.3

# ============================================================
# Listener Grid (3D)
# ============================================================
LISTENER_HEAD_HEIGHT = 1.2
LISTENER_GRID_SIZE = (3, 3, 2)  # (nx, ny, nz) 3D grid in CAVE center
LISTENER_HEIGHT_RANGE = (0.9, 1.5)  # seated to standing head height
LISTENER_MODE = 'single'
LISTENER_CENTER = [0.0, 0.0, 1.2]   # (x, y, z) in meters

# ============================================================
# Test Directions
# ============================================================
NUM_TEST_DIRECTIONS = 256

# ============================================================
# Differential Evolution Parameters
# ============================================================
DE_PARAMS = {
    'strategy': 'randtobest1bin',  # balances exploration (rand) with exploitation (best)
    'maxiter': 500,
    'popsize': 15,                 # actual pop = popsize * dimensionality
    'tol': 0,                      # never stop early on convergence — let restarts handle it
    'mutation': (0.5, 1.5),        # wider dithering for better exploration
    'recombination': 0.9,          # higher crossover to spread good genes faster
    'polish': True,                # L-BFGS-B local refinement after DE
    'disp': True,
    'workers': 1,                  # set >1 for parallel evaluation
    'seed': 42,
}

# Multi-restart: run DE this many times with different seeds, keep best
NUM_RESTARTS = 3

# ============================================================
# VBAP Cost Function Weights
# ============================================================
COST_WEIGHTS = {
    'coverage': 0,          # fraction of directions with valid VBAP triangle (full sphere)
    'upper_coverage': 0,   # upper hemisphere coverage (elevation >= 0) -- achievable target
    'loc_error': 0,         # rV angular error (always ~0 with correct VBAP, kept for partial coverage)
    'energy_error': 0,      # rE angular error -- primary localization quality metric
    'energy_var': 3,
    'rV_mag': 1,            # rV magnitude deviation from 1.0 (localization sharpness)
    'rE_mag': 1,            # rE magnitude deviation from 1.0
    'conditioning': 0,      # triangle condition numbers (affects rE quality)
    'uniformity': 0,        # variance of triangle solid angles
    'max_gap': 0,           # largest angular gap between speakers
    'distance_penalty': 0,  # penalize distant speakers
    'spread_penalty': 0,    # angular spread uniformity (Tammes-like)
    'symmetry_weight': 0,  # penalize left/right speaker count imbalance
    'coverage_floor': 0,   # minimum acceptable worst-case upper-hemisphere coverage
    'coverage_floor_weight':0,   # penalty for falling below floor
    'aggregation': 'weighted_worst',  # 'mean', 'worst', 'weighted_worst'
    'worst_weight': 0.3,      # weight for worst listener in weighted_worst
    'adaptive': True,         # scale weights by gap-from-ideal at start
}

# Stagnation: stop a DE restart if no improvement for this many generations
STAGNATION_LIMIT = 20

# Penalty scaling for constraint violations in DE
FEASIBILITY_PENALTY = 10.0
DISTANCE_PENALTY_FACTOR = 5.0

# ============================================================
# Room Geometry
# ============================================================
SPACE_DEFINITION = {
    'cave_dims': {
        'width': 4.04,
        'height': 2.40,
        'depth': 3.73,
    },
    'wall_offsets': {
        'min': 0.2,
        'max': 0.5,
    },
    'ceiling_offsets': {
        'min': 0.1,
        'max': 0.5,
    },
    'entrance_space': {
        'width': 1.4,
        'height': 2.0,
    },
    # 'projector_space': {
    #     'width': 2.0,
    #     'depth': 4.73,
    # },
    'projector_spaces': {
        'proj_sp1': {
            'width': 1.3,
            'depth': 0.8,
            'x_offset': -0.4,
            'y_min': 0.1
        },
        'proj_sp2': {
            'width': 1.7,
            'depth': 0.5,
            'x_offset': -1,
            'y_min': 0.9
        },
        'proj_sp3': {
            'width': 1.8,
            'depth': 0.8,
            'x_offset': -0.9,
            'y_min': 1.4
        },
        'proj_sp4': {
            'width': 1.3,
            'depth': 1.6,
            'x_offset': -0.65,
            'y_min': 2.63
        }
    },
}

# ============================================================
# Output
# ============================================================
OUTPUT_DIR = 'results'

# ============================================================
# Logging
# ============================================================
LOGGING_SETTINGS = {
    'verbosity': 2,
    'log_to_file': True,
    'log_filename': 'optimization_log.txt',
}
