function [FaceSeg, yMin, yMax] = FaceSegmentation(inputImg)

    % Convert the RGB image to YCbCr color space
    ycbrImage = rgb2ycbcr(inputImg);
%imshow(ycbrImage);
    % Extract the Y, Cb, and Cr channels
    y = double(ycbrImage(:, :, 1));
    cb = double(ycbrImage(:, :, 2));
    cr = double(ycbrImage(:, :, 3));

    % Define the color range for skin tones in YCbCr space
    skinyRange = double([110/255, 1]);
    skincbRange = double([110/255, 1]);
    skincrRange = double([120/255, 170/255]);

    % Create a binary mask based on the specified color range
    skinMask = (y >= skinyRange(1) & y <= skinyRange(2)) & ...
               (cb >= skincbRange(1) & cb <= skincbRange(2)) & ...
               (cr >= skincrRange(1) & cr <= skincrRange(2));
    
    avg = mean(skinMask(:));
        avg2 = mean(cr(:));

        avg3 = mean(cb(:));
                avg4 = mean(y(:));

    if (avg > 0.7 && avg < 0.78)
        skinMask = (y >= 160/255 & y <= skinyRange(2)) & ...
                   (cb >= skincbRange(1) & cb <= skincbRange(2)) & ...
                   (cr >= skincrRange(1) & cr <= skincrRange(2));
    end

    %imshow(skinMask);
    
    % Perform morphological operations to refine the mask
    se = strel('disk', 2);
    skinMask = imopen(skinMask, se);
    skinMask = imclose(skinMask, se);

    se = strel('diamond', 3);
    skinMask = imdilate(skinMask, se);
    skinMask = imdilate(skinMask, se);

    binary_img = double(skinMask);

    %imshow(binary_img);

    binaryImg = imfill(binary_img, 'holes');
    target = 1:-0.01:0;
    binaryImg = histeq(binaryImg, target);
    binaryImg = imbinarize(binaryImg, 0.7);

    stats = regionprops(binaryImg, 'Area', 'Centroid', 'Eccentricity');

    areas = [stats.Area];
    centroids = reshape([stats.Centroid], 2, []);

    % Calculate distances of centroids from the center of the image
    distances = sqrt((centroids(1, :) - size(binaryImg, 2)/2).^2 + ...
                     (centroids(2, :) - size(binaryImg, 1)/2).^2);

    % Filter blobs with area greater than 50,000
    largeBlobsIndices = find(areas > 50000);

    if isempty(largeBlobsIndices)
        disp('No blobs larger than 50,000 pixels found.');
        return;
    end

    % Find the index of the blob with the smallest distance from the center
    [~, idxMinDistance] = min(distances(largeBlobsIndices));

    % The index in the original stats array
    selectedBlobIndex = largeBlobsIndices(idxMinDistance);

    binaryImg = ismember(bwlabel(binaryImg), selectedBlobIndex);

    se = strel('disk', 3);
    binaryImg = imclose(binaryImg, se);
    FaceSeg = imfill(binaryImg, 'holes');

    [rows, ~] = find(FaceSeg == 1);
    yMin = min(rows);
    yMax = max(rows);

end