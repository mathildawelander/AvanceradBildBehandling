function [outputIMG] = mouthMap(inputIMG, faceSeg)
    % Convert input image to YCbCr color space
    inputIMG = rgb2ycbcr(inputIMG);
    Cb = inputIMG(:,:,2);
    Cr = inputIMG(:,:,3);

    % Normalization factor
    n = 0.95 * (0.5 * sum(Cr.^2)) / (0.5 * sum(Cr./Cb));

    % Mouth map formula according to the lecture
    mouthMap = Cr.^2 .* (Cr.^2 - n * Cr./Cb).^2;

    % Normalize the mouth map to the range [0, 1]
    mouthMap = (mouthMap - min(mouthMap(:))) / (max(mouthMap(:)) - min(mouthMap(:)));

    % Set a threshold to create a binary mouth map
    threshold = 0.25;
    MouthMap = mouthMap > threshold;

    % Dilate the binary mouth map for better results
    se = strel('disk', 5);
    MouthMap = imdilate(MouthMap, se);

    % Check if the detected mouth region is valid using the face segmentation
    if getMouth(MouthMap.*faceSeg) == -1
        % If the detected mouth is invalid, use the original mouth map
        mouthImg = mouthMap.*faceSeg;
        mouthImg = mouthImg / max(mouthImg(:));
        mouthImg = mouthImg > 0.5;

        % Dilate the binary mouth map for better results
        se = strel('disk', 5);
        MouthMap = imdilate(mouthImg, se);
    end

    % Output the final mouth map
    outputIMG = MouthMap;
end
