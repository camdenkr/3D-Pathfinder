function [z_lower_limit,z_upper_limit] = get_zlimits(ptCloud)
%GET_ZLIMITS Returns the upper and lower bound of the z axis of a 3D point
%              cloud
%   Inputs: 
%       ptCloud: point cloud as .ply
%   Outputs: 
%       z_lower_limit: lower z limit
%       z_upper_limit: upper z limit
    z_lower_limit = ptCloud.ZLimits(1,1);
    z_upper_limit = ptCloud.ZLimits(1,2);
    end

