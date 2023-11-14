img = imread('DB1Cropped\db1_01.jpg');
v1 = uint64(img(:));

img = imread('DB1Cropped\db1_02.jpg');
v2 = uint64(img(:));

img = imread('DB1Cropped\db1_03.jpg');
v3 = uint64(img(:));

img = imread('DB1Cropped\db1_04.jpg');
v4 = uint64(img(:));

img = imread('DB1Cropped\db1_05.jpg');
v5 = uint64(img(:));

img = imread('DB1Cropped\db1_06.jpg');
v6 = uint64(img(:));

img = imread('DB1Cropped\db1_07.jpg');
v7 = uint64(img(:));

img = imread('DB1Cropped\db1_08.jpg');
v8 = uint64(img(:));

img = imread('DB1Cropped\db1_09.jpg');
v9 = uint64(img(:));

img = imread('DB1Cropped\db1_10.jpg');
v10 = uint64(img(:));

img = imread('DB1Cropped\db1_11.jpg');
v11 = uint64(img(:));

img = imread('DB1Cropped\db1_12.jpg');
v12 = uint64(img(:));

img = imread('DB1Cropped\db1_13.jpg');
v13 = uint64(img(:));

img = imread('DB1Cropped\db1_14.jpg');
v14 = uint64(img(:));

img = imread('DB1Cropped\db1_15.jpg');
v15 = uint64(img(:));

img = imread('DB1Cropped\db1_16.jpg');
v16 = uint64(img(:));


data= [v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13, v14,v15,v16];
my= avarageFaceVector(data);

%img  = reshape(my, [], 300);
%reshape(my, 300, 350);
%img= uint8(img);
%imshow(img)

A= subtractMean(data, my);
top_eigenvectors= createEigenfaces(A);

%img  = reshape(top_eigenvectors(:,5), [], 300);
%img= uint8(img);
%imshow(img);

%this we want to save
W= calculateWeights(A, top_eigenvectors);

%"real function"
img= imread('DB1Cropped\db1_04.jpg');
img= uint64(img(:));
img= img-my;

Wimg= calculateWeights( double(img),top_eigenvectors);

number=getClosestFace(Wimg, W);



