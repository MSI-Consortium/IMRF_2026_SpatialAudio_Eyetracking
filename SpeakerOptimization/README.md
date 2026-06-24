# SpeakerOptimization

Optimizes physical speaker placement in a CAVE (Cave Automatic Virtual Environment) for 3D spatial audio using real VBAP (Vector Base Amplitude Panning) physics and population-based global optimization.

## What It Does

Given a constrained room geometry (walls, ceiling, entrance opening, ceiling projector), this system finds the optimal 3D positions for 16–24 speakers that maximize VBAP reproduction quality across multiple listener positions. The cost function is built on real VBAP triangulation — convex hull decomposition, per-triangle gain solving, and eight perceptual quality metrics evaluated over 256 test directions at 18 listener positions.

## Quick Start

**Requirements:** Python 3.10+, NumPy, SciPy, Matplotlib, Plotly

```bash
# Install dependencies
conda env create -f environment.yml
conda activate speaker_opt

# Run full optimization (all speaker counts)
python -m run

# Or use the Jupyter notebook for interactive exploration
jupyter notebook speaker_optimization_viz.ipynb
```

## Two Entry Points

### CLI (`python -m run`)

Runs the full optimization sweep over speaker counts [16, 18, 20, 22, 24]. Each count runs multi-start L-BFGS-B or Differential Evolution with multi-restart. Results are saved to `results/` as JSON with comparison plots. Best for production runs and overnight jobs.

### Notebook (`speaker_optimization_viz.ipynb`)

Interactive control center for both running optimization and analyzing results. Supports two modes:
- **Run mode**: Configure parameters and optimize directly in the notebook (DE, multistart L-BFGS-B, dual annealing, or CMA-ES) with live convergence plots
- **Load mode**: Load saved CLI results for post-hoc analysis

The notebook provides 12 analysis sections covering room geometry, VBAP triangulation, per-direction coverage heatmaps, before/after layouts, sound field rendering, frequency-dependent perception analysis, reference layout comparison (ITU 7.1.4), per-elevation quality breakdown, hypothetical floor speaker impact, and multi-speaker-count sweeps. Both static matplotlib and interactive Plotly visualizations are included.

## How It Works

### VBAP Engine (`src/spatial_audio/vbap.py`)

The `VBAPRenderer` class implements full 3D VBAP:
- Computes unit direction vectors from listener to each speaker
- Builds a **convex hull** (`scipy.spatial.ConvexHull`) on those directions — the hull facets define the VBAP speaker triplets (spherical Delaunay triangulation)
- Precomputes `L⁻¹` for each triangle at construction time
- For each desired source direction, finds the enclosing triangle and solves the **3×3 linear system** `g = L⁻¹ · d` for panning gains
- Only the 3 speakers in the active triangle get nonzero gain (sparse activation)
- Computes **velocity vector (rV)** and **energy vector (rE)** for perceptual localization assessment at low and high frequencies respectively

The `evaluate_vbap_quality()` function returns eight metrics via vectorized batch evaluation:

| Metric | What it measures | Ideal |
|--------|-----------------|:-----:|
| Coverage | Fraction of directions with a valid VBAP triangle | 1.0 |
| Localization error | Mean rV angular error (low-freq direction accuracy) | 0.0 |
| Energy error | Mean rE angular error (high-freq direction accuracy) | 0.0 |
| rV magnitude | Deviation of \|rV\| from 1.0 (localization sharpness) | 0.0 |
| rE magnitude | Deviation of \|rE\| from 1.0 (energy sharpness) | 0.0 |
| Conditioning | Mean condition number of active triangles (stability) | 0.0 |
| Angular uniformity | Variance of triangle solid angles (evenness) | 0.0 |
| Max gap | Largest angular gap between adjacent speakers | 0.0 |

Directions below the horizon are down-weighted by `cos(elevation)²` to prevent the floor gap from dominating the score.

### Cost Function (`src/optimization/objective.py`)

The cost function evaluates all 8 VBAP metrics at each of **18 listener positions** (3×3×2 grid spanning seated-to-standing heights) and aggregates via weighted worst-case:

```
cost = 0.7 × mean(per_listener_costs) + 0.3 × max(per_listener_costs)
```

**Adaptive weight scaling** adjusts metric weights before optimization: metrics far from their realistic ideal receive higher weight, while metrics already near ideal are downweighted. Realistic ideals account for room geometry constraints (e.g., ~27° localization error floor imposed by the missing floor speakers).

| Weight | Metric | Priority |
|:------:|--------|----------|
| 5.0 | Coverage | Highest — can all directions be panned? |
| 5.0 | Localization error | Highest — perceived direction accuracy |
| 2.0 | Max gap | High — worst angular hole |
| 1.0 | Energy error, rV magnitude, conditioning, uniformity | Standard |
| 0.5 | rE magnitude, distance penalty | Lower |

### Optimizer (`src/optimization/search.py`)

Four optimizer backends are available:

