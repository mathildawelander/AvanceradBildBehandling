function [m] = avarageFaceVector(data)
% This function takes an array of data as input and returns the mean value as output
% Input: data - an array of numbers
% Output: m - the mean value of data

 data = double(data);
 m = mean(data,2);
 
end