"""
Real 3D VBAP (Vector Base Amplitude Panning) implementation.

Uses scipy.spatial.ConvexHull on speaker unit directions to obtain the
spherical Delaunay triangulation. Each convex-hull facet defines a VBAP
speaker triplet. For any desired source direction, the enclosing triangle
is found and a 3x3 linear system is solved for the panning gains.
"""

import numpy as np
from scipy.spatial import ConvexHull
from typing import Tuple, Dict, Optional
from ..config import config

EPS = 1e-12


class VBAPRenderer:
    """
    Full 3D VBAP renderer for a given speaker layout and listener position.

    Constructs a convex hull of speaker unit directions (as seen from the
    listener), yielding a triangulation. For any desired source direction,
    finds the enclosing triangle and solves the 3x3 linear system for
    panning gains.
    """

    def __init__(self, speaker_positions: np.ndarray, listener_position: np.ndarray):
        self.speaker_positions = np.asarray(speaker_positions, dtype=float)
        self.listener_position = np.asarray(listener_position, dtype=float)
        self.n_speakers = len(speaker_positions)

        # Unit directions from listener to each speaker
        rel = self.speaker_positions - self.listener_position[None, :]
        dists = np.linalg.norm(rel, axis=1, keepdims=True)
        dists = np.maximum(dists, EPS)
        self.speaker_dirs = rel / dists  # (N, 3)
        self.speaker_dists = dists.ravel()  # (N,)

        # Triangulation data
        self.hull: Optional[ConvexHull] = None
        self.triangles: np.ndarray = np.empty((0, 3), dtype=int)
        self.triangle_inv = []  # list of (3,3) inverse matrices or None
        self.condition_numbers: np.ndarray = np.array([])
        self._build_triangulation()

    def _build_triangulation(self):
        """Build convex hull and precompute inverse matrices for each triangle."""
        if self.n_speakers < 4:
            return  # cannot form a 3D convex hull

        try:
            self.hull = ConvexHull(self.speaker_dirs)
        except Exception:
            return  # degenerate (e.g. coplanar speakers)

        self.triangles = self.hull.simplices  # (M, 3)
        n_tri = len(self.triangles)
        self.triangle_inv = [None] * n_tri
        self.condition_numbers = np.full(n_tri, np.inf)

        for t_idx, tri in enumerate(self.triangles):
            L = self.speaker_dirs[tri]  # (3, 3): rows are speaker directions
            try:
                cond = np.linalg.cond(L)
                # VBAP equation: d = L^T @ g  (desired dir = weighted sum of speaker dirs)
                # So g = (L^T)^(-1) @ d = L^(-T) @ d.
                # Store L^(-T) so that triangle_inv @ d gives correct gains.
                L_inv = np.linalg.inv(L).T
                self.triangle_inv[t_idx] = L_inv
                self.condition_numbers[t_idx] = cond
            except np.linalg.LinAlgError:
                pass  # keep None / inf

    def find_enclosing_triangle(
        self, direction: np.ndarray
    ) -> Tuple[int, Optional[np.ndarray]]:
        """
        Find which triangle encloses the given unit direction and compute gains.

        Returns (tri_idx, gains) where tri_idx=-1 and gains=None if no
        enclosing triangle is found (coverage gap).
        """
        d = direction / (np.linalg.norm(direction) + EPS)

        for t_idx, L_inv in enumerate(self.triangle_inv):
            if L_inv is None:
                continue
            g = L_inv @ d  # (3,) gains
            if np.all(g >= -EPS):
                return t_idx, g

        return -1, None

    def compute_gains(
        self, direction: np.ndarray, normalize: str = "energy"
    ) -> np.ndarray:
        """
        Compute full N-speaker gain vector for a desired direction.

        Parameters
        ----------
        direction : (3,) unit vector
        normalize : "energy" (sum(g^2)=1), "amplitude" (sum(g)=1), or "none"

        Returns
        -------
        gains : (N,) array. All zeros if no enclosing triangle (coverage gap).
        """
        gains = np.zeros(self.n_speakers)
        tri_idx, raw_gains = self.find_enclosing_triangle(direction)

        if tri_idx < 0 or raw_gains is None:
            return gains

        tri = self.triangles[tri_idx]
        raw_gains = np.maximum(raw_gains, 0.0)

        if normalize == "energy":
            norm = np.sqrt(np.sum(raw_gains**2) + EPS)
            raw_gains = raw_gains / norm
        elif normalize == "amplitude":
            norm = np.sum(raw_gains) + EPS
            raw_gains = raw_gains / norm

        gains[tri] = raw_gains
        return gains

    def compute_rv_re(self, gains: np.ndarray) -> Tuple[np.ndarray, np.ndarray]:
        """
        Compute velocity vector rV and energy vector rE from a gain vector.

        rV = sum(g_i * d_i) / sum(g_i)   — first-order localization cue
        rE = sum(g_i^2 * d_i) / sum(g_i^2) — high-frequency localization cue
        """
        g = np.asarray(gains)
        P = np.sum(g)
        E = np.sum(g**2)

        if P > EPS:
            rV = (g[:, None] * self.speaker_dirs).sum(axis=0) / P
        else:
            rV = np.zeros(3)

        if E > EPS:
            rE = ((g**2)[:, None] * self.speaker_dirs).sum(axis=0) / E
        else:
            rE = np.zeros(3)

        return rV, rE


