function [top_eigenvectors] = createEigenfaces(A, k)
%   Create k eigenfaces using A  

newA= A'*A;

%small v 
[eigenVector, eigenValue] = eig(newA);
u = A*eigenVector;

%Choose the best eigenvectors
[sorted_eigenvalues, index] = sort(diag(eigenValue), 'descend');
top_eigenvectors = u(:, index(1:k));

end