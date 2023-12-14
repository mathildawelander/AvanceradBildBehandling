function [returnImg] = illuminationBasedMethod(InputImg, radius, threshold, faceSeg)
    % Illumination-based Method for Face Detection
    % InputImg: Input RGB image
    % radius: Radius for morphological operations
    % threshold: Threshold for binary image
    % faceSeg: Binary mask for face segmentation

    % Create images of the face
    face = InputImg;
    face_eq = histeq(face);
    facebw = imbinarize(rgb2gray(face_eq), 0.7);

    % Adjust color channels to have the same mean
    meanr = mean(mean(face_eq(:,:,1) .* facebw));
    meang = mean(mean(face_eq(:,:,2) .* facebw));
    meanb = mean(mean(face_eq(:,:,3) .* facebw));
    meanmean = (meanr + meang + meanb) / 3;

    multr = meanmean / meanr;
    multg = meanmean / meang;
    multb = meanmean / meanb;

    face(:,:,1) = face_eq(:,:,1) * multr;
    face(:,:,2) = face_eq(:,:,2) * multg;
    face(:,:,3) = face_eq(:,:,3) * multb;

    % Eye Map
    YCbCrFace = rgb2ycbcr(face_eq);
    Y = double(YCbCrFace(:,:,1));
    Cb = normalize(double(YCbCrFace(:,:,2)), "norm", 1);
    Cr = normalize(double(YCbCrFace(:,:,3)), "norm", 1);
    Cr_ = 1 - Cr;
    eyeMapC = (Cb.^2 + Cr_.^2 + (Cb./Cr)) / 3;

    se = strel('disk', radius);
    dilated_image = imdilate(Y, se);
    eroded_image = imerode(Y, se);
    eyemapL = dilated_image ./ (eroded_image + 1);
    
    andimg = eyemapL .* eyeMapC;

    newimg = imdilate(andimg, se);
    maxVal = max(newimg(:));
    minVal = min(newimg(:));
    newimg = (newimg - minVal) / (maxVal - minVal);

    keepGoing = true;

    while keepGoing
        newimgnew = newimg > threshold;
        newimgnew = newimgnew .* faceSeg;

        cc = bwconncomp(newimgnew);
        stats = regionprops(cc, 'Area', 'BoundingBox', 'Solidity', 'Orientation', 'PixelIdxList');

        filteredImage = false(size(newimgnew));

        for i = 1:length(stats)
            boundingBox = stats(i).BoundingBox;
            aspectRatio = boundingBox(3) / boundingBox(4);

            if stats(i).Solidity > 0.5 && aspectRatio >= 0.8 && aspectRatio <= 4.0 ...
                && ~any(stats(i).PixelIdxList <= size(newimgnew, 2)) ...
                && ~any(stats(i).PixelIdxList > numel(newimgnew) - size(newimgnew, 2)) ...
                && ~any(mod(stats(i).PixelIdxList, size(newimgnew, 1)) == 1) ...
                && ~any(mod(stats(i).PixelIdxList, size(newimgnew, 1)) == 0) ...
                && stats(i).Orientation >= -45 && stats(i).Orientation <= 45

                filteredImage(stats(i).PixelIdxList) = true;
            end
        end

        [labeledImage, ~] = bwlabel(filteredImage);
        regions = regionprops(labeledImage, 'Centroid', 'Area', 'BoundingBox', 'Eccentricity');
        validRegions = regions(arrayfun(@(x) x.Centroid(2) < 3 * size(InputImg, 1) / 5, regions));
        validRegions = validRegions(arrayfun(@(x) x.Centroid(2) > 30 * size(InputImg, 1) / 100, validRegions));
        validRegions = validRegions(arrayfun(@(x) x.Centroid(1) > 1 * size(InputImg, 2) / 5, validRegions));
        validRegions = validRegions(arrayfun(@(x) x.Centroid(1) < 4 * size(InputImg, 2) / 5, validRegions));
        validRegions = validRegions(arrayfun(@(x) x.Eccentricity < 0.95, validRegions));
        validRegionsSmall = validRegions(arrayfun(@(x) x.Area > 5, validRegions));
        validRegionsLarge = validRegions(arrayfun(@(x) x.Area > 500, validRegions));

        numRegionsRemoveSmall = size(validRegionsSmall, 1);
        numRegionsRemoveLarge = size(validRegionsLarge, 1);

        if (numRegionsRemoveLarge >= 2) || (threshold == 0.3)
            keepGoing = false;
        else
            threshold = threshold - 0.05;
        end
    end

    returnImg = newimgnew;
end
