function [remainPtCloud, ceiling] = remove_ceiling(ptCloud)
%REMOVE_CEILING removes the ceiling plane of a point cloud
%   Inputs: 
%       ptCloud: point cloud to remove the ceiling
%   Outputs: 
%       bottomless_PtCloud: point cloud without the ceiling points,
%       floor: extract ceiling points
    maxDistance = 0.1;

    referenceVector = [0,0,1];

    maxAngularDistance = 5;

    [~,inlierIndices,outlierIndices] = pcfitplane(ptCloud,...
                maxDistance,referenceVector,maxAngularDistance);
    ceiling = select(ptCloud,inlierIndices);
    remainPtCloud = select(ptCloud,outlierIndices);
end

