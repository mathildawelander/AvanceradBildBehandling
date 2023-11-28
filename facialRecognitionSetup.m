numImages = 16; 
vectorSize = 105000; % 300x350
numEigenfaces = 8;
vectors = zeros(vectorSize, numImages, 'uint8');

for i = 1:numImages
    filename = sprintf('Cropped\\db1_%02d.jpg', i);
    
    img = uint8(rgb2gray(imread(filename)));
    
    vectors(:, i) = img(:);
end

my = avarageFaceVector(vectors);

A = subtractMean(vectors, my);
top_eigenvectors= createEigenfaces(A, numEigenfaces);

W = calculateWeights(A, top_eigenvectors);
% save('feature_vectors.mat', 'W');
% save('eigenvectors.mat', 'top_eigenvectors');
% save('average_vector.mat', 'my');



