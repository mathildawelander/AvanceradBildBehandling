function [outputImg] = grayWorld(inputImg)
    % Calculate the mean values for each color channel
    meanRed = mean(inputImg(:,:,1), 'all');
    meanGreen = mean(inputImg(:,:,2), 'all');
    meanBlue = mean(inputImg(:,:,3), 'all');

    % Compute scaling factors for each color channel
    alpha = meanGreen / meanRed;
    beta = meanGreen / meanBlue;

    % Apply gray world assumption to balance color channels
    balancedImage(:,:,1) = inputImg(:,:,1) * alpha;
    balancedImage(:,:,2) = inputImg(:,:,2);
    balancedImage(:,:,3) = inputImg(:,:,3) * beta;

    % Output the balanced image
    outputImg = balancedImage;
end
