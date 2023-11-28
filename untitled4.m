%%%%%%%%%%%%%%%%%%%%
%-----Settings-----%
addpath('EigenFaces\');
addpath('EyeMapping\');
load('feature_vectors.mat', 'W');
load('eigenvectors.mat', 'top_eigenvectors');
load('average_vector.mat', 'my');
load('FisherFaces.mat', 'F');
load('ClassWeight.mat', 'Class_weight');


eyeWidth = 260;   %Distans (px) från sidan till närmsta öga horisontell längd
eyeHeight = 150;  %Distans (px) från topp av bild till närmsta öga

debug = true;
%------------------%4
for i = 1:16
    
if i >9
    filename = sprintf('DB1\\db1_%d.jpg', i);
else
    %filename=sprintf('test\\db1_02.jpg', i);
    filename = sprintf('DB1\\db1_0%d.jpg', i);
end
%Skapa bilder på ansiktet
face = imread(filename); % Vanlig

facegw= grayWorld(face);

faceSeg= FaceSegmentation(facegw);

co= ColorBasedMethod(face, 40);
ed= edgeDensityMethod(face,2);
il= illuminationBasedMethod(face, 5);

imgilco= il & co;
imgcoed= co & ed;
imgiled= il & ed;

imgHybrid= imgilco | imgcoed | imgiled;
imgHybrid= faceSeg.*imgHybrid;
eyePos= getEyes(imgHybrid);

if(eyePos(1,1)< eyePos(2,1))
    leftEye= eyePos(1,:);
    rightEye= eyePos(2,:);
else
     leftEye= eyePos(2,:);
    rightEye= eyePos(1,:);
end

img= CropImages(face, leftEye, rightEye);


% %imshow(img);
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

img= rgb2gray(img);

img = uint8(img(:));
%img = img-my;

Wimg = calculateWeights(double(img),F);
% Wimg= Wimg/norm(Wimg);
% newim= zeros(350*300,1);
% for j=1:15
%     ga= (Wimg(j)'*F(:,j));
%     newim= newim+ga;
% end
% 
% newim = uint8(newim);
% newim= reshape(newim, [350,300]);
% imshow(newim);

number = getClosestFace(Wimg, Class_weight);
disp(number);

end

