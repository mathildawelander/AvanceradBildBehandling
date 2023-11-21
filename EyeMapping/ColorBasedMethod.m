function [returnImg] = ColorBasedMethod(inputImg, threshold)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
grayImage = rgb2gray(inputImg);
equalizedimg= histeq(grayImage);
binaryImage= equalizedimg<threshold;

cc= bwconncomp(binaryImage);
stats= regionprops(cc, 'Area', 'BoundingBox','Solidity','Orientation', 'PixelIdxList');

filteredImage = false(size(binaryImage));
for i = 1:length(stats)
    boundingBox = stats(i).BoundingBox;
    aspectRatio = boundingBox(3) / boundingBox(4);
    if stats(i).Solidity > 0.5 && aspectRatio >= 0.8 && aspectRatio <= 4.0 ...
        && ~any(stats(i).PixelIdxList <= size(binaryImage, 2)) ...  % Not touching top border
        && ~any(stats(i).PixelIdxList > numel(binaryImage) - size(binaryImage, 2)) ...  % Not touching bottom border
        && ~any(mod(stats(i).PixelIdxList, size(binaryImage, 1)) == 1) ...  % Not touching left border
        && ~any(mod(stats(i).PixelIdxList, size(binaryImage, 1)) == 0) ...  % Not touching right border
        && stats(i).Orientation >= -45 && stats(i).Orientation <= 45
        filteredImage(stats(i).PixelIdxList) = true;
    end
end
returnImg= filteredImage;

end