function [imgHybrid,ed,il,co] = eyeMap(face,faceSeg)
    co= ColorBasedMethod(face, (50/255));
    ed= edgeDensityMethod(face,1, faceSeg);
    il= illuminationBasedMethod(face, 5, 0.60, faceSeg);
    imgilco= il & co;
    imgcoed= co & ed;
    imgiled= il & ed;
    imgHybrid= imgilco | imgcoed | imgiled;
    imgHybrid= faceSeg.*imgHybrid;

end