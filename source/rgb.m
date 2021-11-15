clc;
clear;
ptCloud = pcread('./data/trashcan.ply');
maxDistance = 0.02;

referenceVector = [0,0,1];

maxAngularDistance = 5;
% 
% [model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,...
%             maxDistance,referenceVector,maxAngularDistance);
% plane1 = select(ptCloud,inlierIndices);
% remainPtCloud = select(ptCloud,outlierIndices);
% bep = birdsEyePlot('Xlimits',[-2,2],'YLimits',[-1 1]);
% plotter = pointCloudPlotter(bep);
% plotPointCloud(plotter,remainPtCloud);

