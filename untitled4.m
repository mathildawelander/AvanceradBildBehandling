%%%%%%%%%%%%%%%%%%%%
%-----Settings-----%
addpath('EigenFaces\');
addpath('EyeMapping\');
load('feature_vectors.mat', 'W');
load('eigenvectors.mat', 'top_eigenvectors');
load('average_vector.mat', 'my');
load('FisherFaces.mat', 'F');
load('ClassWeight.mat', 'Class_weight');

%15, 14,11,9,8,7,3,1
for i = 1:16   
    filename = sprintf('DB1\\db1_%02d.jpg', i);
 try
    face = double(imread(filename));
    face= face / max(face(:));

    facegw= grayWorld(face);
    
    
    [faceSeg, topBoundary, lowerBoundary]= FaceSegmentation(facegw);
    
   
% Display the segmented face
% imshow(faceSeg);
threshold= lowerBoundary-(0.8*(lowerBoundary-topBoundary));

% % Draw a red line at the top boundary
% hold on;
% plot([1, size(faceSeg, 2)], [threshold, threshold], 'r', 'LineWidth', 2);
% hold off;

    co= ColorBasedMethod(face, (50/255));
    %imshow(co);
    ed= edgeDensityMethod(face,1, faceSeg);
    %imshow(ed)
    il= illuminationBasedMethod(face, 5, 0.60);
    %imshow(il);
    %transformera circulärt förstora blob, 
    imgilco= il & co;
    imgcoed= co & ed;
    imgiled= il & ed;

    %imshow(imgilco);
    %imshow(imgiled);
    %imshow(imgcoed);
    
    imgHybrid= imgilco | imgcoed | imgiled;
    %imshow(imgHybrid,[]);
    imgHybrid= faceSeg.*imgHybrid;
    %imshow(imgHybrid);
    
    ycbrface= rgb2ycbcr(face);
    mouthImg= mouthMap(ycbrface);
    %imshow(mouthImg.*faceSeg);
    eyePos= getEyes(imgHybrid, mouthImg, threshold);
    

    if(eyePos(1,1)< eyePos(2,1))
        leftEye= eyePos(1,:);
        rightEye= eyePos(2,:);
    else
         leftEye= eyePos(2,:);
        rightEye= eyePos(1,:);
    end
    
    
    img= CropImages(face, leftEye, rightEye);
    % fname = sprintf('AllCropped\\ex_%02d.jpg', i);
    % imwrite(img, fname);
    % 
    % figure;
    % 
    % % Display the first image in the first subplot
    % subplot(1, 2, 1);
    % imshow(face);
    % hold on;
    % plot(eyePos(:,1),eyePos(:,2), 'R+', 'MarkerSize',30);
    % hold off;
    % 
    % % Display the second image in the second subplot
    % subplot(1, 2, 2);
    % imshow(img);
    % 

    img= rgb2gray(img);
    % %imshow(img);

    img = img(:);
    %img = img-my; %For eigenfaces

    Wimg = calculateWeights(double(img),F);

    number = getClosestFace(Wimg, Class_weight);
    disp(i + " the number is " + number);
end

end

