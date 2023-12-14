function [returnImg] = edgeDensityMethod(inputImg, filterSize, faceSeg)
    % Convert the input RGB image to grayscale
    grayImg = rgb2gray(inputImg);
    
    % Initialize loop control variable
    keepGoing = true;

    % Continue the loop until get good blobs
    while keepGoing
        % Apply Sobel edge detection to the grayscale image
        edges = edge(grayImg, 'sobel');
        
        % Create a stuct element
        se = strel('disk', filterSize);
        
        % Dilate the edges and fill the regions
        dilatedImg = imdilate(edges, se);
        dilatedImg = imdilate(dilatedImg, se);
        filledImg = imfill(dilatedImg, 'holes');
        
        % Erode the filled image
        erodedImg = imerode(filledImg, se);
        erodedImg = imerode(erodedImg, se);
        erodedImg = imerode(erodedImg, se);
        
        % Apply the face segmentation mask to the eroded image
        erodedImg = erodedImg .* faceSeg;

        % Find connected components in the eroded image
        cc = bwconncomp(erodedImg);
        
        % Extract region properties
        stats = regionprops(cc, 'Area', 'BoundingBox', 'Solidity', 'Orientation', 'PixelIdxList');
        
        % Initialize a binary image for filtered regions
        filteredImage = false(size(erodedImg));

        % Iterate through the regions to filter based on specific criteria
        for i = 1:length(stats)
            boundingBox = stats(i).BoundingBox;
            aspectRatio = boundingBox(3) / boundingBox(4);
            
            % Check various criteria for region filtering
            if stats(i).Solidity > 0.5 && aspectRatio >= 0.8 && aspectRatio <= 4.0 ...
                    && ~any(stats(i).PixelIdxList <= size(erodedImg, 2)) ...
                    && ~any(stats(i).PixelIdxList > numel(erodedImg) - size(erodedImg, 2)) ...
                    && ~any(mod(stats(i).PixelIdxList, size(erodedImg, 1)) == 1) ...
                    && ~any(mod(stats(i).PixelIdxList, size(erodedImg, 1)) == 0) ...
                    && stats(i).Orientation >= -45 && stats(i).Orientation <= 45
                filteredImage(stats(i).PixelIdxList) = true;
            end
        end

        % Label connected components in the filtered image
        [labeledImage, ~] = bwlabel(filteredImage);
        
        % Extract region properties of labeled regions
        regions = regionprops(labeledImage, 'Centroid', 'Area', 'BoundingBox', 'Eccentricity');
        
        % Further filter regions based on centroid and eccentricity
        validRegions = regions(arrayfun(@(x) x.Centroid(2) < 3 * size(inputImg, 1) / 5, regions));
        validRegions = validRegions(arrayfun(@(x) x.Centroid(2) > 30 * size(inputImg, 1) / 100, validRegions));
        validRegions = validRegions(arrayfun(@(x) x.Centroid(1) > 1 * size(inputImg, 2) / 5, validRegions));
        validRegions = validRegions(arrayfun(@(x) x.Centroid(1) < 4 * size(inputImg, 2) / 5, validRegions));
        validRegions = validRegions(arrayfun(@(x) x.Eccentricity < 0.95, validRegions));
        validRegionsSmall = validRegions(arrayfun(@(x) x.Area > 5, validRegions));
        validRegionsLarge = validRegions(arrayfun(@(x) x.Area > 20, validRegions));

        % Get the number of regions to remove based on size
        numRegionsRemoveSmall = size(validRegionsSmall, 1);
        numRegionsRemoveLarge = size(validRegionsLarge, 1);

        % Check the stopping condition for the loop
        if (numRegionsRemoveSmall < 5 && numRegionsRemoveLarge >= 2) || filterSize == 5
            keepGoing = false;
        else
            % Increase the filter size for the next iteration
            filterSize = filterSize + 1;
        end
    end

    % Set the output image as the final filtered image
    returnImg = filteredImage;
end