def evaluate_vbap_quality(
    speaker_positions: np.ndarray,
    listener_position: np.ndarray,
    test_directions: np.ndarray,
) -> Dict[str, float]:
    """
    Evaluate comprehensive VBAP quality metrics for a speaker layout.

    Vectorized implementation — processes all test directions in batch
    using numpy operations instead of Python loops.

    Parameters
    ----------
    speaker_positions : (N, 3)
    listener_position : (3,)
    test_directions : (K, 3) unit vectors to test panning quality

    Returns
    -------
    dict with keys (all normalized to [0, 1]):
        coverage          : fraction of test directions with valid triangle
        mean_loc_error    : mean rV angular error, /pi
        mean_energy_err   : mean rE angular error, /pi
        mean_cond         : mean condition number of active triangles, squashed
        angular_uniformity: variance of triangle solid angles, squashed
        max_gap           : largest angular gap between hull-adjacent speakers, /pi
    """
    renderer = VBAPRenderer(speaker_positions, listener_position)

    n_test = len(test_directions)

    if len(renderer.triangles) == 0 or n_test == 0:
        return {
            "coverage": 0.0,
            "mean_loc_error": 1.0,
            "mean_energy_err": 1.0,
            "mean_rV_mag_error": 1.0,
            "mean_rE_mag_error": 1.0,
            "mean_cond": 1.0,
            "angular_uniformity": 1.0,
            "max_gap": 1.0,
        }

    # Normalize test directions: (K, 3)
    td_norms = np.linalg.norm(test_directions, axis=1, keepdims=True)
    td_norms = np.maximum(td_norms, EPS)
    dirs = test_directions / td_norms  # (K, 3)

    # Stack valid triangle inverse matrices: (M, 3, 3)
    valid_tri_mask = [inv is not None for inv in renderer.triangle_inv]
    valid_indices = [i for i, v in enumerate(valid_tri_mask) if v]
    if not valid_indices:
        return {
            "coverage": 0.0,
            "mean_loc_error": 1.0,
            "mean_energy_err": 1.0,
            "mean_rV_mag_error": 1.0,
            "mean_rE_mag_error": 1.0,
            "energy_var": 1.0,
            "mean_cond": 1.0,
            "angular_uniformity": 1.0,
            "max_gap": 1.0,
        }

    L_inv_stack = np.array([renderer.triangle_inv[i] for i in valid_indices])  # (M', 3, 3)
    cond_stack = renderer.condition_numbers[valid_indices]  # (M',)
    tri_stack = renderer.triangles[valid_indices]  # (M', 3)

    # Vectorized enclosing triangle search:
    # gains_all[m, :, k] = L_inv[m] @ dirs[k]  →  (M', 3, K)
    gains_all = np.einsum('mij,kj->mik', L_inv_stack, dirs)  # (M', 3, K)

    # For each direction, find first triangle where all gains >= -EPS
    valid_mask = np.all(gains_all >= -EPS, axis=1)  # (M', K) — bool

    # First valid triangle per direction (argmax on bool gives first True)
    any_valid = np.any(valid_mask, axis=0)  # (K,) — covered?
    covered_count = int(np.sum(any_valid))
    coverage = covered_count / n_test

    # For covered directions, get the enclosing triangle and gains
    # Use argmax to find first valid triangle index per direction
    first_valid_tri = np.argmax(valid_mask, axis=0)  # (M',) indices into valid_indices

    # Extract gains for the enclosing triangle: (K, 3)
    raw_gains_per_dir = gains_all[first_valid_tri, :, np.arange(n_test)]  # (K, 3)
    raw_gains_per_dir = np.maximum(raw_gains_per_dir, 0.0)

    # Energy normalization: g / sqrt(sum(g^2))
    gnorm = np.sqrt(np.sum(raw_gains_per_dir**2, axis=1, keepdims=True) + EPS)
    norm_gains = raw_gains_per_dir / gnorm  # (K, 3)

    # Build full gain vectors for rV/rE: (K, N)
    full_gains = np.zeros((n_test, renderer.n_speakers))
    tri_indices_per_dir = tri_stack[first_valid_tri]  # (K, 3)
    for k in range(n_test):
        if any_valid[k]:
            full_gains[k, tri_indices_per_dir[k]] = norm_gains[k]

    # rV = sum(g_i * d_i) / sum(g_i) for each direction
    g_sum = np.sum(full_gains, axis=1, keepdims=True)  # (K, 1)
    g_sum = np.maximum(g_sum, EPS)
    rV_all = (full_gains @ renderer.speaker_dirs) / g_sum  # (K, 3)

    # rE = sum(g_i^2 * d_i) / sum(g_i^2) for each direction
    g2 = full_gains**2
    g2_sum = np.sum(g2, axis=1, keepdims=True)  # (K, 1)
    g2_sum = np.maximum(g2_sum, EPS)
    rE_all = (g2 @ renderer.speaker_dirs) / g2_sum  # (K, 3)

    # Localization errors
    rV_norms = np.linalg.norm(rV_all, axis=1, keepdims=True)
    rV_norms = np.maximum(rV_norms, EPS)
    rV_hat = rV_all / rV_norms
    dot_v = np.clip(np.sum(dirs * rV_hat, axis=1), -1.0, 1.0)
    loc_errors = np.arccos(dot_v)  # (K,)
    loc_errors[~any_valid] = np.pi  # worst case for uncovered

    rE_norms = np.linalg.norm(rE_all, axis=1, keepdims=True)
    rE_norms = np.maximum(rE_norms, EPS)
    rE_hat = rE_all / rE_norms
    dot_e = np.clip(np.sum(dirs * rE_hat, axis=1), -1.0, 1.0)
    energy_errors = np.arccos(dot_e)  # (K,)
    energy_errors[~any_valid] = np.pi

    # rV/rE magnitude: ideal |rV|=1.0 means sharp localization,
    # |rV|<<1.0 means diffuse phantom source. Squared deviation from 1.0.
    rV_mag_raw = rV_norms.ravel()  # (K,)
    rV_mag_raw_copy = rV_mag_raw.copy()
    rV_mag_raw_copy[~any_valid] = 0.0
    rV_mag_errors = (1.0 - rV_mag_raw_copy) ** 2

    rE_mag_raw = rE_norms.ravel()  # (K,)
    rE_mag_raw_copy = rE_mag_raw.copy()
    rE_mag_raw_copy[~any_valid] = 0.0
    rE_mag_errors = (1.0 - rE_mag_raw_copy) ** 2

    # Direction importance weights: upper hemisphere (z >= 0) gets full weight,
    # lower hemisphere tapers via cos(elevation)^2. Prevents downward directions
    # (where no speakers exist) from inflating mean localization error.
    elevations = np.arcsin(np.clip(dirs[:, 2], -1.0, 1.0))  # (K,)
    dir_weights = np.ones(n_test)
    below_horizon = elevations < 0
    walls = (elevations > np.deg2rad(-30)) & (elevations < np.deg2rad(40))
    dir_weights[below_horizon] = np.cos(elevations[below_horizon]) ** 2
    dir_weights = dir_weights * (n_test / (np.sum(dir_weights) + EPS))

    mean_loc_error = float(np.average(loc_errors, weights=dir_weights) / np.pi)
    mean_energy_err = float(np.average(energy_errors, weights=dir_weights) / np.pi)
    mean_rV_mag_error = float(np.average(rV_mag_errors, weights=dir_weights))
    mean_rE_mag_error = float(np.average(rE_mag_errors, weights=dir_weights))

    energy_var = float(np.var(energy_errors[walls]))

    # Active triangle condition numbers (for covered directions)
    active_cond_indices = cond_stack[first_valid_tri[any_valid]]
    if len(active_cond_indices) > 0:
        mc = float(np.mean(active_cond_indices))
        mean_cond = mc / (1.0 + mc)
    else:
        mean_cond = 1.0

    # Angular uniformity: variance of triangle "sizes" (vectorized).
    # Uses |a . (b x c)| (scalar triple product) as a proxy for solid angle.
    # Not the true spherical solid angle, but monotonically related for
    # unit vectors, which is sufficient for ranking triangle uniformity.
    tri_dirs = renderer.speaker_dirs[renderer.triangles]  # (M, 3, 3)
    a, b, c = tri_dirs[:, 0], tri_dirs[:, 1], tri_dirs[:, 2]
    cross_bc = np.cross(b, c)  # (M, 3)
    tri_sizes = np.abs(np.sum(a * cross_bc, axis=1))  # (M,)
    sa_var = float(np.var(tri_sizes))
    angular_uniformity = sa_var / (1.0 + sa_var)

    # Max angular gap: largest angle between hull-adjacent speakers.
    # Compute both full-sphere and upper-hemisphere versions.
    # The upper version excludes edges whose midpoint is below min_gap_elevation,
    # so the optimizer doesn't waste effort on the floor gap.
    min_gap_el = np.radians(-30.0)  # ignore edges deep below horizon

    if renderer.hull is not None:
        edges = set()
        for tri in renderer.triangles:
            for i in range(3):
                edges.add((min(tri[i], tri[(i + 1) % 3]),
                           max(tri[i], tri[(i + 1) % 3])))
        edge_arr = np.array(list(edges))  # (E, 2)
        d0 = renderer.speaker_dirs[edge_arr[:, 0]]
        d1 = renderer.speaker_dirs[edge_arr[:, 1]]
        dots = np.clip(np.sum(d0 * d1, axis=1), -1.0, 1.0)
        edge_angles = np.arccos(dots)  # (E,)

        max_gap = float(np.max(edge_angles))
        max_gap_normalized = max_gap / np.pi

        # Upper-hemisphere max gap: filter edges by midpoint elevation
        midpoints = (d0 + d1)  # unnormalized midpoint direction
        mid_el = np.arcsin(np.clip(
            midpoints[:, 2] / (np.linalg.norm(midpoints, axis=1) + EPS),
            -1.0, 1.0))
        upper_edge_mask = mid_el >= min_gap_el
        if np.any(upper_edge_mask):
            upper_max_gap = float(np.max(edge_angles[upper_edge_mask]))
            upper_max_gap_normalized = upper_max_gap / np.pi
        else:
            upper_max_gap_normalized = max_gap_normalized
    else:
        max_gap_normalized = 1.0
        upper_max_gap_normalized = 1.0

    # Upper-hemisphere coverage: fraction of directions at elevation >= 0
    # that have a valid enclosing triangle. This is the coverage the room
    # CAN achieve (speakers are all above the listener).
    upper_mask = elevations >= 0
    if np.any(upper_mask):
        upper_coverage = float(np.sum(any_valid[upper_mask]) / np.sum(upper_mask))
    else:
        upper_coverage = coverage

    return {
        "coverage": coverage,
        "upper_coverage": upper_coverage,
        "mean_loc_error": mean_loc_error,
        "mean_energy_err": mean_energy_err,
        "mean_rV_mag_error": mean_rV_mag_error,
        "mean_rE_mag_error": mean_rE_mag_error,
        "energy_var": energy_var,
        "mean_cond": mean_cond,
        "angular_uniformity": angular_uniformity,
        "max_gap": max_gap_normalized,
        "upper_max_gap": upper_max_gap_normalized,
    }
