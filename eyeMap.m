function [outputIMG] = eyeMap(inputIMG, face_eq)
%EYEMAP 
%YCbCrFace = rgb2ycbcr(face_eq);


Y = double(inputIMG(:,:,1));
Cb = normalize(double(inputIMG(:,:,2)), "norm",1);
Cr = normalize(double(inputIMG(:,:,3)),"norm",1);
Cr_ = 1-Cr;

% This is weird. should it be purple?
imshow(ycbcr2rgb(inputIMG));

imshowpair(Y, (face_eq)) % Y 
imshowpair(Cb, (face_eq)) % Cb 
imshowpair(Cr, (face_eq)) % Cr 
imshow(Cb, [])
imshow(Cr, [])

eyeMapC = (Cb.^2 + Cr_.^2 + (Cb./Cr))/3;

radius = 10;  
se = strel('disk', radius);

% Dilation 
dilated_image = imdilate(Y, se);

% Erosion
eroded_image = imerode(Y, se);
eyemapL = dilated_image./(eroded_image+1);

imshow(eyemapL, []);

andimg= eyemapL.*eyeMapC;
newimg= imdilate(andimg, se);

outputIMG = newimg;
end

