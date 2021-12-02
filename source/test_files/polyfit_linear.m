function [XY_track] = polyfit_linear(OptimalPath)
% OptimalPath (Y,X)
% Find all the points on the Optimalpath
XY_track = [];
for i = 1:size(OptimalPath)-1
    buffer = [];
    y1 = OptimalPath(i,1);
    y2 = OptimalPath(i+1, 1);
    x1 = OptimalPath(i,2);
    x2 = OptimalPath(i+1, 2);
    if abs(x1-x2) == 1 % x value only 1 away, increment y
    coefficients = polyfit([y1,y2], [x1,x2],1);
    y_track = (linspace(y1,y2,abs(y2-y1)+1));
    x_track = polyval(coefficients,y_track);
    else % else, increment x
    coefficients = polyfit([x1, x2], [y1, y2], 1);
    x_track = (linspace(x1,x2,abs(x2-x1)+1));
    y_track = (polyval(coefficients,x_track));
    end
    buffer(:,1) = y_track';
    buffer(:,2) = x_track';
    XY_track = cat(1,XY_track,buffer);
end
XY_track = round(XY_track);