%%%%%%%%%%%%%%%%%%%%
%-----Settings-----%
addpath('EigenFaces\');
addpath('EyeMapping\');
load('feature_vectors.mat', 'W');
load('eigenvectors.mat', 'top_eigenvectors');
load('average_vector.mat', 'my');
load('FisherFaces.mat', 'F');
load('ClassWeight.mat', 'Class_weight');

for i = 1:16
    filename = sprintf('DB1\\db1_%02d.jpg', i);
 try
    face = imread(filename);
    
    facegw= grayWorld(face);
    
    faceSeg= FaceSegmentation(facegw);
    %imshow(faceSeg)
    
    co= ColorBasedMethod(face, 40);
    ed= edgeDensityMethod(face,2);
    il= illuminationBasedMethod(face, 5);
    
    imgilco= il & co;
    imgcoed= co & ed;
    imgiled= il & ed;
    
    imgHybrid= imgilco | imgcoed | imgiled;
    imgHybrid= faceSeg.*imgHybrid;
    %imshow(imgHybrid);
    
    ycbrface= rgb2ycbcr(face);
    mouthImg= mouthMap(ycbrface);
    %imshow(mouthImg.*faceSeg);
    eyePos= getEyes(imgHybrid, mouthImg);
    
    if(eyePos(1,1)< eyePos(2,1))
        leftEye= eyePos(1,:);
        rightEye= eyePos(2,:);
    else
         leftEye= eyePos(2,:);
        rightEye= eyePos(1,:);
    end
    
    img= CropImages(face, leftEye, rightEye);
    fname = sprintf('AllCropped\\db1_%02d.jpg', i);
    %imwrite(img, fname);
    % imshow(img);

    figure;

    % Display the first image in the first subplot
    subplot(1, 2, 1);
    imshow(face);
    hold on;
    plot(eyePos(:,1),eyePos(:,2), 'R+', 'MarkerSize',30);
    hold off;

    % Display the second image in the second subplot
    subplot(1, 2, 2);
    imshow(img);
    
    img= rgb2gray(img);
    %imshow(img);
    
    img = img(:);
    %img = img-my; For eigenfaces
    
    Wimg = calculateWeights(double(img),F);
    
    number = getClosestFace(Wimg, Class_weight);
    disp(number);
end

end

