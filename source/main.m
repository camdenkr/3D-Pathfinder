% Clear outputs, variables, and figures
clc;
close all;
clear;

input = 'point_cloud.ply';


% Read in a point cloud image
ptCloud = pcread(input);

%% Prune Point Cloud
% Display Input Point Cloud
figure();
pcshow(ptCloud);
xlabel('X(m)');
ylabel('Y(m)');
zlabel('Z(m)');
title('Original Point Cloud');

% Remove ceiling
[topless_ptCloud, ceiling] = remove_ceiling(ptCloud);
figure()
pcshow(topless_ptCloud)
title('Point Cloud Without Ceiling')

% Remove floor
[remaining_ptCloud, floor] = remove_floor(topless_ptCloud);
figure()
pcshow(remaining_ptCloud)
title('Remaining Point Cloud')

figure()
pcshow(ceiling)
title('Ceiling')

figure()
pcshow(floor)
title('Floor')

%% Generate 2D Occupancy Grid

% Fill in unscanned space with occupied cells
occ_grid = fill_unscanned(remaining_ptCloud, floor);

figure()
imagesc(occ_grid)
title("2D Occupancy Grid of Point Cloud")

%% Generate Path

% Get user input start and end points
[start_point, goal_point] = get_start_goal(topless_ptCloud);

% [start_cell,goal_cell] = ginput(2);
% % Round to get exact cell coordinates
% start_cell = int8(start_cell);
% goal_cell = int8(goal_cell);

MAP = add_offset(occ_grid);

Connecting_Distance=8; %Avoid to high values Connecting_Distances for reasonable runtimes. 
StartX = start_point(1);
StartY = goal_point(1);
GoalRegister = int8(zeros(128,128));
GoalRegister(start_point(2),goal_point(2))=1;
% Find Optimat Path using A* pathfinder algorithm
OptimalPath = astar_pathfinder(StartX,StartY,MAP,GoalRegister,Connecting_Distance);

%% Plot Optimal Path
if size(OptimalPath,2)>1
hold on
plot(OptimalPath(1,2),OptimalPath(1,1),'o','color','k')
plot(OptimalPath(end,2),OptimalPath(end,1),'o','color','b')
plot(OptimalPath(:,2),OptimalPath(:,1),'r')
legend('Goal','Start','Path')
else 
     pause(1);
 h=msgbox('Sorry, No path exists to the Target!','warn');
 uiwait(h,5);
end
hold off

%% Visualize Path
XY_track = supplement_path(OptimalPath);
figure()
ptCloud_with_path = visualize_path(topless_ptCloud, XY_track);
pcshow(ptCloud_with_path)
title("Point Cloud with Optimal Path")


