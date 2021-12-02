function [start_point,goal_point] = get_start_goal(ptCloud)
%GET_START_GOAL Gets the start and end points as selected by user input in a bird's-eye-view of a 3D point cloud
%   As point cloud is a BEV, point cloud must not have a ceiling
%{
    Inputs:
        ptCloud: Point Cloud of room with no ceiling plane

    Outputs:
        start_point: Initital point selection representing start, converted
                     to cell coordinates in 2D grid
        goal_point: Second point selection representing goal, converted
                     to cell coordinates in 2D grid
%}

    figure();
    pcshow(ptCloud);
    keydown = 2;

    % Get coordinates in pointcloud
    % Get first point by user input
    view(0,90); % Turn to BEV
    while keydown ~= 0
       disp('Click some where on the figure');
       keydown = waitforbuttonpress;
    end
    
    xyz1 = get(gca,'CurrentPoint');
    
    % Get a second point by user input
    keydown = 2;
    while keydown ~= 0
       disp('Click some where on the figure');
       keydown = waitforbuttonpress;
    end
    
    xyz2 = get(gca,'CurrentPoint');

    % Convert the selected points into cells in our 2D cell grid
    start_point = zeros(2);
    goal_point = zeros(2);
    
    x_lim = ptCloud.XLimits;
    y_lim = ptCloud.YLimits;
    
    goal_point(1) = (xyz1(1,1) - x_lim(1))/(x_lim(2) - x_lim(1))*128;
    goal_point(2) = (xyz2(1,1) - x_lim(1))/(x_lim(2) - x_lim(1))*128;
    start_point(1) = (xyz1(1,2) - y_lim(1))/(y_lim(2) - y_lim(1))*128;
    start_point(2) = (xyz2(1,2) - y_lim(1))/(y_lim(2) - y_lim(1))*128;
    
    % Get integer value to select exact cell in 2D Occupancy Grid
    start_point = int8(start_point);
    goal_point = int8(goal_point);

end