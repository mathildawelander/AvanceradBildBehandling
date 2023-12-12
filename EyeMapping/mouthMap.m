function [outputIMG] = mouthMap(inputIMG, faceSeg)
Cb = inputIMG(:,:,2);
Cr = inputIMG(:,:,3);

% normaliseringsfaktor 
n = 0.95 * (0.5 * sum(Cr.^2)) / (0.5 * sum(Cr./Cb));
%imshow(inputIMG);
% Mout map formula enligt föreläsning
mouthMap = Cr.^2 .* (Cr.^2 - n * Cr./Cb).^2;
mouthMap = (mouthMap - min(mouthMap(:))) / (max(mouthMap(:)) - min(mouthMap(:)));


threshold = 0.25; %ser ok ut på 0.5
MouthMap = mouthMap > threshold;
imshow(MouthMap);

se= strel('disk', 5);
MouthMap= imdilate(MouthMap, se);

if getMouth(MouthMap.*faceSeg)==-1
mouthImg= mouthMap.*faceSeg;
 mouthImg= mouthImg/max(mouthImg(:));
     mouthImg= mouthImg>0.5;

se= strel('disk', 5);
MouthMap= imdilate(mouthImg, se);
end

outputIMG = MouthMap;
end


