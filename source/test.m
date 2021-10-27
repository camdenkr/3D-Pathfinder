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

figure(2);
pcshow(plane1);
title('Ground');

figure(3);
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


