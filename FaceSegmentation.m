function [FaceSeg] = FaceSegmentation(inputImg)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    % % Display the image
    % figure;
    % imshow(inputImg);
    % title('Click on 10 pixels to get HSV values');
    % 
    % % Initialize arrays to store selected HSV values
    % selectedH = zeros(10, 1);
    % selectedS = zeros(10, 1);
    % selectedV = zeros(10, 1);
    % 
    % % Loop to get 10 user-selected pixels
    % for i = 1:10
    %     % Wait for the user to click on a pixel
    %     [x, y] = ginput(1);
    % 
    %     % Round the coordinates to integers
    %     x = round(x);
    %     y = round(y);
    % 
    %     % Get the HSV values for the selected pixel
    %     hsvValues = rgb2hsv(inputImg(y, x, :));
    % 
    %     % Store the HSV values
    %     selectedH(i) = hsvValues(1);
    %     selectedS(i) = hsvValues(2);
    %     selectedV(i) = hsvValues(3);
    % 
    %     % Mark the selected pixel on the image
    %     hold on;
    %     plot(x, y, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    %     hold off;
    % end
    % 
    % % Display the minimum and maximum HSV values
    % fprintf('Minimum HSV Values: H=%.2f, S=%.2f, V=%.2f\n', min(selectedH), min(selectedS), min(selectedV));
    % fprintf('Maximum HSV Values: H=%.2f, S=%.2f, V=%.2f\n', max(selectedH), max(selectedS), max(selectedV));


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
    % skinyRange = [100, 255];
    % skincbRange = [105, 255];
    % skincrRange = [120, 170];


    % Create a binary mask based on the specified color range
    skinMask = (y >= skinyRange(1) & y <= skinyRange(2)) & ...
               (cb >= skincbRange(1) & cb <= skincbRange(2)) & ...
               (cr >= skincrRange(1) & cr <= skincrRange(2));

    % imshow(skinMask);
    % % Optional: Perform morphological operations to refine the mask
    se = strel('disk', 3);
    skinMask = imopen(skinMask, se);
    skinMask= imclose(skinMask, se);

binary_img= double(skinMask);
binaryImg= imfill(binary_img, 'holes');
target= 256:-4:4;
binaryImg= histeq(binaryImg, target);
binaryImg=imbinarize(binaryImg, 0.8);
binaryImg= bwareafilt(binaryImg,1);
%imshow(binaryImg);
FaceSeg= binaryImg;
end