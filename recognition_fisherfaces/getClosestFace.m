function [imgNumber] = getClosestFace(imgWeights,allWeights)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
imgNumber=0;

distances = pdist2(imgWeights', allWeights', 'euclidean');
%0.3954 (when traning on only db1 and cl)

[minDist, index] = min(distances);

if minDist<462.6
    imgNumber= index;
end
end