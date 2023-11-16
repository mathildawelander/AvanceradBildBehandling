function [eyePos] = getEyes(img)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[labeledImage, numRegions]= bwlabel(img);
regions= regionprops(labeledImage, 'Centroid', 'Area', 'BoundingBox');

eyePos= zeros(numel(regions),2);
eyePosreal= zeros(2,2);


[~, sortedIndices] = sort([regions.Area], 'descend');

if numRegions >=2
    for i = 1:2
        eyePos(i,:)=regions(sortedIndices(i)).Centroid;
    end
else
    error('not enought regions detected :(')
end


end