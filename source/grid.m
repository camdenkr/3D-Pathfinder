clc;
clear;

ptCloud = pcread('trashcan.ply');

figure(1);
pcshow(ptCloud);
xlabel('X(m)');
ylabel('Y(m)');
zlabel('Z(m)');
title('Original Point Cloud');

maxDistance = 0.02;

referenceVector = [0,0,1];

maxAngularDistance = 5;

[model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,...
            maxDistance,referenceVector,maxAngularDistance);
plane1 = select(ptCloud,inlierIndices);
remainPtCloud = select(ptCloud,outlierIndices);

roi = [-inf,inf;-inf,inf;-inf,0.4];
sampleIndices = findPointsInROI(remainPtCloud,roi);

[model2,inlierIndices,outlierIndices] = pcfitplane(remainPtCloud,...
            maxDistance,'SampleIndices',sampleIndices);
plane2 = select(remainPtCloud,inlierIndices);
remainPtCloud = select(remainPtCloud,outlierIndices);

figure(2);
pcshow(plane1);
title('Top');

figure(3);
pcshow(plane2);
title('Ground');

figure(4);
pcshow(remainPtCloud);
title('Remaining Point Cloud');

indices = pcbin(remainPtCloud,[128 128 128]);

occupancyGrid = cellfun(@(c) ~isempty(c), indices);

ViewPnl = uipanel(figure);
volshow(occupancyGrid, 'Parent' ,ViewPnl);

indices = pcbin(remainPtCloud,[128 128 1]);

densityGrid = cellfun(@(c) ~isempty(c),indices);

figure;
imagesc(densityGrid);


