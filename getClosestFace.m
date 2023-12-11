function [imgNumber] = getClosestFace(imgWeights,allWeights)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
imgNumber=0;

distances = pdist2(imgWeights', allWeights', 'euclidean');

[distance, index] = min(distances);
if distance < 720
    imgNumber = index;
end