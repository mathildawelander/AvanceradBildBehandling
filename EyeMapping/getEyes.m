function [eyePos] = getEyes(img, mouthImg, topBoundary, il, co)
    % Initialize the output variable
    eyePos = zeros(2, 2);

    % Extract regions using connected component analysis
    [labeledImage, numRegions] = bwlabel(img);
    regions = regionprops(labeledImage, 'Centroid', 'Area', 'BoundingBox', 'Eccentricity');

    % Get the position of the mouth
    mouthPos = getMouth(mouthImg);

    % Check the number of detected regions
    if numRegions == 2
        selectedRegions = regions;
    end

    % Check if more than 2 regions are detected
    if numRegions > 2
        % Filter regions based on various criteria
        validRegions = filterValidRegions(regions, img, topBoundary);

        % If two valid regions are found, select them
        if size(validRegions, 1) == 2
            selectedRegions = validRegions;
        end

        % Sort the valid regions based on area in descending order
        [~, sortedValidIndices] = sort([arrayfun(@(x) x.Area, validRegions)], 'descend');

        % Iterate over pairs of regions to find two that meet the criteria
        for i = 1:length(sortedValidIndices) - 1
            for j = i+1:length(sortedValidIndices)
                region1 = validRegions(sortedValidIndices(i));
                region2 = validRegions(sortedValidIndices(j));

                % Calculate the distance between centroids
                eyeDist = pdist([region1.Centroid; region2.Centroid]);

                % Check if distance is within the specified range (80-150 pixels)
                if eyeDist >= 80 && eyeDist <= 180
                    % Calculate the angle with the horizontal
                    angle = calculateAngle(region1.Centroid, region2.Centroid);

                    % Check if the angle is within ±5 degrees of horizontal
                    if isHorizontalAngle(angle)
                        if isMouthAligned(mouthPos, region1.Centroid, region2.Centroid)
                            selectedRegions = [region1, region2];
                            break; % Exit the loop once a valid pair is found
                        end
                    end
                end
            end
            if exist('selectedRegions', 'var')
                break; % Exit the outer loop if a pair is already found
            end
        end
    end

    % If a valid pair is found, set eyePos
    if exist('selectedRegions', 'var')
        eyePos(1, :) = selectedRegions(1).Centroid;
        eyePos(2, :) = selectedRegions(2).Centroid;
    else
        % If no valid pair is found, try alternative methods
        if ~isempty(il)
            eyePos = getEyes(il, mouthImg, topBoundary, [], co);
        elseif ~isempty(co)
            co = preprocessAndFillHoles(co);
            eyePos = getEyes(co, mouthImg, topBoundary, [], []);
        else
            eyePos=-1;
            disp('No valid eyes found');
        end
    end
end

function validRegions = filterValidRegions(regions, img, topBoundary)
    % Filter regions based on various criteria
    validRegions = regions(arrayfun(@(x) x.Centroid(2) < 3*size(img, 1) / 5, regions));
    validRegions = validRegions(arrayfun(@(x) x.Centroid(2) > topBoundary, validRegions));
    validRegions = validRegions(arrayfun(@(x) x.Centroid(2) > 30*size(img,1)/100, validRegions));
    validRegions = validRegions(arrayfun(@(x) x.Centroid(1) > 1*size(img, 2) / 5, validRegions));
    validRegions = validRegions(arrayfun(@(x) x.Centroid(1) < 4*size(img, 2) / 5, validRegions));
    validRegions = validRegions(arrayfun(@(x) x.Eccentricity < 0.98, validRegions));
    validRegions = validRegions(arrayfun(@(x) x.Area < 2500, validRegions));
end

function angle = calculateAngle(centroid1, centroid2)
    % Calculate the angle with the horizontal
    deltaY = centroid2(2) - centroid1(2);
    deltaX = centroid2(1) - centroid1(1);
    angle = abs(atan2d(deltaY, deltaX));
end

function isHorizontal = isHorizontalAngle(angle)
    % Check if the angle is within ±7.3 degrees of horizontal
    isHorizontal = angle <= 7.3 || abs(angle - 180) <= 7.3;
end

function aligned = isMouthAligned(mouthPos, centroid1, centroid2)
    % Check if the mouth is aligned with the detected regions
    aligned= false;
    if mouthPos~= -1
        if mouthPos(1) > min(centroid1(1), centroid2(1)) && ...
            mouthPos(1) < max(centroid1(1), centroid2(1))
            aligned=true;         
         end

     end
end

function img = preprocessAndFillHoles(co)
    % Preprocess the image and fill holes
    se1 = strel('disk', 1);
    se = strel('disk', 5);

    % Dilation using the circular structuring element
    co = imerode(co, se1);

    % Erosion using the circular structuring element
    co = imerode(co, se);

    % Dilation using the circular structuring element
    co = imdilate(co, se);

    % Fill holes in the image
    img = imfill(co, 'holes');
end
