function [m] = avarageFaceVector(data)
% This function takes an array of data as input and returns the mean value as output
% Input: data - an array of numbers
% Output: m - the mean value of data

% Check if the input is valid
if isempty(data) || ~isnumeric(data)
    error('Invalid input. Data must be a non-empty numeric array.')
end

% Calculate the sum and the length of data
sum = zeros(105000,1, 'uint64');
len = 0;

for x = data
    sum = sum + x;
    len = len + 1;
end

% Calculate the mean value
m = sum / len;
end