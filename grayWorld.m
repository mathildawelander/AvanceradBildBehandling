function [outputImg] = grayWorld(inputImg)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%gain for red and green channel
face_eq = inputImg;                  % Histogramkompenserad
%facebw = imbinarize(rgb2gray(face_eq),0.7);       % Trösklad 85%

facebw = uint8(rgb2gray(face_eq));

% meanr = mean(mean(face_eq(:,:,1).*facebw));
% meang = mean(mean(face_eq(:,:,2).*facebw));
% meanb = mean(mean(face_eq(:,:,3).*facebw));
% meanmean = (meanr+meang+meanb)/3;

meanr = mean(face_eq(:,:,1), 'all');
meang = mean(face_eq(:,:,2), 'all');
meanb = mean(face_eq(:,:,3), 'all');

alpha= meang/meanr;
beta= meang/meanb;

% %Vi vill att alla färgkanaler ska ha samma mean av typ 170
% multr = meanmean/meanr;
% multg = meanmean/meang;
% multb = meanmean/meanb;

face(:,:,1) = face_eq(:,:,1)*alpha;
face(:,:,2) = face_eq(:,:,2);
face(:,:,3) = face_eq(:,:,3)*beta;

outputImg= face;

end