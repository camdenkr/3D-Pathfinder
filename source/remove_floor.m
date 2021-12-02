function [bottomless_PtCloud,floor] = remove_floor(ptCloud)
%REMOVE_FLOOR removes the floor plane of a point cloud
%   Inputs: 
%       ptCloud: ptCloud to remove the floor
%   Outputs: 
%       bottomless_PtCloud: point cloud without the floor points,
%       floor: floor points
    
    maxDistance = 0.1;
    [z_lower_limit,~] = get_zlimits(ptCloud);
    roi = [-inf,+inf;-inf,+inf;-inf,z_lower_limit+0.5];
    sampleIndices = findPointsInROI(ptCloud,roi);
    [~,inlierIndices,outlierIndices] = pcfitplane(ptCloud,...
                maxDistance,'SampleIndices',sampleIndices);
    floor = select(ptCloud,inlierIndices);
    bottomless_PtCloud = select(ptCloud,outlierIndices);
end

