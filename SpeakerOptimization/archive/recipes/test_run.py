from matplotlib import pyplot as plt
from ..geometry import define_spaces
from ..geometry.geometry_utils import fibonacci_sphere, xyz_to_azel
from ..utils import plot_layout
from ..config import config
from ..optimization import search


def main():
    allowed_boxes, forbidden_boxes = define_spaces.define_spaces()
    #plot_layout.plot_room_layout(allowed_boxes, forbidden_boxes, config.LISTENER_POSITIONS)

    test_positions = fibonacci_sphere(config.TEST_DIRECTIONS, config.LISTENER_POSITIONS[0])


    # fig = plt.figure(figsize=(12, 10))
    # ax = fig.add_subplot(111, projection='3d')
    # ax.scatter(test_positions[:, 0], test_positions[:, 1], test_positions[:, 2],
    #            marker='o', s=50)
    # # Set labels and title
    # ax.set_xlabel("X")
    # ax.set_ylabel("Y")
    # ax.set_zlabel("Z")
    # ax.set_title("Test Directions")
    # plt.show()

    search.local_search_optimize_layout(allowed_boxes, forbidden_boxes, test_positions)




if __name__ == "__main__":
    main()