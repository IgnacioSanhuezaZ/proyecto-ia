function [points, parameters_out] = rand_points(k)
%RAND_POINTS initalize n real parameters for a polynom in R^2
% n = cuantity of points, k = grade of polynom
y = rand(k, 1);
parameters_out = sin(2*pi*y);
points = get_polynom_points(parameters_out);
end

function [out] = get_polynom_points(parameters)
        %GET_POLYNOM_POINTS get point in polinom
        % n = cuantity of points, parameters = parameters of function
        % x = rand(n, 1).*100;
        % sen(x)
        y = 0:0.1:1;
        x = sin(2*pi*y);
        points = arrayfun(@(f) [f polyval(parameters, f)], x, 'UniformOutput', false);
        out = gpuArray(repmat(cell2mat([points(:)]), 1));
end