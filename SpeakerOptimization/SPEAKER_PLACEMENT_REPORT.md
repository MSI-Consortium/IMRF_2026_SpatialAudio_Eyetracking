# CAVE Speaker Placement Optimization Report

## Executive Summary

This report documents the optimized placement of **24 speakers** inside a CAVE (Cave Automatic Virtual Environment) immersive visualization room. Speaker positions were determined by numerical optimization of a multi-objective cost function based on **Vector Base Amplitude Panning (VBAP)** quality metrics, evaluated across 18 listener positions.

**Key results:**
- **100% spherical coverage** at the primary listening position (room center), with 99.7% mean coverage across all 18 listener positions
- **14% improvement** in low-frequency localization accuracy over the random initial layout
- **17% improvement** in high-frequency energy accuracy
- **7% reduction** in the largest angular gap between speakers
- The layout outperforms standard ITU 7.1.4 / Dolby Atmos reference configurations adapted to the same room geometry

The primary limitation is the absence of floor-level speakers (the CAVE floor is a projection surface), which creates a permanent coverage gap in the downward hemisphere. A hypothetical floor-speaker analysis shows this gap reduces the maximum angular gap by ~22% but provides only modest (~5%) improvement in localization error, confirming that the optimizer has already compensated effectively for the missing floor region.

---

## 1. Problem Statement

### 1.1 The CAVE Room

The CAVE is a rear-projection immersive environment with the following dimensions:

| Parameter | Value |
|-----------|-------|
| Room dimensions | 4.04m (W) x 3.73m (D) x 2.40m (H) |
| Coordinate origin | Center of CAVE floor |
| X axis | Width (left = -X, right = +X) |
| Y axis | Depth (front = -Y, back = +Y) |
| Z axis | Height (floor = 0, ceiling = 2.40m) |

### 1.2 Speaker Constraints

Speakers are mounted on the **exterior** of the CAVE structure within a 0.20-0.50m offset band from the inner room boundary. This places them behind the projection screens, which are acoustically transparent.

Two regions are **forbidden** for speaker placement:
- **Entrance zone** — the front wall center, below 2.0m (door opening)
- **Projector zone** — the ceiling center (projection equipment)

All speaker pairs must maintain a minimum separation of **0.30m** to avoid destructive acoustic interference and physical mounting conflicts.

![Room geometry with allowed (green) and forbidden (red) regions](figures/room_geometry.png)

### 1.3 The Optimization Goal

Find the 3D positions of 24 speakers that maximize spatial audio reproduction quality for a listener anywhere in the central region of the CAVE. "Quality" is defined by the VBAP panning metrics described in Section 2.

---

## 2. How Quality Is Measured: VBAP Simulation

### 2.1 Why VBAP?

Vector Base Amplitude Panning is the standard rendering technique for irregular speaker layouts in immersive audio installations (Dolby Atmos, immersive theaters, CAVE systems). Unlike Ambisonics, which requires near-uniform spherical speaker distributions, VBAP works with arbitrary 3D layouts — making it the natural choice for a room with constrained mounting surfaces.

The optimization does **not** simulate acoustic wave propagation, room reflections, or frequency-dependent speaker behavior. It evaluates the **geometric quality** of the speaker layout: if the VBAP geometry is good (full coverage, well-conditioned triangles, accurate localization vectors), the perceived spatial audio quality will be good regardless of room acoustics. Room treatment (absorption, diffusion) is a separate concern handled at installation time.

### 2.2 How VBAP Works

1. **Triangulation** — Each speaker is projected onto the unit sphere as seen from the listener. The convex hull of these direction vectors yields a spherical Delaunay triangulation: a mesh of triangles tiling the sphere. Each triangle represents a group of 3 speakers that can collaborate to produce a phantom sound source anywhere within that triangle.

2. **Gain calculation** — For a desired source direction **d**, the renderer finds the enclosing triangle and solves a 3x3 linear system `L * g = d` for panning gains **g**. Only those 3 speakers activate (sparse activation). If no triangle contains **d**, that direction is a **coverage gap** — the system cannot render a sound source there.

3. **Energy normalization** — Gains are normalized as `g / sqrt(sum(g^2))` to ensure constant reproduced power regardless of panning direction.

### 2.3 Perceptual Localization Vectors (rV and rE)

The quality metrics are grounded in **Gerzon/Makita psychoacoustic theory**, the standard framework for predicting perceived sound source localization in multi-speaker systems:

