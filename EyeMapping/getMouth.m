function [mouthPos] = getMouth(img)
    % Extract regions from the binary image
    [labeledImage, numRegions] = bwlabel(img);
    regions = regionprops(labeledImage, 'Centroid', 'Area', 'BoundingBox', 'Orientation');

    % Check if there is at least one valid region
    if numRegions >= 1
        % Filter valid regions based on centroid and orientation
        validRegions = regions(arrayfun(@(x) x.Centroid(2) > size(img, 1) / 2, regions));
        validRegions = validRegions(arrayfun(@(x) abs(x.Orientation) < 10, validRegions));

        % Sort valid regions based on area in descending order
        [~, sortedValidIndices] = sort([arrayfun(@(x) x.Area, validRegions)], 'descend');
    end

    % If a valid region is found, set the mouth position
    if exist('sortedValidIndices', 'var') && ~isempty(sortedValidIndices)
        mouthPos = validRegions(sortedValidIndices(1)).Centroid;
    else
        % If no valid region is found, set mouthPos to -1 and display a message
        mouthPos = -1;
    end
end
