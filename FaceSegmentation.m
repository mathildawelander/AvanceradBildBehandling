function [FaceSeg] = FaceSegmentation(face_BW)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

stats = regionprops(face_BW, 'Area', 'BoundingBox');

% Step 1
for i = 1:length(stats)
    numHoles = bweuler(face_BW == i);

    % If there are no holes, discard the region
    if numHoles == 0
        face_BW(face_BW == i) = 0;
    end
end

% Step 2
for i = 1:length(stats)
    width = stats(i).BoundingBox(3);
    height = stats(i).BoundingBox(4);

    % Compute the ratio of width to height
    ratio = width / height;

    % Discard the region if the ratio is outside the desired range [0.8, 2.0]
    if ratio < 0.8 || ratio > 2.0
        face_BW(face_BW == i) = 0;
    end
end

% Step 3
for i = 1:length(stats)
    areaRatio = stats(i).Area / (stats(i).BoundingBox(3) * stats(i).BoundingBox(4));

    % Discard the region if the ratio is less than 0
    if areaRatio < 0
        face_BW(face_BW == i) = 0;
    end
end

% Step 4
face_BW = bwareaopen(face_BW, 400);

% Step 5
for i = 1:length(stats)
    width = stats(i).BoundingBox(3);
    height = stats(i).BoundingBox(4);

    % Discard the region if width or height is less than 20
    if width < 20 || height < 20
        face_BW(face_BW == i) = 0;
    end
end


end