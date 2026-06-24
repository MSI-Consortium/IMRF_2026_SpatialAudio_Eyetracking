from ..config import config
from .box import Box


def define_spaces():
    cave_dims = config.SPACE_DEFINITION["cave_dims"]
    wall_offsets = config.SPACE_DEFINITION["wall_offsets"]
    ceiling_offsets = config.SPACE_DEFINITION["ceiling_offsets"]

    
    wall_x = [-cave_dims["width"] / 2, cave_dims["width"] / 2]
    wall_y = [-cave_dims["depth"] / 2, cave_dims["depth"] / 2]
    wall_z = [0.2, cave_dims["height"]]


    allowed_wall_z = [wall_z[0], wall_z[1] + wall_offsets["max"]]


    ceiling_x = [wall_x[0] - wall_offsets["max"], wall_x[1] + wall_offsets["max"]]
    ceiling_y = [wall_y[0] - wall_offsets["max"], wall_y[1] + wall_offsets["max"]]
    ceiling_z = [wall_z[1] +  wall_offsets["min"], wall_z[1] + wall_offsets["max"]]
    allowed_ceiling = Box(min_corner=(ceiling_x[0], ceiling_y[0], ceiling_z[0]),
                          max_corner=(ceiling_x[1], ceiling_y[1], ceiling_z[1]),
                          label='Ceiling')

    front_x = ceiling_x
    front_y = [wall_y[0] - wall_offsets["max"], wall_y[0] - wall_offsets["min"]]
    front_z = allowed_wall_z
    allowed_front = Box(min_corner=(front_x[0], front_y[0], front_z[0]),
                        max_corner=(front_x[1], front_y[1], front_z[1]),
                        label='Front')

    back_x = ceiling_x
    back_y = [wall_y[1] + wall_offsets["min"], wall_y[1] + wall_offsets["max"]]
    back_z = allowed_wall_z
    allowed_back = Box(min_corner=(back_x[0], back_y[0], back_z[0]),
                       max_corner=(back_x[1], back_y[1], back_z[1]),
                       label='Back')

    left_x = [wall_x[0] - wall_offsets["max"], wall_x[0] - wall_offsets["min"]]
    left_y = ceiling_y
    left_z = allowed_wall_z
    allowed_left = Box(min_corner=(left_x[0], left_y[0], left_z[0]),
                       max_corner=(left_x[1], left_y[1], left_z[1]),
                       label='Left')

    right_x = [wall_x[1] + wall_offsets["min"], wall_x[1] + wall_offsets["max"]]
    right_y = ceiling_y
    right_z = allowed_wall_z
    allowed_right = Box(min_corner=(right_x[0], right_y[0], right_z[0]),
                        max_corner=(right_x[1], right_y[1], right_z[1]),
                        label='Right')

    forbidden_spaces = []

    if "entrance_space" in config.SPACE_DEFINITION:
        entrance_space = config.SPACE_DEFINITION["entrance_space"]


        # Entrance space (solid, forbidden area)
        entrance_x = [-entrance_space["width"] / 2, entrance_space["width"] / 2]
        entrance_y = [-cave_dims["depth"] / 2 - wall_offsets["max"], -cave_dims["depth"] / 2 - wall_offsets["min"]]
        entrance_z = [0, entrance_space["height"]]
        forbidden_entrance = Box(min_corner=(entrance_x[0], entrance_y[0], entrance_z[0]),
                                 max_corner=(entrance_x[1], entrance_y[1], entrance_z[1]),
                                 label='Entrance')
        forbidden_spaces.append(forbidden_entrance)

    if "projector_space" in config.SPACE_DEFINITION:
        projector_space = config.SPACE_DEFINITION["projector_space"]
        # Projector space (solid, forbidden area)
        projector_x = [-projector_space["width"] / 2, projector_space["width"] / 2]
        projector_y = [-projector_space["depth"] / 2, projector_space["depth"] / 2]
        projector_z = [cave_dims["height"] + ceiling_offsets["min"], cave_dims["height"] + ceiling_offsets["max"]]
        forbidden_projector = Box(min_corner=(projector_x[0], projector_y[0], projector_z[0]),
                                  max_corner=(projector_x[1], projector_y[1], projector_z[1]),
                                  label='Projector')
        forbidden_spaces.append(forbidden_projector)

    if "projector_spaces" in config.SPACE_DEFINITION.keys():
        for key, value in config.SPACE_DEFINITION["projector_spaces"].items():
            xmin = value["x_offset"]
            xmax = value["x_offset"] + value["width"]
            ymin = wall_y[0] + value["y_min"]
            ymax = wall_y[0] + value["y_min"] + value["depth"]
            zmin = ceiling_z[0]
            zmax = ceiling_z[1]
            forbidden_spaces.append(Box(min_corner=(xmin, ymin, zmin), max_corner=(xmax, ymax, zmax), label=key))

    allowed_spaces = [allowed_ceiling, allowed_front, allowed_back, allowed_left, allowed_right]

    return allowed_spaces, forbidden_spaces
