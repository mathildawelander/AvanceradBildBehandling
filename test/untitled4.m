%%%%%%%%%%%%%%%%%%%%
%-----Settings-----%
addpath('Recognition_fisherfaces\');
addpath('EyeMapping\');
load('data/FisherFaces.mat', 'F');
load('data/ClassWeight.mat', 'Class_weight');

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
   correct=0;
    wrong=0;
for i = 1:16   

 
    filename = sprintf('DB1\\db1_%02d.jpg', i);
 try
    face = double(imread(filename));
    face= face/max(face(:));

t= imread(filename);
id= tnm034(t);
    facegw= grayWorld(face);
    [faceSeg, topBoundary, lowerBoundary]= FaceSegmentation(facegw);
    
    imshow(face.*faceSeg);

    threshold= lowerBoundary-(0.8*(lowerBoundary-topBoundary));
    [imgHybrid,ed,il,co]= eyeMap(face, faceSeg);

    mouthImg= mouthMap(face, faceSeg);
    pos=getMouth(mouthImg.*faceSeg);

    
    imshow(face);

    hold on;
    plot(pos(1), pos(2), 'g+', 'MarkerSize', 20);
    hold off;

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
    
    if i==number
correct=correct+1;
else
    wrong= wrong+1;
    end

end



end
    disp(" correct is " + correct);
    disp(" wront is " + wrong);

