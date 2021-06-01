function [out] = in_function(parameters, points)
%IN_FUNCTION Get distance between function and points
%   parameters = array of coeficients, points = array of points (x,y)
    arr = [];
    for i = 1:length(points)
        val = polyval(parameters, points(i, 1));
        if val == 0 && points(i, 2) ~= 0
            val = 100000000;
        end
        arr(i) = mse(val - points(i, 2)); 
    end
    out = mean(arr);
end

