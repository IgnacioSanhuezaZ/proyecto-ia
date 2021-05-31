function [points, parameters_out] = rand_points(n, k)
%RAND_POINTS initalize n real parameters for a polynom in R^2
% n = cuantity of points, k = grade of polynom
parameters_out = rand(k,1).*100;
points = get_polynom_points(n, parameters_out);
end

function [out] = get_polynom_points(n, parameters)
        %GET_POLYNOM_POINTS get point in polinom
        % n = cuantity of points, parameters = parameters of function
        x = rand(n, 1).*100;
        points = arrayfun(@(f) [f polyval(parameters, f)], x, 'UniformOutput', false);
        out = gpuArray(repmat(cell2mat([points(:)]), 1));
end