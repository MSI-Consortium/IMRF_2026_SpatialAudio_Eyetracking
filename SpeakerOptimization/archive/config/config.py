import numpy as np

# General Settings
NUM_SPEAKERS = 24
MIN_SPEAKER_DISTANCE = 0.3

# Listener positions (example: a list of 3D coordinates for multiple listeners)
LISTENER_POSITIONS = np.array([
    [0.0, 0.0, 1.2],  # Central listener
])

# Optimization Settings
OPTIMIZATION_SETTINGS = {
    'rng': np.random.RandomState(),
    'n_iterations': 3000,
    'initial_step_scale': 0.25,
    'min_step_scale': 0.01,
    'max_step_scale': 1.0,
    'patience': 75,
    'shrink_factor': 0.6,
    'grow_factor': 1.05,
    'initial_temperature': 0.05,
    'final_temperature': 0.0,
}

# Number of directions to test when running HOA and VBAP simulation
TEST_DIRECTIONS = 128

# Weights for the different cost terms
COST_TERM_WEIGHTS = {
    'vbap': 1,
    'hoa': 0,
    'off': 0,
    'reg': 0
}

HOA_ARGS = {
    "rV_ang": 1.0,
    "rV_mag": 1.0,
    "rE_ang": 1.0,
    "rE_mag": 1.0,
    "match": 1.0,
    "gain": 0.1,
    "gain_sharpness": 4.0,
    "distance_power": 1.0,
}

# Room Geometry (Boxes defining regions in the room)
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
    'projector_space': {
        'width': 2.0,
        'depth': 4.73
    }
}

# Debug/Logging Settings
LOGGING_SETTINGS = {
    'verbosity': 2,  # 0 = none, 1 = minimal, 2 = detailed
    'log_to_file': True,
    'log_filename': 'optimization_log.txt',
}