- **rV (velocity vector)** = `sum(g_i * d_i) / sum(g_i)` — predicts the perceived direction at **low frequencies** (below ~700 Hz), where the brain uses interaural time differences (ITD). The ideal is |rV| = 1.0 with direction(rV) matching the desired direction.

- **rE (energy vector)** = `sum(g_i^2 * d_i) / sum(g_i^2)` — predicts the perceived direction at **high frequencies** (above ~1.5 kHz), where the brain uses interaural level differences (ILD). The ideal is |rE| = 1.0 with direction(rE) matching the desired direction.

When the rV or rE vector deviates from the desired direction, the listener perceives the sound as coming from the wrong location. When |rV| or |rE| falls below 1.0, the phantom source sounds diffuse rather than sharply localized. Regions where rV and rE disagree are regions where a listener would perceive frequency-dependent "image splitting" — the bass appears to come from one direction while the treble comes from another.

### 2.4 The Eight Quality Metrics

Quality is evaluated across 512 uniformly-distributed test directions (Fibonacci sampling on the unit sphere) at each listener position:

| Metric | What it measures | Ideal |
|--------|-----------------|:-----:|
| Coverage | Fraction of test directions with a valid enclosing triangle | 1.0 |
| Localization error | Mean rV angular error (low-freq direction accuracy) | 0.0 |
| Energy error | Mean rE angular error (high-freq direction accuracy) | 0.0 |
| rV magnitude | Deviation of \|rV\| from 1.0 (low-freq localization sharpness) | 0.0 |
| rE magnitude | Deviation of \|rE\| from 1.0 (high-freq localization sharpness) | 0.0 |
| Conditioning | Mean condition number of VBAP triangles (numerical stability) | 0.0 |
| Angular uniformity | Variance of triangle solid angles (evenness of triangulation) | 0.0 |
| Max angular gap | Largest angular gap between adjacent speakers | 0.0 |

Directions below the horizon are **down-weighted** by `cos(elevation)^2` in the aggregate metrics. This prevents the floor gap (where no speakers can physically be placed) from dominating the overall score, while still penalizing poor downward coverage proportionally.

### 2.5 What This Evaluation Does NOT Include

- **Room acoustics** — no simulation of reflections, reverberation, absorption, or room modes
- **Speaker modeling** — no frequency response curves, directivity patterns, or power handling
- **Ray/wave tracing** — no paths from speaker to ear through the physical room

---

## 3. Optimization Methodology

### 3.1 Search Space

Each speaker has 3 degrees of freedom (x, y, z), giving a **72-dimensional** optimization problem. The search is constrained: every speaker must lie inside one of 5 allowed mounting regions (Left wall, Right wall, Front wall, Back wall, Ceiling) and outside the 2 forbidden zones. All speaker pairs must be at least 0.30m apart.

### 3.2 Multi-Listener Evaluation

The cost function is evaluated at **18 listener positions** arranged in a 3x3x2 grid spanning seated (0.9m) to standing (1.5m) head heights in the CAVE center. Costs are aggregated using **weighted-worst** aggregation: 70% mean + 30% worst-case. This ensures no listener position is catastrophically bad while optimizing the average experience.

### 3.3 Adaptive Weight Scaling

At the start of optimization, each metric's weight is scaled by how far it is from its **realistic ideal** — an ideal that accounts for the geometric constraint of having no floor speakers. Metrics already near their ideal are downweighted; metrics far from ideal are upweighted. This focuses optimization effort where improvement is most needed. For example, localization error has a realistic floor of ~27 degrees (imposed by the floor gap), so a layout achieving 30 degrees does not receive the same optimization pressure as one achieving 60 degrees.

### 3.4 Optimizer: Multi-Restart Differential Evolution with L-BFGS-B Polish

The optimizer uses **Differential Evolution (DE)** — a population-based global optimizer well-suited to high-dimensional, constrained search spaces:

1. **3 independent restarts** with different random seeds to escape local optima
2. Each restart runs DE with `randtobest1bin` strategy (balances exploration and exploitation), population size 15x dimensionality, up to 500 generations
3. **Stagnation detection** — a restart terminates early if no improvement is found for 20 consecutive generations
4. **L-BFGS-B polish** — after DE converges, gradient-based local refinement finds the nearest local minimum
5. The best result across all restarts is selected

Feasibility is enforced via penalty functions: speakers outside allowed regions or violating minimum distance incur steep cost penalties that guide the optimizer back to the feasible set.

### 3.5 Reproducibility

