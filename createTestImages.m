%  % Read the input image
%     inputImage = imread('DB1\db1_02.jpg');
% 
%     % Convert the image to HSV color space
%     hsvImage = rgb2hsv(inputImage);
% 
%     % Increase the tone value by 30%
%     increasedToneImage = hsvImage;
%     increasedToneImage(:,:,3) = min(1, 0.7 * increasedToneImage(:,:,3));
% 
%     % Convert the image back to RGB color space
%     increasedToneImage = hsv2rgb(increasedToneImage);
% 
% imwrite(increasedToneImage, 'test\db1_02.jpg');

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
