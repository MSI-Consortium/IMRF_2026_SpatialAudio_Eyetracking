# AprilTag PNGs

Put the Unity-rendered surface mapping tags here:

- `tag36h11_10.png`
- `tag36h11_11.png`
- `tag36h11_12.png`
- `tag36h11_13.png`
- `tag36h11_14.png`
- `tag36h11_15.png`
- `tag36h11_16.png`
- `tag36h11_17.png`

The runtime overlay loads these files from `Resources/AprilTags` and places
them around the screen using the same 8-marker order as the Python surface
mapping tab: BL, ML, TL, TC, TR, MR, BR, BC.

The checked-in PNGs were downloaded from the official AprilRobotics
`apriltag-imgs` repository, `tag36h11/tag36_11_00010.png` through
`tag36_11_00017.png`. In the Python Surface Mapping tab, use
`8-marker perimeter (IDs 10-17)` with the same monitor width and viewing
distance values as the Unity overlay.