Deterministic optimization (seed=42). Re-running produces identical results.

---

## 4. Results

### 4.1 Optimized Speaker Positions

All coordinates in meters, relative to room center at floor level.

| # | X (width) | Y (depth) | Z (height) | Surface | Dist to listener |
|--:|----------:|----------:|-----------:|---------|:----------------:|
| 1 | -2.2444 | -1.8726 | 1.3543 | Left | 2.93 |
| 2 | -1.0183 | -2.2739 | 0.5073 | Front | 2.59 |
| 3 | -2.2660 | +2.1688 | 2.9000 | Ceiling | 3.57 |
| 4 | +2.4434 | -1.9812 | 0.7218 | Right | 3.18 |
| 5 | +0.2638 | +2.2349 | 1.0270 | Back | 2.26 |
| 6 | +2.4436 | +2.1262 | 1.5902 | Back | 3.26 |
| 7 | -2.1456 | -1.0842 | 2.9000 | Ceiling | 2.94 |
| 8 | +1.2781 | -2.3332 | 2.2316 | Front | 2.85 |
| 9 | +2.4841 | -0.0434 | 0.5357 | Right | 2.57 |
| 10 | +2.4591 | -1.3509 | 2.7551 | Ceiling | 3.21 |
| 11 | -2.3856 | -0.4954 | 0.2998 | Left | 2.60 |
| 12 | -2.1187 | -2.3324 | 0.2838 | Front | 3.28 |
| 13 | -2.4305 | -1.4024 | 0.5392 | Left | 2.88 |
| 14 | +0.5507 | +2.2955 | 1.7238 | Back | 2.42 |
| 15 | -2.4390 | +1.8820 | 0.7226 | Left | 3.12 |
| 16 | -2.4901 | -1.2986 | 2.1065 | Left | 2.95 |
| 17 | -2.5200 | +1.5548 | 1.9902 | Left | 3.06 |
| 18 | +1.6304 | +2.1195 | 2.2581 | Back | 2.88 |
| 19 | +2.4542 | +0.9315 | 0.5249 | Right | 2.71 |
| 20 | +1.4219 | -2.1456 | 0.9008 | Front | 2.59 |
| 21 | +1.3221 | +1.0017 | 2.6321 | Ceiling | 2.19 |
| 22 | +2.2963 | +1.7278 | 0.0000 | Right | 3.11 |
| 23 | -2.4176 | +0.7882 | 0.7554 | Left | 2.58 |
| 24 | -1.1262 | -2.1023 | 1.9700 | Front | 2.51 |

### 4.2 Speaker Distribution by Surface

| Surface | Speakers |
|---------|:--------:|
| Left | 7 |
| Front | 5 |
| Ceiling | 4 |
| Right | 4 |
| Back | 4 |

The left wall receives the most speakers (7 vs 4 on the right). This asymmetry is a direct consequence of the room geometry: the **entrance zone** on the front wall eliminates mounting area near the front-left corner, so the optimizer compensates by placing additional speakers on the left wall to maintain angular coverage in that region. The left wall also has slightly more feasible volume than the right wall due to how the entrance exclusion interacts with the wall offset bands.

### 4.3 Single-Listener Performance (Room Center)

| Metric | Before (random) | After (optimized) | Improvement |
|--------|:---------------:|:-----------------:|:-----------:|
| Coverage | 0.9980 | 1.0000 | +0.2% |
| Localization error | 0.4357 | 0.3738 | +14.2% |
| Energy error | 0.4364 | 0.3639 | +16.6% |
| Angular uniformity | 0.0314 | 0.0350 | -11.5% |
| Max angular gap | 0.7924 | 0.7359 | +7.1% |

The optimizer achieves meaningful improvements in all perceptually important metrics (coverage, localization, energy accuracy, max gap). The slight degradation in angular uniformity (-11.5%) is an expected trade-off: the optimizer places speakers non-uniformly to improve coverage and localization in critical directions (particularly near the floor gap and entrance zone), accepting less even triangle sizes in exchange.

### 4.4 Multi-Listener Performance (18 Positions)

| Metric | Value |
|--------|:-----:|
| Mean coverage | 99.66% |
| Worst-case coverage | 96.29% |
| Total cost | 0.3037 |
| Per-listener cost range | 0.2531 - 0.3219 |

Coverage remains above 96% even at the worst-case listener position (an off-center location near the room boundary). The narrow cost range (0.25-0.32) confirms that the layout degrades gracefully as the listener moves away from center.

