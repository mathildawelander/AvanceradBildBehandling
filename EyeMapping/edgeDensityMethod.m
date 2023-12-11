function [returnImg] = edgeDensityMethod(inputImg,filterSize, faceSeg)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
grayImg= rgb2gray(inputImg);
keepGoing=true;

while keepGoing
edges= edge(grayImg, 'sobel');
se = strel('disk', filterSize);
dilatedImg= imdilate(edges, se);
dilatedImg= imdilate(dilatedImg, se);
filledImg= imfill(dilatedImg, 'holes');
erodedImg = imerode(filledImg,se);
erodedImg= imerode(erodedImg, se);
erodedImg= imerode(erodedImg, se);
erodedImg= erodedImg.*faceSeg;

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
    %imshow(filteredImage);
end

%imshow(filteredImage);
[labeledImage, ~] = bwlabel(filteredImage);
regions = regionprops(labeledImage, 'Centroid', 'Area', 'BoundingBox', 'Eccentricity');
validRegions = regions(arrayfun(@(x) x.Centroid(2) < 3*size(inputImg, 1) / 5, regions));
    validRegions = validRegions(arrayfun(@(x) x.Centroid(2) > 30*size(inputImg,1)/100, validRegions));
    validRegions = validRegions(arrayfun(@(x) x.Centroid(1) > 1*size(inputImg, 2) / 5, validRegions));
    validRegions = validRegions(arrayfun(@(x) x.Centroid(1) < 4*size(inputImg, 2) / 5, validRegions));
    validRegions = validRegions(arrayfun(@(x) x.Eccentricity < 0.95, validRegions));
    validRegionsSmall = validRegions(arrayfun(@(x) x.Area > 5, validRegions));
    validRegionsLarge = validRegions(arrayfun(@(x) x.Area > 20, validRegions));


numRegionsRemoveSmall=size(validRegionsSmall,1);
numRegionsRemoveLarge=size(validRegionsLarge,1);

if (numRegionsRemoveSmall < 5 && numRegionsRemoveLarge>= 2) || filterSize==5
    keepGoing= false;
else
    filterSize= filterSize+1;
end

end

%imshow(filteredImage);
returnImg= filteredImage;
end