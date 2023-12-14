function [eyeImg,ed,il,co] = eyeMap(face,faceSeg)
    %Do the 3 different methods
    co= ColorBasedMethod(face, (50/255));
    ed= edgeDensityMethod(face,1, faceSeg);
    il= illuminationBasedMethod(face, 5, 0.60, faceSeg);
    %Combine them
    imgilco= il & co;
    imgcoed= co & ed;
    imgiled= il & ed;
    %Get the final result 
    eyeImg= imgilco | imgcoed | imgiled;
    eyeImg= faceSeg.*eyeImg;
end