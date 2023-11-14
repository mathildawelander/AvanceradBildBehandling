function [top_eigenvectors] = createEigenfaces(A)
%UNTITLED2 Summary of this function goes here
%   Create eigenfaces using A and return 

%how many eigenvectors do we want
k=5; 
newA= A'*A;

%small v 
[eigenVector, eigenValue] = eig(newA);
u = A*eigenVector;

%Choose the best eigenvectors
% Assuming k is the number of top eigenvectors you want to keep
[sorted_eigenvalues, index] = sort(diag(eigenValue), 'descend');
top_eigenvectors = u(:, index(1:k));

end