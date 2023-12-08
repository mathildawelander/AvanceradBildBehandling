function [outputIMG] = mouthMap(inputIMG)
Cb = inputIMG(:,:,2);
Cr = inputIMG(:,:,3);

% normaliseringsfaktor 
n = 0.95 * (0.5 * sum(Cr.^2)) / (0.5 * sum(Cr./Cb));
%imshow(inputIMG);
% Mout map formula enligt föreläsning
mouthMap = Cr.^2 .* (Cr.^2 - n * Cr./Cb).^2;
mouthMap = (mouthMap - min(mouthMap(:))) / (max(mouthMap(:)) - min(mouthMap(:)));
threshold = 0.25; %ser ok ut på 0.5
mouthMap = mouthMap > threshold;
%imshow(mouthMap);

se= strel('disk', 5);
MouthMap= imdilate(mouthMap, se);

outputIMG = MouthMap;
end

