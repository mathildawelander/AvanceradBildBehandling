function [W] = calculateWeights(A,u)
% Calculates the weights for each image using A and the top eigenvectors

W=u'*A;

end