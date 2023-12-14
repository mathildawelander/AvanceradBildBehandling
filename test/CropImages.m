function [processed_image] = CropImages(input_image, left_eye_pos, right_eye_pos)
% Parameters
    desired_left_eye_pos = [65, 90];
    %desired_right_eye_pos = [270, 125];
    desired_distance_between_eyes = 170;
    desired_size = [340, 300]; % Height x Width

    % Calculate the rotation angle
    delta_y = right_eye_pos(2) - left_eye_pos(2);
    delta_x = right_eye_pos(1) - left_eye_pos(1);
    angle = -atan2(delta_y, delta_x);

    % Calculate the scaling factor
    current_distance_between_eyes = norm(right_eye_pos - left_eye_pos);
    scaling_factor = desired_distance_between_eyes / current_distance_between_eyes;

    % Calculate the translation vector
    translation_x = desired_left_eye_pos(1) - (scaling_factor * left_eye_pos(1) * cos(angle)) + scaling_factor * left_eye_pos(2) * sin(angle);
    translation_y = desired_left_eye_pos(2) - (scaling_factor * left_eye_pos(1) * sin(angle)) - scaling_factor * left_eye_pos(2) * cos(angle);
    translation_vector = [translation_x, translation_y];

    affine_matrix = [scaling_factor * cos(angle), scaling_factor * sin(angle), 0; ...
                     -scaling_factor * sin(angle), scaling_factor * cos(angle), 0; ...
                     translation_x, translation_y, 1];

    % Create the affine2d object
    affine_transform = affine2d(affine_matrix);

    % Apply the affine transformation to the image
    % Specify the output size and the fill value
    output_size = desired_size;
    fill_value = 0; % or any other value you want
    transformed_image = imwarp(input_image, affine_transform, 'OutputView', imref2d(output_size), 'FillValues', fill_value);

    % Crop the image
    % No need to change this part
    crop_x = desired_left_eye_pos(1) - desired_left_eye_pos(1);
    crop_y = desired_left_eye_pos(2) - desired_left_eye_pos(2);
    crop_rectangle = [crop_x, crop_y, desired_size(2), desired_size(1)];
    processed_image = imcrop(transformed_image, crop_rectangle);
end