| Backend | Method | Best for |
|---------|--------|----------|
| `optimize_layout_multistart()` | Multi-start L-BFGS-B | Fast exploration; smooth landscapes |
| `optimize_layout_de()` | Multi-restart Differential Evolution | Production runs; global search |
| `optimize_layout_da()` | Dual Annealing + L-BFGS-B | Thin feasible regions |
| `optimize_layout_cmaes()` | CMA-ES (requires `cma` package) | Correlated variables |

All backends share the same **repair+penalty constraint handling**:
- Infeasible speakers are projected to the nearest valid box, with a penalty proportional to repair distance
- Soft minimum-distance penalty for speakers closer than 0.3m
- Angular spread penalty (Tammes-like) for uniform distribution
- Left-right symmetry penalty
- Feasible initial populations seeded with valid random layouts

For 24 speakers (72D) with DE: population of ~1,080 individuals, up to 500 generations per restart, 3 restarts, stagnation detection at 20 generations, L-BFGS-B polish after convergence.

## Room Geometry

The CAVE room (4.04m × 3.73m × 2.40m) is modeled as axis-aligned boxes:

- **5 allowed regions**: 4 walls + ceiling (with 0.20–0.50m mounting offset bands)
- **2 forbidden regions**: entrance opening (1.4m × 2.0m on front wall center) and ceiling projector (2.0m × 4.73m)
- **Minimum speaker separation**: 0.3m
- Speakers mount on the **exterior** of the CAVE structure, behind acoustically transparent projection screens

## Project Structure

```
SpeakerOptimization/
├── run.py                              # CLI entry point
├── speaker_optimization_viz.ipynb      # Notebook entry point (12 analysis sections)
├── environment.yml                     # Conda environment
├── SPEAKER_PLACEMENT_REPORT.md         # Generated optimization report
├── CHANGELOG.md                        # v1 → v2 rebuild documentation
├── src/
│   ├── config/config.py                # All parameters (DE, cost weights, room, listener grid)
│   ├── geometry/
│   │   ├── box.py                      # Box dataclass for 3D regions
│   │   ├── define_spaces.py            # Room geometry definition
│   │   └── geometry_utils.py           # Fibonacci sphere, angles, distances
│   ├── optimization/
│   │   ├── objective.py                # Multi-listener VBAP cost function + adaptive weights
│   │   ├── search.py                   # 4 optimizer backends (DE, multistart, DA, CMA-ES)
│   │   └── speaker_placement.py        # Layout init, repair, feasible population generation
│   ├── spatial_audio/
│   │   ├── vbap.py                     # Real VBAP: ConvexHull triangulation + gain solving
│   │   └── hoa_cost_terms.py           # HOA metrics (legacy, retained for reference)
│   ├── recipes/
│   │   └── test_run.py                 # Orchestration: sweep, listener grid, results
│   └── utils/
│       ├── plot_layout.py              # 3D room visualization
│       └── results_summary.py          # JSON save + comparison plots
├── figures/                            # Generated analysis figures
├── results/                            # Output directory for optimization results
└── archive/                            # Original v1 source files
```

## Configuration

All parameters are in `src/config/config.py`. Key settings:

```python
SPEAKER_COUNTS = [16, 18, 20, 22, 24]      # speaker counts to sweep
NUM_TEST_DIRECTIONS = 256                    # test directions on unit sphere
LISTENER_GRID_SIZE = (3, 3, 2)              # 18 listener positions (3D grid)
LISTENER_HEIGHT_RANGE = (0.9, 1.5)          # seated to standing head height
MIN_SPEAKER_DISTANCE = 0.3                  # meters

DE_PARAMS = {
    'strategy': 'randtobest1bin',   # balances exploration and exploitation
    'maxiter': 500,                 # DE generations per restart
    'popsize': 15,                  # pop = popsize × dimensionality
    'mutation': (0.5, 1.5),         # dithered mutation
    'recombination': 0.9,           # crossover probability
    'polish': True,                 # L-BFGS-B after DE
}

NUM_RESTARTS = 3                    # independent DE restarts
STAGNATION_LIMIT = 20              # early stop if no improvement

COST_WEIGHTS = {
    'coverage': 5.0,                # can all directions be panned?
    'loc_error': 5.0,               # perceived direction accuracy (rV)
    'energy_error': 1.0,            # high-freq direction accuracy (rE)
    'max_gap': 2.0,                 # largest angular hole
    'conditioning': 1.0,            # triangle numerical stability
    'uniformity': 1.0,              # triangle size evenness
    'adaptive': True,               # auto-scale weights by gap from ideal
    'aggregation': 'weighted_worst', # 70% mean + 30% worst listener
}
```

For quick experiments, reduce `maxiter` and `popsize` in the notebook's configuration cell, or use the `multistart` backend which is significantly faster than DE.

## Output

**CLI results** are saved to `results/` as timestamped JSON files containing:
- Best speaker layout (x, y, z positions per speaker)
- Cost breakdown (total, per-metric, per-listener)
- Optimizer statistics (function evaluations, iterations, convergence status)
- Comparison plots across speaker counts

**Notebook report** is exported to `SPEAKER_PLACEMENT_REPORT.md` with full analysis: room specs, speaker coordinates, performance metrics, elevation band analysis, floor speaker impact study, reference layout comparison, and methodology documentation.
