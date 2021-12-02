function [occ_grid] = fill_unscanned(ptCloud, floor)
%{ 
FILL_UNSCANNED Fill in unscanned areas from point cloud and generates 2D
occupancy grid with areas unscanned as "occupied"

First, we take the 2d grid from the 3d point cloud without the ceiling
and the ground, and set the obstacles to be 1 while the others to be 0.
Second, we take the 2d grid from the 3d point cloud of the ground only,
and set the missing areas to be 1 while the others to be 0. Finally, we
take the logical 'or' of the two grid and it will come out that the
obstacles and the missing areas are both considered as 1 and the
remaining 0 areas will be the areas that we could generate the path.
%}

    % obstacles in grid
    indices = pcbin(ptCloud,[128 128 1]); 
    grid1 = cellfun(@(c) ~isempty(c),indices);
    
    % missing area in grid
    index = pcbin(floor,[128 128 1]); 
    grid2 = cellfun(@(c) isempty(c),index);

    % take the logical or of the two grids
    occ_grid = grid1 | grid2;

end