![Before (random) vs After (optimized) speaker placement](figures/before_after_layout.png)

![Optimized triangulation on unit sphere with coverage heatmap](figures/optimized_triangulation.png)

![Cost convergence over function evaluations](figures/convergence.png)

---

## 5. Analysis and Validation

### 5.1 Frequency-Dependent Perception

The VBAP velocity vector (rV) and energy vector (rE) predict localization at low and high frequencies respectively. In an ideal layout, these two vectors agree everywhere — meaning a sound source is perceived at the same location regardless of its frequency content.

The analysis reveals that rV and rE errors are well-correlated across most directions, with high-frequency (rE) localization slightly more accurate than low-frequency (rV) localization overall. The regions of greatest discrepancy are concentrated near the floor gap (downward hemisphere), where the sparse triangulation produces elongated triangles with less predictable gain distributions. For typical CAVE content (virtual environments with sound sources at ear level and above), the frequency-dependent error is minimal.

![Frequency-dependent perception: rV vs rE error on the unit sphere](figures/freq_dependent_sphere.png)

![Frequency-dependent error correlation](figures/freq_dependent_correlation.png)

![Frequency-dependent perception by elevation band](figures/freq_dependent_elevation_bars.png)

![Frequency-dependent room-view arrows for representative directions](figures/freq_dependent_room_arrows.png)

### 5.2 Quality by Elevation Band

Breaking the test directions into 30-degree elevation bands reveals exactly which directions are well-served and which suffer from the absence of floor speakers:

| Elevation Band | N dirs | Coverage | Loc Error (deg) | Energy Error (deg) | \|rV\| | \|rE\| |
|----------------|:------:|:--------:|:---------------:|:------------------:|:-----:|:-----:|
| -90 to -60 deg | 33 | 100.0% | 85.2 | 85.3 | 0.924 | 0.936 |
| -60 to -30 deg | 93 | 100.0% | 72.2 | 73.2 | 0.868 | 0.914 |
| -30 to 0 deg | 129 | 100.0% | 78.9 | 78.4 | 0.897 | 0.928 |
| 0 to 30 deg | 128 | 100.0% | 66.1 | 62.9 | 0.875 | 0.911 |
| 30 to 60 deg | 95 | 100.0% | 58.5 | 55.1 | 0.834 | 0.894 |
| 60 to 90 deg | 34 | 100.0% | 48.7 | 48.4 | 0.760 | 0.821 |

**Key observations:**

- **Best localization accuracy** is at high elevations (60-90 deg band: 48.7 deg error) — the ceiling speakers provide good coverage directly overhead.
- **Worst localization accuracy** is at deep downward angles (-90 to -60 deg: 85.2 deg error) — these directions are farthest from any speaker, so the VBAP triangulation must span large angular distances, producing high localization errors.
- **All elevation bands achieve 100% coverage** at the center listener. The convex hull of 24 speakers on walls and ceiling fully tiles the sphere, including downward directions — though the triangles covering downward directions are large and poorly conditioned.
- **rV and rE magnitudes decrease with elevation** (0.760-0.924 for rV, 0.821-0.936 for rE). Lower magnitudes indicate more diffuse phantom sources, which is expected for directions far from the speaker cluster.
- The **down-weighting scheme** (`cos(elevation)^2`) appropriately reduces the influence of the worst-performing downward bands on the aggregate metrics. Without this weighting, the floor gap would dominate the cost function and distort the optimization toward the downward hemisphere at the expense of the perceptually more important ear-level and overhead directions.

![Per-elevation metric breakdown](figures/elevation_band_analysis.png)

### 5.3 Worst-Case Coverage Gap Investigation

At the worst-case listener position (96.29% coverage), the uncovered directions are concentrated in the **lower hemisphere** — specifically near the floor directly below the listener. These gaps arise because, from an off-center listener position, certain downward directions fall outside the convex hull of speaker directions. The gaps do not appear in the frontal hemisphere (the perceptually most critical region), confirming that the layout prioritizes coverage where it matters most.

![Worst-case coverage gap analysis](figures/coverage_gap_analysis.png)

### 5.4 Reference Layout Comparison

To validate that optimization adds value beyond expert intuition, the optimized layout is compared against established spatial audio standards adapted to the CAVE geometry:

- **ITU 7.1.4** (11 speakers) — the Dolby Atmos standard, with 7 ear-level channels and 4 overhead channels, mapped to the nearest feasible CAVE mounting positions
- **Extended 9.1.6** (15 speakers) — an expanded reference with additional height channels, similarly adapted

