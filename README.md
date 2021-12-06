# 3D-Pathfinder

### MVP
** **
Provided a point cloud representation of a room (generated using a LiDAR scanner), our system may take in this point cloud and allow a user to select a start and end point. Our pathfinder will then automatically generate a path along the floor of the room, avoiding any real-world obstacles that may block the user's path. The user will then be provided with a visual representation of the path in 3D space utilizing the originally provided point cloud.  

### Current Architecture
- Point Cloud generation as input
- Points in point cloud are binned together in 3D space creating a 3D occupaancy grid
- 2D occupancy is then generating using bins, creating a grid of 0s and 1s indicating whether a given area can be traversed.
- User selects start and end point
- A* pathfinder is used to find a path along the 2D spaces that avoids occupied bins.
- If a path is found, the 3D representation of the room is modified to show the path, coloring sets of points that are included in the path, and is presented back to the user.

### Astar Path Generation
** **
Credit to: [Einar Ueland](https://github.com/EinarUeland/Astar-Algorithm).

A* Search Algorithm picks the node according to a value - ‘f’ at each step which is a parameter equal to the sum of two other parameters – ‘g’ and ‘h’. At each step it picks the node/cell having the lowest ‘f’, and process that node/cell.

g = the movement cost to move from the starting point to a given square on the grid, following the path generated to get there. 

h = the estimated movement cost to move from that given square on the grid to the final destination. 

In our program we use diagonal distance to initialize heuristic and use F=G+H to evaluate the cost of the path, smaller the F is, lower the cost.
We also create two lists – Open List and Closed List. Open List is used to store the points which could be reached in next step, while Closed List is used to store the points that have already used before with lowest cost. Every time we will choose the lowest cost point in Open List as parent point and if the point has already existed in Close List or it is invalid(barrier), we will ignore it and continue. Once the ending point is existed in Open List, it will trace back all parent points to generate the shortest path.


### Limitations
** **
- Areas missed by an incomplete scan are assummed to be "obstacle areas." Therefore a path will not be generated along areas missed by a LiDAR scan. 
- Obstacles that may be stepped over are assumed to be completely blocking, therefore no path will made along an area that includes any obstacles above floor height whatsoever, regardless of how low they are. 
- Due in part to the above limitation, scan are limited to single floor spaces, and therefore cannot traverse stairs
- As points are binned together, some resolution is lost when generating the path, and therefore the path loses some degree of accuracy when represented visually.

### Repo organization
** **
Currently all code can be found in /source, with all required files to run the code, except the input point cloud.

The code can be run simply by running main.m with a *.ply file in the same directory. The name of the file must be modified in main.m to take in the correct point cloud, with the default being "point_cloud.ply". There is also a boolean value has_ceiling that must be set to true (as it is by default) is the scan of the room contains a ceiling.

Toolboxes Required For Running:
- Computer Vision Toolbox
