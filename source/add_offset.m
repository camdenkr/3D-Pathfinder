function [OffsetMap] = add_offset(MAP)
%{ 
ADD_OFFFSET Adds offset to barriers in occupancy grid
   By adding an offset to barriers in the occupancy grid, there will be
   more space in between a path that is generated on the grid. This allows
   for realistic navigation paths and prevents paths going throgh cell
   corners.
    
    Input: MAP: 2D Occupancy grid of point cloud
    Output: Map with offset added to barriers

%}

    [row,col] = find(MAP == 1);
    Barrierpoint = [row,col];
    [r,~] = size(Barrierpoint);
    for i = 1:r
           m = Barrierpoint(i,1);
           n = Barrierpoint(i,2);
           if (128 == n) && (128 == m) && (1 < n) && (1 < m)
               OffsetMap(m - 1:m,n - 1:n) = ones(2,2);
           elseif (128 > n) && (128 > m) && (1 == n) && (1 == m)
               OffsetMap(m:m + 1,n:n + 1) = ones(2,2);
           elseif (128 == n) || (128 == m) || (1 == n) || (1 == m)
               continue;
           elseif (1 == m) && (1 < n) && (128 > n)
               OffsetMap(m:m + 1,n - 1:n + 1) = ones(2,3);
           elseif (1 == n) && (1 < m) && (128 > m)
               OffsetMap(m - 1:m + 1,n:n + 1) = ones(3,2);
           elseif (128 == m) && (128 > n)
               OffsetMap(m - 1:m,n - 1:n + 1) = ones(2,3);
           elseif (128 == n) && (128 > m)
               OffsetMap(m - 1:m + 1,n - 1:n) = ones(3,2);
           elseif (128 == n) && (128 == m) && (1 == n) && (1 == m)
               OffsetMap(m - 1:m,n - 1:n + 1) = ones(2,2);
           elseif (1 == n) && (1 == m)
               OffsetMap(m:m + 1,n:n + 1) = ones(2,2);
           else
               OffsetMap(m - 1:m + 1,n - 1:n + 1) = ones(3,3);
           end
    end
end

