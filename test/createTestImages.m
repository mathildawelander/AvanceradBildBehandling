    % Read the input image
inputImage = imread('DB1\db1_05.jpg');

    % Get the original image size
    originalSize = size(inputImage);

    % Calculate the scaling factor for +10%
    scaleFactor = 0.9;

    % Calculate the new size after scaling
    newSize = round(originalSize(1:2) * scaleFactor);

    % Scale the image
    scaledImage = imresize(inputImage, newSize);

 imwrite(scaledImage, 'test\db1_05.jpg');
