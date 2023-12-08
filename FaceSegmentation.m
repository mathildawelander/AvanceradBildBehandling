function [FaceSeg, yMin, yMax] = FaceSegmentation(inputImg)

 % Convert the RGB image to HSV color space
    ycbrImage = rgb2ycbcr(inputImg);

    % Extract the hue, saturation, and value channels
    y = ycbrImage(:, :, 1);
    cb = ycbrImage(:, :, 2);
    cr = ycbrImage(:, :, 3);

    % Define the color range for skin tones in HSV space
    % These values may need to be adjusted based on your images
    skinyRange = [100, 255];
    skincbRange = [112, 255];
    skincrRange = [120, 170];

    % Create a binary mask based on the specified color range
    skinMask = (y >= skinyRange(1) & y <= skinyRange(2)) & ...
               (cb >= skincbRange(1) & cb <= skincbRange(2)) & ...
               (cr >= skincrRange(1) & cr <= skincrRange(2));


    %imshow(skinMask);

    %Perform morphological operations to refine the mask
    se = strel('disk', 2);
    skinMask = imopen(skinMask, se);
    skinMask= imclose(skinMask, se);
    %imshow(skinMask);

binary_img = double(skinMask);
binaryImg = imfill(binary_img, 'holes');
target = 256:-4:4;
binaryImg = histeq(binaryImg, target);
binaryImg = imbinarize(binaryImg, 0.8);
%imshow(binaryImg); 

stats = regionprops(binaryImg, 'Area', 'Centroid', 'Eccentricity');

areas = [stats.Area];
eccentricities = [stats.Eccentricity];

% Filter blobs with area greater than 50,000
largeBlobsIndices = find(areas > 50000);

if isempty(largeBlobsIndices)
    disp('No blobs larger than 50,000 pixels found.');
    return;
end

% Extract the eccentricities of these large blobs
largeBlobsEccentricities = eccentricities(largeBlobsIndices);

% Find the index of the blob with the smallest eccentricity
[~, idxSmallestEccentricity] = min(largeBlobsEccentricities);

% The index in the original stats array
selectedBlobIndex = largeBlobsIndices(idxSmallestEccentricity);

binaryImg = ismember(bwlabel(binaryImg), selectedBlobIndex);
 
se = strel('disk', 3);
binaryImg= imclose(binaryImg, se);
FaceSeg = imfill(binaryImg, 'holes');

[rows, cols] = find(FaceSeg==1);
yMin= min(rows);
yMax= max(rows);


end