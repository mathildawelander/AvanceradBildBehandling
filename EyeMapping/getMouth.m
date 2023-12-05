function [mouthPos] = getMouth(img)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [labeledImage, numRegions] = bwlabel(img);
    regions = regionprops(labeledImage, 'Centroid', 'Area', 'BoundingBox', 'Orientation');


   if numRegions >= 1
    validRegions = regions(arrayfun(@(x) x.Centroid(2) > size(img, 1) / 2, regions));
    validRegions = validRegions(arrayfun(@(x) abs(x.Orientation) < 10, validRegions));

    % Sort the valid regions based on eccentricity
    [~, sortedValidIndices] = sort([arrayfun(@(x) x.Area, validRegions)],'descend');
    
   
   end
    
    % If a valid pair is found, selectedRegions will be set
    if exist('sortedValidIndices', 'var') && ~isempty(sortedValidIndices)
       mouthPos = validRegions(sortedValidIndices(1)).Centroid;
    else
        mouthPos=-1;
        disp('No valid regions found that meet the mouth criteria');
    end
end
