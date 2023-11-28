function [FaceSeg] = FaceSegmentation(inputImg)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
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