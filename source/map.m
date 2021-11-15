clc;
clear;

ptCloud = pcread('./data/trashcan.ply');

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
ax = pcshow(remainPtCloud);
title('Remaining Point Cloud');

indices = pcbin(remainPtCloud,[128 128 128]);

occupancyGrid = cellfun(@(c) ~isempty(c), indices);

ViewPnl = uipanel(figure);
volshow(occupancyGrid, 'Parent' ,ViewPnl);

indices = pcbin(remainPtCloud,[128 128 1]);

densityGrid = cellfun(@(c) ~isempty(c),indices);

figure;
imagesc(densityGrid);

[x,y] = ginput(2);
x = int8(x);
y = int8(y);

MAP = densityGrid;
StartX = x(1);
StartY = y(1);

GoalRegister = int8(zeros(128,128));
GoalRegister(y(2),x(2))=1; %Changee coordinates off x and y

Connecting_Distance=8; %Avoid to high values Connecting_Distances for reasonable runtimes. 
% Running PathFinder
OptimalPath = ASTARPATH(StartX,StartY,MAP,GoalRegister,Connecting_Distance)
% End. 
if size(OptimalPath,2)>1
figure(10)
imagesc((MAP))
    colormap(flipud(gray));
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

