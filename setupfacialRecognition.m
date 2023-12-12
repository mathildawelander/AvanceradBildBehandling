numImages = 52; 
vectorSize = 105000; % 300x350
numEigenfaces = 36;
c= 16;
vectors = zeros(vectorSize, numImages, 'uint8');

my=[];
allVectors=[];
myForEachFace=[];
numImagesArr=[];

for i = 1:numImages
    filename = sprintf('AllCropped\\db1_%02d.jpg', i);
    
    filename1 = sprintf('AllCropped\\bl_%02d.jpg', i);
    % 
    filename2 = sprintf('AllCropped\\cl_%02d.jpg', i);

    filename3 = sprintf('AllCropped\\ex_%02d.jpg', i);

    filename4 = sprintf('AllCropped\\il_%02d.jpg', i);
    
    List = [];

    try
    img= double(rgb2gray(imread(filename)));
    img= img/max(img(:));
    img=img(:);
    List= [List,img];
    end
    try
    img= double(rgb2gray(imread(filename1)));
    img= img/max(img(:));
    img=img(:);
    List= [List,img];
    end
    try
    img= double(rgb2gray(imread(filename2)));
    img= img/max(img(:));
    img=img(:);
    List= [List,img];
    end
    try
    img= double(rgb2gray(imread(filename3)));
    img= img/max(img(:));
    img=img(:);
    List= [List,img];
    end
    try
    img= double(rgb2gray(imread(filename4)));
    img= img/max(img(:));
    img=img(:);
    List= [List,img];
    end
    
    myface=avarageFaceVector(List);
    myForEachFace = [myForEachFace,myface];
    allVectors=[allVectors,List];
    numImagesArr=[numImagesArr,size(List,2)];

end

myForEachFace=myForEachFace;
AllImagesMy = avarageFaceVector(allVectors);

A = subtractMean(allVectors, AllImagesMy);

top_eigenvectors= createEigenfaces(A, numEigenfaces);

W = calculateWeights(A, top_eigenvectors);

projectedmyForEachFace= calculateWeights(myForEachFace, top_eigenvectors);
projectedAllImagesMy= calculateWeights(AllImagesMy, top_eigenvectors);
projectedAllImages= calculateWeights(double(allVectors), top_eigenvectors);


Sb= zeros(numEigenfaces,numEigenfaces);
for i=1:16
    myimy=projectedmyForEachFace(i)-projectedAllImagesMy;
    myimyT= myimy';
    plus = (numImagesArr(i).*myimy.*myimyT);
    Sb= Sb+plus;
end

slotcount=1;
sw= zeros(numEigenfaces,numEigenfaces);

for i=1:16
    traningImg= projectedAllImages(:, slotcount:(slotcount+numImagesArr(i)-1));
    Ai=traningImg-projectedmyForEachFace(i);
    sw=sw+Ai*Ai';

    slotcount=slotcount+numImagesArr(i);
end

[eigenVector, eigenValue]= eig(Sb,sw);
[sorted_eigenvalues, index] = sort(diag(eigenValue), 'descend');
selected_eigenVectors = eigenVector(:, index(1:(c-1)));
U= selected_eigenVectors;
V= top_eigenvectors;

F= V*U;
Class_weight= F'*myForEachFace;

figure;

for i = 1:15
    subplot(4, 4, i);  % 4x4 grid, place the i-th image in the grid
    img = reshape(F(:, i), [350, 300]);
    imshow(img, []);
end

sgtitle('All Images');  % Add a title to the entire figure


save('FisherFaces.mat', 'F');
save('ClassWeight.mat', 'Class_weight');


