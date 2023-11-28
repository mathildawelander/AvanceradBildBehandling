function [A] = subtractMean(data, my)
% Subtract the mean vector (my) from each vector in data

% Initialize A with zeros
A = zeros(size(data));

% Subtract the mean vector from each vector in data
for i = 1:size(data, 2)
    A(:, i) = double(data(:, i)) - my;
end

end
