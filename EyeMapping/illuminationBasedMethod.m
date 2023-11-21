function [returnImg] =  illuminationBasedMethod(InputImg, radius)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here


%Skapa bilder på ansiktet
face =InputImg; % Vanlig
face_eq = histeq(face);                         % Histogramkompenserad
facebw = imbinarize(rgb2gray(face_eq),0.7);       % Trösklad 85%

facebw = uint8(facebw);

meanr = mean(mean(face_eq(:,:,1).*facebw));
meang = mean(mean(face_eq(:,:,2).*facebw));
meanb = mean(mean(face_eq(:,:,3).*facebw));
meanmean = (meanr+meang+meanb)/3;

%Vi vill att alla färgkanaler ska ha samma mean av typ 170
multr = meanmean/meanr;
multg = meanmean/meang;
multb = meanmean/meanb;

face(:,:,1) = face_eq(:,:,1)*multr;
face(:,:,2) = face_eq(:,:,2)*multg;
face(:,:,3) = face_eq(:,:,3)*multb;

face_BW = rgb2gray(face);
face_BW_eq = histeq(face_BW); 

max(max(face_BW));
min(min(face_BW));



HSVface = rgb2hsv(face_eq);

% EYE MAP %
YCbCrFace = rgb2ycbcr(face_eq);

%image(ycbcr2rgb(YCbCrFace))

Y = double(YCbCrFace(:,:,1));
Cb = normalize(double(YCbCrFace(:,:,2)), "norm",1);
Cr = normalize(double(YCbCrFace(:,:,3)),"norm",1);
Cr_ = 1-Cr;

eyeMapC = (Cb.^2 + Cr_.^2 + (Cb./Cr))/3;


se = strel('disk', radius);
% Example: Dilation using the circular structuring element
dilated_image = imdilate(Y, se);

% Example: Erosion using the circular structuring element
eroded_image = imerode(Y, se);
eyemapL = dilated_image./(eroded_image+1);


andimg= eyemapL.*eyeMapC;

newimg= imdilate(andimg, se);
maxVal = max(newimg(:));
minVal = min(newimg(:));
newimg= (newimg-minVal)/(maxVal-minVal);
newimg= newimg > 0.5;

cc= bwconncomp(newimg);
stats= regionprops(cc, 'Area', 'BoundingBox','Solidity','Orientation', 'PixelIdxList');

filteredImage = false(size(newimg));
for i = 1:length(stats)
    boundingBox = stats(i).BoundingBox;
    aspectRatio = boundingBox(3) / boundingBox(4);
    if stats(i).Solidity > 0.5 && aspectRatio >= 0.8 && aspectRatio <= 4.0 ...
        && ~any(stats(i).PixelIdxList <= size(newimg, 2)) ...  % Not touching top border
        && ~any(stats(i).PixelIdxList > numel(newimg) - size(newimg, 2)) ...  % Not touching bottom border
        && ~any(mod(stats(i).PixelIdxList, size(newimg, 1)) == 1) ...  % Not touching left border
        && ~any(mod(stats(i).PixelIdxList, size(newimg, 1)) == 0) ...  % Not touching right border
        && stats(i).Orientation >= -45 && stats(i).Orientation <= 45
        filteredImage(stats(i).PixelIdxList) = true;
    end
end


returnImg=newimg ;

end