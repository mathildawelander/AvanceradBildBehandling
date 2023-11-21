
image_size = [300,350];
cropWidth= 300;
cropHeight= 350;
left_eye = [85,125];
right_eye= [200,125];

img = imread('DB1\db1_17.jpg');
imshow(img)

[left] = ginput(1);

left = round(left);

%%copy
x_point= left(1)-left_eye(1);
y_point= left(2)- left_eye(2);

% Calculate the cropping rectangle
cropRect = [x_point, y_point, cropWidth-1, cropHeight-1];

% Crop the image
croppedImage = imcrop(img, cropRect);
croppedImage= rgb2gray(croppedImage);
imwrite(croppedImage, 'DB1Cropped\db1_17.jpg');


for 
