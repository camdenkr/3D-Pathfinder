% Generates a 3D occupancy map using Navigation Toolbox

ptCloud = pcread('./data/trashcan.ply');
map3D = occupancyMap3D(10);
pose = [ 0 0 0 1 0 0 0];

points = ptCloud.Location;
maxRange = 5;
insertPointCloud(map3D,pose,points,maxRange)
show(map3D)