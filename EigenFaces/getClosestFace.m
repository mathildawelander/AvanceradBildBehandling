function [imgNumber] = getClosestFace(imgWeights,allWeights)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
imgNumber=0;

distances = pdist2(imgWeights', allWeights', 'euclidean');
%0.6878,
%0.7102
%0.4626
%0.502

[minDist, index] = min(distances);
if minDist<462.6
    imgNumber= index;

else 
    imgNumber=0;
end

end