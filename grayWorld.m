function [outputImg] = grayWorld(inputImg)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

meanr = mean(inputImg(:,:,1), 'all');
meang = mean(inputImg(:,:,2), 'all');
meanb = mean(inputImg(:,:,3), 'all');

alpha= meang/meanr;
beta= meang/meanb;

face(:,:,1) = inputImg(:,:,1)*alpha;
face(:,:,2) = inputImg(:,:,2);
face(:,:,3) = inputImg(:,:,3)*beta;

outputImg= face;
end