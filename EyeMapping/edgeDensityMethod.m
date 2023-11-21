function [returnImg] = edgeDensityMethod(inputImg,filterSize)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
grayImg= rgb2gray(inputImg);
edges= edge(grayImg, 'sobel');
se = strel('disk', filterSize);
dilatedImg= imdilate(edges, se);
dilatedImg= imdilate(dilatedImg, se);

filledImg= imfill(dilatedImg, 'holes');

erodedImg = imerode(filledImg,se);
erodedImg= imerode(erodedImg, se);
erodedImg= imerode(erodedImg, se);

cc= bwconncomp(erodedImg);
stats= regionprops(cc, 'Area', 'BoundingBox','Solidity','Orientation', 'PixelIdxList');

filteredImage = false(size(erodedImg));
for i = 1:length(stats)
    boundingBox = stats(i).BoundingBox;
    aspectRatio = boundingBox(3) / boundingBox(4);
    if stats(i).Solidity > 0.5 && aspectRatio >= 0.8 && aspectRatio <= 4.0 ...
        && ~any(stats(i).PixelIdxList <= size(erodedImg, 2)) ...  % Not touching top border
        && ~any(stats(i).PixelIdxList > numel(erodedImg) - size(erodedImg, 2)) ...  % Not touching bottom border
        && ~any(mod(stats(i).PixelIdxList, size(erodedImg, 1)) == 1) ...  % Not touching left border
        && ~any(mod(stats(i).PixelIdxList, size(erodedImg, 1)) == 0) ...  % Not touching right border
        && stats(i).Orientation >= -45 && stats(i).Orientation <= 45
        filteredImage(stats(i).PixelIdxList) = true;
    end
end

returnImg= filteredImage;
end