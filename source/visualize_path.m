function [ptCloud_with_path] = visualize_path(ptCloud,path)
%VISUALIZE_PATH Overlays path onto pointcloud on floor
%   Input: 
%       ptCloud: Point cloud with floor plane, and no ceiling plane
%       path: 2D points of path
%   Output:
%       ptCloud_with_path: point cloud with floor points along path colored


% For each bin in the optimal path, take all the points in the
% corresponding bin of the floor ponitcloud and turn them red

    [plane_bins,~] = pcbin(ptCloud,[128 128 1]);
    for i = 1:length(path)
        bin = cell2mat(plane_bins(path(i,1), path(i,2)));
        for j = 1:length(bin)
           ptCloud.Color(bin(j),:) = [255,0,0];
           ptCloud.Color(bin(j)+1,:) = [255,0,0];
           ptCloud.Color(bin(j)-1,:) = [255,0,0];
        end
    end
    ptCloud_with_path = ptCloud;
end

