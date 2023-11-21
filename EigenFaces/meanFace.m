load('feature_vectors.mat', 'W');
load('eigenvectors.mat', 'top_eigenvectors');
load('average_vector.mat', 'my');

img = imread('DB1Cropped\db1_06.jpg');
img = uint8(img(:));
img = img-my;

Wimg = calculateWeights(double(img),top_eigenvectors);

number = getClosestFace(Wimg, W);
disp(number)



