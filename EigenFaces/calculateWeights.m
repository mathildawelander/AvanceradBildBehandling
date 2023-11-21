function [W] = calculateWeights(A,u)
%UNTITLED3 Summary of this function goes here
% Calculates the weights for each image using A and the top eigenvectors

W=u'*A;

end