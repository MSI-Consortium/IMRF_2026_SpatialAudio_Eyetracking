import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits.mplot3d.art3d import Poly3DCollection


def plot_room_layout(feasible_boxes, forbidden_boxes, listener_positions, speaker_positions=None):
    """
    Plots the room layout with feasible boxes, forbidden boxes, listener positions, and speaker positions in 3D.

    Parameters:
    - feasible_boxes: List of Box objects representing allowed regions.
    - forbidden_boxes: List of Box objects representing forbidden regions.
    - listener_positions: List or array of 3D coordinates representing listener positions.
    - speaker_positions: Optional, list or array of 3D coordinates representing speaker positions.

    Returns:
    - A matplotlib figure showing the layout in 3D.
    """
    fig = plt.figure(figsize=(10, 8))
    ax = fig.add_subplot(111, projection='3d')

    # Plot feasible boxes (green)
    for box in feasible_boxes:
        plot_box_in_3d(ax, box, color='green', alpha=0.3)

    # Plot forbidden boxes (red)
    for box in forbidden_boxes:
        plot_box_in_3d(ax, box, color='red', alpha=0.3)

    # Plot listener positions (stars)
    ax.scatter(listener_positions[:, 0], listener_positions[:, 1], listener_positions[:, 2],
               color='yellow', marker='*', s=100, label="Listener", edgecolor='black')

    # Plot speaker positions (dots)
    if speaker_positions is not None:
        ax.scatter(speaker_positions[:, 0], speaker_positions[:, 1], speaker_positions[:, 2],
                   color='black', marker='o', s=50, label="Speakers")

    # Set labels and title
    ax.set_xlabel("X")
    ax.set_ylabel("Y")
    ax.set_zlabel("Z")
    ax.set_title("Room Layout: Feasible and Forbidden Regions with Listener and Speakers")

    # Show the plot
    plt.legend()
    plt.show()


def plot_box_in_3d(ax, box, color, alpha=0.3):
    """
    Plot a 3D box using Poly3DCollection. Each box is represented as a cuboid.

    Parameters:
    - ax: Matplotlib Axes3D object.
    - box: A Box object (min_corner, max_corner) defining the box.
    - color: Color for the box (string or tuple).
    - alpha: Transparency value for the box (0 = fully transparent, 1 = fully opaque).
    """
    # Define the vertices of the box
    corners = np.array([
        [box.min_corner[0], box.min_corner[1], box.min_corner[2]],
        [box.max_corner[0], box.min_corner[1], box.min_corner[2]],
        [box.max_corner[0], box.max_corner[1], box.min_corner[2]],
        [box.min_corner[0], box.max_corner[1], box.min_corner[2]],
        [box.min_corner[0], box.min_corner[1], box.max_corner[2]],
        [box.max_corner[0], box.min_corner[1], box.max_corner[2]],
        [box.max_corner[0], box.max_corner[1], box.max_corner[2]],
        [box.min_corner[0], box.max_corner[1], box.max_corner[2]],
    ])

    # Define the 6 faces of the box (each face is a quadrilateral)
    faces = [
        [corners[0], corners[1], corners[5], corners[4]],  # bottom
        [corners[7], corners[6], corners[2], corners[3]],  # top
        [corners[0], corners[4], corners[7], corners[3]],  # front
        [corners[1], corners[5], corners[6], corners[2]],  # back
        [corners[0], corners[1], corners[2], corners[3]],  # left
        [corners[4], corners[5], corners[6], corners[7]],  # right
    ]

    # Create a Poly3DCollection for the faces and add it to the plot
    poly3d = Poly3DCollection(faces, facecolors=color, linewidths=1, edgecolors='g', alpha=alpha)
    ax.add_collection3d(poly3d)