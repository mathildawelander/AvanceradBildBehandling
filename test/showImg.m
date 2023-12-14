function [] = showImg(face, eyePos, img)
    %figure;

    % Display the first image in the first subplot
    %subplot(1, 2, 1);
    imshow(face);

    hold on;
    plot(eyePos(:, 1), eyePos(:, 2), 'r+', 'MarkerSize', 20);
    hold off;

    % Display the second image in the second subplot (you need to define 'img')
    %subplot(1, 2, 2);
    % Assuming 'img' is the second image you want to display
    %imshow(img);

end
