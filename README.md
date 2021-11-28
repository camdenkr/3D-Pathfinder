# 3D-Pathfinder

### MVP
** **
Provided a point cloud representation of a room (generated using a LiDAR scanner), our system may take in this point cloud and allow a user to select a start and end point. Our pathfinder will then automatically generate a path along the floor of the room, avoiding any real-world obstacles that may block the user's path. The user will then be provided with a visual representation of the path in 3D space utilizing the originally provided point cloud.  

### Current Architecture
- Point Cloud generation as input
- Points in point cloud are binned together in 3D space creating a 3D occupaancy grid
- 2D occupancy is then generating using bins, creating a grid of 0s and 1s indicating whether a given area can be traverrsed.
- User selects start and end point
- A* pathfinder is used to find a path along the 2D spaces that avoids occupied bins.
- If a path is found, the 3D representation of the room is modified to show the path, coloring sets of points that are included in the path, and is presented back to the user.

### Limitations
** **
- Areas missed by an incomplete scan are assummed to be "obstacle areas." Therefore a path will not be generated along areas missed by a LiDAR scan. 
- Obstacles that may be stepped over are assumed to be completely blocking, therefore no path will made along an area that includes any obstacles above floor height whatsoever, regardless of how low they are. 
- Due in part to the above limitation, scan are limited to single floor spaces, and therefore cannot traverse stairs
- As points are binned together, some resolution is lost when generating the path, and therefore the path loses some degree of accuracy when represented visually.

### Repo organization
Currently all soource code to process point clouds is located in /source. Our main two files that are included in our current architecture are **map.m** which starts the program, and **ASTARPATH.m** which generates the 2D path, slightly modified from [Einar Ueland's code](https://github.com/EinarUeland/Astar-Algorithm).
