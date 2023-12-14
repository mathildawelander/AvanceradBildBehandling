numImages = 52; 
vectorSize = 105000; % 300x350
numEigenfaces = 36;
c = 16;
vectors = zeros(vectorSize, numImages, 'uint8');

myForEachFace = [];
allVectors = [];
numImagesArr = [];

% Loop through all images
for i = 1:numImages
    % Generate filenames for different databases
    filenames = {
        sprintf('AllCropped\\db1_%02d.jpg', i),
        sprintf('AllCropped\\bl_%02d.jpg', i),
        sprintf('AllCropped\\cl_%02d.jpg', i),
        sprintf('AllCropped\\ex_%02d.jpg', i),
        sprintf('AllCropped\\il_%02d.jpg', i)
    };
    
    List = [];
    
    % Process each image for the current person
    for j = 1:numel(filenames)
        try
            img = double(rgb2gray(imread(filenames{j})));
            img = img / max(img(:));
            img = img(:);
            List = [List, img];
        catch
            % Skip if the image loading fails
        end
    end
    
    % Calculate average face vector for the current person
    myface = avarageFaceVector(List);
    myForEachFace = [myForEachFace, myface];
    allVectors = [allVectors, List];
    numImagesArr = [numImagesArr, size(List, 2)];
end

myForEachFace = myForEachFace;
AllImagesMy = avarageFaceVector(allVectors);

% Subtract mean from all vectors
A = subtractMean(allVectors, AllImagesMy);

% Create top eigenfaces
top_eigenvectors = createEigenfaces(A, numEigenfaces);

% Calculate weights for each image
W = calculateWeights(A, top_eigenvectors);

% Project the average face vector and all images onto the top eigenfaces
projectedmyForEachFace = calculateWeights(myForEachFace, top_eigenvectors);
projectedAllImagesMy = calculateWeights(AllImagesMy, top_eigenvectors);
projectedAllImages = calculateWeights(double(allVectors), top_eigenvectors);

% Compute between-class scatter matrix
Sb = zeros(numEigenfaces, numEigenfaces);
for i = 1:c
    myimy = projectedmyForEachFace(i) - projectedAllImagesMy;
    myimyT = myimy';
    plus = (numImagesArr(i) * myimy * myimyT);
    Sb = Sb + plus;
end

slotcount = 1;
sw = zeros(numEigenfaces, numEigenfaces);

% Compute within-class scatter matrix
for i = 1:c
    trainingImg = projectedAllImages(:, slotcount:(slotcount + numImagesArr(i) - 1));
    Ai = trainingImg - projectedmyForEachFace(i);
    sw = sw + Ai * Ai';
    slotcount = slotcount + numImagesArr(i);
end

% Compute Fisherfaces
[eigenVector, eigenValue] = eig(Sb, sw);
[sorted_eigenvalues, index] = sort(diag(eigenValue), 'descend');
selected_eigenVectors = eigenVector(:, index(1:(c - 1)));
U = selected_eigenVectors;
V = top_eigenvectors;
F = V * U;
Class_weight = F' * myForEachFace;

% Visualize the average face for each person
figure;
for i = 1:c
    subplot(4, 4, i);
    img = reshape(myForEachFace(:, i), [340, 300]);
    imshow(img, []);
end

% Save the computed Fisherfaces and class weights
save('data/FisherFaces.mat', 'F');
save('data/ClassWeight.mat', 'Class_weight');
