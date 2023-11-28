function [eyePos] = getEyes(img)
    % UNTITLED Summary of this function goes here
    % Detailed explanation goes here

    [labeledImage, numRegions] = bwlabel(img);
    regions = regionprops(labeledImage, 'Centroid', 'Area', 'BoundingBox');

    eyePos = zeros(numel(regions), 2);
    eyePosReal = zeros(2, 2);

    [~, sortedIndices] = sort([regions.Area], 'descend');

    if numRegions >= 2
        % Filter regions based on area (assuming eyes are among the largest regions)
        validRegions = regions(sortedIndices(1:2));

        % Filter regions located in the top 50% of the image
        validRegions = validRegions(arrayfun(@(x) x.Centroid(2) < size(img, 1) / 2, validRegions));

        % Sort the valid regions based on x-coordinate
        [~, sortedValidIndices] = sort(arrayfun(@(x) x.Centroid(1), validRegions));

        % Select the two most leftward regions (assuming left and right eyes)
        selectedRegions = validRegions(sortedValidIndices(1:2));

        % Ensure the eyes are in a 80-150 pixel range from each other
        eyeDist = pdist([selectedRegions(1).Centroid; selectedRegions(2).Centroid]);
        if eyeDist >= 80 && eyeDist <= 150
            eyePos(1, :) = selectedRegions(1).Centroid;
            eyePos(2, :) = selectedRegions(2).Centroid;
        else
            error('Eyes are not in the specified range :(');
        end
    else
        error('Not enough regions detected :(');
    end
end
