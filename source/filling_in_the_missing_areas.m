% First, we take the 2d grid from the 3d point cloud without the ceiling
% and the ground, and set the obstacles to be 1 while the others to be 0.
% Second, we take the 2d grid from the 3d point cloud of the ground only,
% and set the missing areas to be 1 while the others to be 0. Finally, we
% take the logical 'or' of the two grid and it will come out that the
% obstacles and the missing areas are both considered as 1 and the
% remaining 0 areas will be the areas that we could generate the path.

%------------------------------------------------------------------------
% obstacles in grid

indices = pcbin(remainPtCloud,[128 128 1]); 
% 'remainPtCloud' is the 3d pointcloud without the ceiling and the ground

grid1 = cellfun(@(c) ~isempty(c),indices);

figure;
imagesc(grid1);

%------------------------------------------------------------------------
% missing area in grid

index = pcbin(plane_ground,[128 128 1]); 
% 'plane_ground' is the 3d pointcloud of the ground only

grid2 = cellfun(@(c) isempty(c),index);

figure;
imagesc(grid2);

%------------------------------------------------------------------------
% take the logical or of the two grid

Final_grid = grid1 | grid2;

figure;
imagesc(Final_grid);