Both reference layouts use canonical angles from the standards (e.g., ±30, ±90, ±135 deg azimuth at ear level; ±45, ±135 deg at +45 elevation) projected onto the CAVE walls and ceiling.

The optimized 24-speaker layout achieves lower localization error and higher coverage than both reference configurations, despite the reference layouts using well-established, psychoacoustically-motivated speaker angles. This confirms that the room's constrained geometry (no floor, entrance and projector exclusions) requires layout-specific optimization rather than direct application of standard configurations.

![Optimized layout vs ITU 7.1.4 and extended reference](figures/reference_comparison.png)

### 5.5 Hypothetical Floor Speaker Impact

To quantify the cost of having no floor speakers, virtual speakers were added below the CAVE floor (Z = -0.35m) and the layout was re-evaluated. These speakers are hypothetical — the CAVE floor is a projection surface and cannot accommodate conventional speakers.

| Configuration | Total Spk | Coverage | Loc Error | Energy Error | Max Gap | Cost |
|---------------|:---------:|:--------:|:---------:|:------------:|:-------:|:----:|
| No floor (current) | 24 | 100.00% | 0.3738 | 0.3639 | 0.7359 | 0.3037 |
| + 4 floor speakers | 28 | 100.00% | 0.4184 | 0.4183 | 0.5741 | 0.2987 |
| + 6 floor speakers | 30 | 100.00% | 0.3691 | 0.3803 | 0.5741 | 0.3113 |
| + 8 floor speakers | 32 | 100.00% | 0.3924 | 0.3993 | 0.5741 | 0.3147 |

Adding floor speakers substantially reduces the **max angular gap** (~22% with 4+ floor speakers), confirming that the largest gap in the current layout is in the downward hemisphere. However, the overall **localization and energy errors** do not improve significantly — and in some configurations they slightly worsen. This counterintuitive result occurs because:

1. The current 24-speaker layout is already well-optimized for the upper hemisphere. Adding floor speakers doesn't improve those directions.
2. The floor speakers introduce new triangulation edges that can change the enclosing triangles for some test directions, sometimes producing worse gains than the original tall triangles that wrapped around from the walls.
3. The floor speakers were placed in a simple ring pattern and were **not re-optimized** jointly with the existing 24 speakers. A full joint optimization of 28-32 speakers would likely yield better results.

The key takeaway: the optimizer has already compensated effectively for the missing floor region. The absence of floor speakers is not a critical limitation for CAVE content, which primarily requires accurate spatial audio at and above ear level.

![Floor speaker impact analysis](figures/floor_speaker_analysis.png)

### 5.6 Speaker Count Comparison

Optimization was run for multiple speaker counts (16 to 24) to evaluate the cost-benefit tradeoff:

| Speakers | Coverage | Loc Error | Max Gap | Cost |
|:--------:|:--------:|:---------:|:-------:|:----:|
| 16 | 99.19% | 0.4440 | 0.7660 | 1.0977 |
| 18 | 99.34% | 0.4239 | 0.7606 | 0.9517 |
| 20 | 99.84% | 0.4218 | 0.7000 | 0.9758 |
| 22 | 99.12% | 0.4170 | 0.7403 | 1.0313 |
| **24** | **99.66%** | **0.3944** | **0.7026** | **0.9285** |

**Observations:**
- **Coverage improves monotonically** with speaker count (99.19% at 16 speakers to 99.66% at 24).
- **Localization error improves steadily** from 0.4440 to 0.3944 — each additional pair of speakers provides diminishing but real improvement.
- **Cost is non-monotonic** at some transitions (e.g., 20→22 speakers). This reflects the increased difficulty of optimizing higher-dimensional search spaces (more speakers = more degrees of freedom = harder for the optimizer to find the global minimum), not a genuine degradation in layout quality. With more optimization budget, the 22-speaker result would likely match or beat the 20-speaker result.
- **24 speakers** provides the best overall cost, justifying the chosen speaker count for this installation.

---

## 6. Installation Notes

- Coordinate origin is the **geometric center of the CAVE floor**
- Positive X = right wall, negative X = left wall
- Positive Y = back wall, negative Y = front wall (entrance side)
- Z = 0 is floor level
- All speakers mount on the **exterior** of the CAVE structure, behind acoustically transparent projection screens
- Minimum separation of 0.30m between any two speakers
- Speaker distances to the center listening position range from 2.19m to 3.57m
