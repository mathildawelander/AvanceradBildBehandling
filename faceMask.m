function faceMask = faceMask(rgbImage)
 
    hsvImage = rgb2hsv(rgbImage);
    
    hueChannel = hsvImage(:, :, 1);
    satChannel = hsvImage(:, :, 2);
    valChannel = hsvImage(:, :, 3);

    skinHueRange = [0.01, 0.1];
    skinSaturationRange = [0.2, 0.6];
    skinValueRange = [0.4, 1];

    skinMask = (hueChannel >= skinHueRange(1) & hueChannel <= skinHueRange(2)) & ...
               (satChannel >= skinSaturationRange(1) & satChannel <= skinSaturationRange(2)) & ...
               (valChannel >= skinValueRange(1) & valChannel <= skinValueRange(2));

    % morphological operation
    % se = strel('disk', 5);
    % skinMask = imopen(skinMask, se);
    faceMask = skinMask;
end

