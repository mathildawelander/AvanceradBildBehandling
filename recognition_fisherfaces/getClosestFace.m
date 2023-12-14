function [imgNumber] = getClosestFace(imgWeights,allWeights)

imgNumber=0;

distances = pdist2(imgWeights', allWeights', 'euclidean');
%0.3954 (when traning on only db1 and cl)

[minDist, index] = min(distances);

if minDist<462.6
    imgNumber= index;
end
end