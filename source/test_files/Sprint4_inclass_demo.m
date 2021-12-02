clc;
close all;
clear;

ptCloud = pcread('point_cloud.ply');
zlimit = ptCloud.ZLimits;
z1 = zlimit(1,1);
z2 = zlimit(1,2);

figure(1);
pcshow(ptCloud);
xlabel('X(m)');
ylabel('Y(m)');
zlabel('Z(m)');
title('Original Point Cloud');

maxDistance = 0.1;

referenceVector = [0,0,1];

maxAngularDistance = 5;

[model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,...
            maxDistance,referenceVector,maxAngularDistance);
plane1 = select(ptCloud,inlierIndices);
remainPtCloud1 = select(ptCloud,outlierIndices);

roi = [-inf,+inf;-inf,+inf;-inf,z1+0.5];
sampleIndices = findPointsInROI(remainPtCloud1,roi);

[model2,inlierIndices,outlierIndices] = pcfitplane(remainPtCloud1,...
            maxDistance,'SampleIndices',sampleIndices);
plane2 = select(remainPtCloud1,inlierIndices);
remainPtCloud = select(remainPtCloud1,outlierIndices);
[plane_bins,bins] = pcbin(remainPtCloud1,[128 128 1]);
figure(2);
pcshow(plane1);

figure(3);
pcshow(remainPtCloud1);

figure(4);
pcshow(plane2);

figure(5);
pcshow(remainPtCloud);
title('Remaining Point Cloud');

%%
indices = pcbin(remainPtCloud,[128 128 1]);

densitygrid = cellfun(@(c) ~isempty(c),indices);

figure;
imagesc(densitygrid);
%%
index = pcbin(plane2,[128 128 1]); % plane

grid = cellfun(@(c) isempty(c),index);

figure;
imagesc(grid);

%%
densityGrid = densitygrid | grid;

figure;
imagesc(densityGrid);



%Set up and get the cordinates of 2 points
[x,y] = ginput(2);
x = int8(x);
y = int8(y);

MAP = densityGrid;
OffsteMap = MAP;
[row,col] = find(MAP == 1);
Barrierpoint = [row,col];

[r,c] = size(Barrierpoint);
% Add Offset to the Barriers
for i = 1:r
       m = Barrierpoint(i,1);
       n = Barrierpoint(i,2);
       if (128 == n) && (128 == m) && (1 < n) && (1 < m)
           OffsteMap(m - 1:m,n - 1:n) = ones(2,2);
       elseif (128 > n) && (128 > m) && (1 == n) && (1 == m)
           OffsteMap(m:m + 1,n:n + 1) = ones(2,2);
       elseif (128 == n) || (128 == m) || (1 == n) || (1 == m)
           continue;
       elseif (1 == m) && (1 < n) && (128 > n)
           OffsteMap(m:m + 1,n - 1:n + 1) = ones(2,3);
       elseif (1 == n) && (1 < m) && (128 > m)
           OffsteMap(m - 1:m + 1,n:n + 1) = ones(3,2);
       elseif (128 == m) && (128 > n)
           OffsteMap(m - 1:m,n - 1:n + 1) = ones(2,3);
       elseif (128 == n) && (128 > m)
           OffsteMap(m - 1:m + 1,n - 1:n) = ones(3,2);
       elseif (128 == n) && (128 == m) && (1 == n) && (1 == m)
           OffsteMap(m - 1:m,n - 1:n + 1) = ones(2,2);
       elseif (1 == n) && (1 == m)
           OffsteMap(m:m + 1,n:n + 1) = ones(2,2);
       else
           OffsteMap(m - 1:m + 1,n - 1:n + 1) = ones(3,3);
       end
end


StartX = x(1);
StartY = y(1);

GoalRegister = int8(zeros(128,128));
GoalRegister(y(2),x(2))=1;

Connecting_Distance=8; %Avoid to high values Connecting_Distances for reasonable runtimes. 
% Running PathFinder
OptimalPath = ASTARPATH(StartX,StartY,OffsteMap,GoalRegister,Connecting_Distance)
% End. 
% Plot optimal path
if size(OptimalPath,2)>1
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


figure()

% For each bin in the optimal path, take all the points in the
% corresponding bin of the floor ponitcloud and turn them red
for i = 1:length(OptimalPath)
    bin = cell2mat(plane_bins(OptimalPath(i,1), OptimalPath(i,2)));
    for j = 1:length(bin)
       remainPtCloud1.Color(bin(j),:) = [255,0,0];
       remainPtCloud1.Color(bin(j)+1,:) = [255,0,0];
       remainPtCloud1.Color(bin(j)-1,:) = [255,0,0];
    end
end
pcshow(remainPtCloud1);


