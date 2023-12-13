%%%%%%%%%%%%%%%%%%%%
%-----Settings-----%
addpath('EigenFaces\');
addpath('EyeMapping\');
load('feature_vectors.mat', 'W');
load('eigenvectors.mat', 'top_eigenvectors');
load('average_vector.mat', 'my');
load('FisherFaces.mat', 'F');
load('ClassWeight.mat', 'Class_weight');

%DB1, Total: 16 
    % Id incorrect guesses: 14
%DB2_bl, Total: 9
    % Id incorrect guesses: 5, 6, 10
%DB2_cl, Total: 16 
%DB2_ex Total: 7
    % Id could not find eyes: 4, 7
%DB2_il Total: 6
    % Id incorrect guesses: 1, 9
    % Id could not find eyes:  8, 16

for i = 1:16   
    filename = sprintf('DB2\\cl_%02d.jpg', i);
 try
    face = double(imread(filename));
    face= face/max(face(:));

    facegw= grayWorld(face);
    [faceSeg, topBoundary, lowerBoundary]= FaceSegmentation(facegw);
    
    threshold= lowerBoundary-(0.8*(lowerBoundary-topBoundary));
    [imgHybrid,ed,il,co]= eyeMap(face, faceSeg);

    mouthImg= mouthMap(face, faceSeg);
    
    eyePos= getEyes(imgHybrid, mouthImg, threshold, il, co);

    if(eyePos(1,1)< eyePos(2,1))
        leftEye= eyePos(1,:);
        rightEye= eyePos(2,:);
    else
         leftEye= eyePos(2,:);
         rightEye= eyePos(1,:);
    end
    img= CropImages(face, leftEye, rightEye);
    % fname = sprintf('AllCropped\\db1_%02d.jpg', i);
    % imwrite(img, fname);
    
    %showImg(face, eyePos, img);

    img= rgb2gray(img);
    img = img(:);
    Wimg = calculateWeights(img,F);
    number = getClosestFace(Wimg, Class_weight);
    disp(i + " the number is " + number);
end

end

