function [eyePos] = getEyes(img, mouthImg, topBoundary)

    [labeledImage, numRegions] = bwlabel(img);
    regions = regionprops(labeledImage, 'Centroid', 'Area', 'BoundingBox', 'Eccentricity');

    mouthPos= getMouth(mouthImg);
    eyePos = zeros(numel(regions), 2);

    if numRegions == 2
    selectedRegions =regions;
    end
   if numRegions > 2
    validRegions = regions(arrayfun(@(x) x.Centroid(2) < 3*size(img, 1) / 5, regions));
    validRegions = validRegions(arrayfun(@(x) x.Centroid(2) > topBoundary, validRegions));
    validRegions = validRegions(arrayfun(@(x) x.Centroid(1) > 1*size(img, 2) / 5, validRegions));
    validRegions = validRegions(arrayfun(@(x) x.Centroid(1) < 4*size(img, 2) / 5, validRegions));
    validRegions = validRegions(arrayfun(@(x) x.Eccentricity < 0.95, validRegions));
        validRegions = validRegions(arrayfun(@(x) x.Area < 1200, validRegions));


    % Sort the valid regions based on eccentricity
    [~, sortedValidIndices] = sort([arrayfun(@(x) x.Area, validRegions)],'descend');
    
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
                deltaY = region2.Centroid(2) - region1.Centroid(2);
                deltaX = region2.Centroid(1) - region1.Centroid(1);
                angle = abs(atan2d(deltaY, deltaX));
                
% angle: 6 o dist: 165
% eller angle 7.3

                % Check if the angle is within ±5 degrees of horizontal
                if angle <= 7.3 || abs(angle-180) <= 7.3
                    if mouthPos~= -1
                           if mouthPos(1) > min(region1.Centroid(1), region2.Centroid(1)) && ...
                            mouthPos(1) < max(region1.Centroid(1), region2.Centroid(1))
                        selectedRegions = [region1, region2];
                     break; % Exit the loop once a valid pair is found                    
                           elseif ~exist('tempRegions', 'var')
                     tempRegions= [region1, region2];

                           end

                end
if ~exist('tempRegions', 'var')
                     tempRegions= [region1, region2];

                           end

                end
            end
        end
        if exist('selectedRegions', 'var')
            break; % Exit the outer loop if a pair is already found
        end
    end
    
   
   end
    % If a valid pair is found, selectedRegions will be set
    if exist('selectedRegions', 'var')
       eyePos(1, :) = selectedRegions(1).Centroid;
       eyePos(2, :) = selectedRegions(2).Centroid;
    elseif exist('tempRegions', 'var')
       eyePos(1, :) = tempRegions(1).Centroid;
       eyePos(2, :) = tempRegions(2).Centroid;
    else
        disp('No valid regions found that meet the criteria');
    end
end
