function id = tnm034(im)

    load('data/FisherFaces.mat', 'F');
    load('data/ClassWeight.mat', 'Class_weight');

    % Read the input image
    face = double(im);
    face = face / max(face(:));

    % Perform gray world assumption for color correction
    facegw = grayWorld(face);

    % Perform face segmentation to isolate the face region
    [faceSeg, topBoundary, lowerBoundary] = FaceSegmentation(facegw);

    % Calculate the threshold for eye detection
    threshold = lowerBoundary - (0.8 * (lowerBoundary - topBoundary));

    % Generate eye map
    [eyeImg, ~, il, co] = eyeMap(face, faceSeg);

    % Generate mouth map for mouth detection
    mouthImg = mouthMap(face, faceSeg);

    % Get the positions of the eyes
    eyePos = getEyes(eyeImg, mouthImg, threshold, il, co);

    if(eyePos == -1) 
        disp('Could not detect eyes, quitting program')
        id = -1;
        return;
    end

    % Determine the positions of the left and right eyes
    if (eyePos(1, 1) < eyePos(2, 1))
        leftEye = eyePos(1, :);
        rightEye = eyePos(2, :);
    else
        leftEye = eyePos(2, :);
        rightEye = eyePos(1, :);
    end

    % Crop the image
    img = CropImages(face, leftEye, rightEye);

    % Convert the cropped image to grayscale and flatten it to a vector
    img = rgb2gray(img);
    img = img(:);

    % Calculate weights 
    Wimg = calculateWeights(img, F);

    % Get the closest face identity using calculated weights
    id = getClosestFace(Wimg, Class_weight);
end
