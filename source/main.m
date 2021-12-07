% Clear outputs, variables, and figures
clc;
close all;
clear;

input = 'point_cloud.ply';
% If the input ptCloud has ceiling or not
hasCeiling = true;

% Read in a point cloud image
ptCloud = pcread(input);

%% Prune Point Cloud
% Display Input Point Cloud
subplot(2, 3, 1)
pcshow(ptCloud);
xlabel('X(m)');
ylabel('Y(m)');
zlabel('Z(m)');
title('Original Point Cloud');

% Remove ceiling
[topless_ptCloud, ceiling] = remove_ceiling(ptCloud, hasCeiling);
subplot(2, 3, 2)
pcshow(topless_ptCloud)
title('Point Cloud Without Ceiling')

% Remove floor
[remaining_ptCloud, floor] = remove_floor(topless_ptCloud);
subplot(2, 3, 3)
pcshow(remaining_ptCloud)
title('Remaining Point Cloud')

% Display ceiling
subplot(2, 3, 4)
pcshow(ceiling)
title('Ceiling')

% Display floor
subplot(2, 3, 5)
pcshow(floor)
title('Floor')

%% Generate 2D Occupancy Grid

% Fill in unscanned space with occupied cells
occ_grid = fill_unscanned(remaining_ptCloud, floor);

%% Generate Path

% Get user input start and end points
[start_point, goal_point] = get_start_goal(topless_ptCloud);

MAP = add_offset(occ_grid);

Connecting_Distance=8; %Avoid to high values Connecting_Distances for reasonable runtimes. 
StartX = start_point(1);
StartY = goal_point(1);
GoalRegister = int8(zeros(128,128));
GoalRegister(goal_point(2),start_point(2))=1;
% Find Optimat Path using A* pathfinder algorithm
OptimalPath = astar_pathfinder(StartX,StartY,MAP,GoalRegister,Connecting_Distance);

%% Plot Optimal Path

figure(2);
imagesc(occ_grid)
title("2D Occupancy Grid of Point Cloud")

if size(OptimalPath,2)>1
hold on
plot(OptimalPath(1,2),OptimalPath(1,1),'o','color','g')
plot(OptimalPath(end,2),OptimalPath(end,1),'o','color','r')
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
figure(3)
ptCloud_with_path = visualize_path(topless_ptCloud, XY_track);
pcshow(ptCloud_with_path)
view(0,90);
title("Point Cloud with Optimal Path")


