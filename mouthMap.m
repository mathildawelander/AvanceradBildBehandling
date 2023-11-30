function [outputIMG] = mouthMap(inputIMG)
Cb = double(inputIMG(:,:,2));
Cr = double(inputIMG(:,:,3));

% normaliseringsfaktor 
n = 0.95 * (0.5 * sum(Cr.^2)) / (0.5 * sum(Cr./Cb));

% Mout map formula enligt föreläsning
mouthMap = Cr.^2 .* (Cr.^2 - n * Cr./Cb).^2;
mouthMap = (mouthMap - min(mouthMap(:))) / (max(mouthMap(:)) - min(mouthMap(:)));

threshold = 0.5; %ser ok ut på 0.5
MouthMap = mouthMap > threshold;



outputIMG = MouthMap;
end

