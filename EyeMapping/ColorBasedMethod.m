function [returnImg] = ColorBasedMethod(inputImg, threshold)
    % Convert the input image to grayscale
    grayImage = rgb2gray(inputImg);

    % Perform histogram equalization on the grayscale image
    equalizedImg = histeq(grayImage);

    % Create a binary image based on the specified threshold
    binaryImage = equalizedImg < threshold;

    % Perform connected component analysis on the binary image
    cc = bwconncomp(binaryImage);
    stats = regionprops(cc, 'Area', 'BoundingBox', 'Solidity', 'Orientation', 'PixelIdxList');

    % Initialize the filtered image
    filteredImage = false(size(binaryImage));

    % Iterate over the regions and filter based on specified criteria
    for i = 1:length(stats)
        boundingBox = stats(i).BoundingBox;
        aspectRatio = boundingBox(3) / boundingBox(4);

        % Check conditions for region filtering
        if stats(i).Solidity > 0.5 && aspectRatio >= 0.8 && aspectRatio <= 4.0 ...
                && ~any(stats(i).PixelIdxList <= size(binaryImage, 2)) ...  % Not touching top border
                && ~any(stats(i).PixelIdxList > numel(binaryImage) - size(binaryImage, 2)) ...  % Not touching bottom border
                && ~any(mod(stats(i).PixelIdxList, size(binaryImage, 1)) == 1) ...  % Not touching left border
                && ~any(mod(stats(i).PixelIdxList, size(binaryImage, 1)) == 0) ...  % Not touching right border
                && stats(i).Orientation >= -45 && stats(i).Orientation <= 45
            filteredImage(stats(i).PixelIdxList) = true;
        end
    end

    % Output the filtered image
    returnImg = filteredImage;
end
