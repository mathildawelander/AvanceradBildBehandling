% function processed_image = CropImages(input_image, left_eye_pos, right_eye_pos)
% % Parameters
%     desired_left_eye_pos = [85, 125];
%     desired_right_eye_pos = [200, 125];
%     desired_distance_between_eyes = norm(desired_right_eye_pos - desired_left_eye_pos);
%     desired_size = [350, 300]; % Height x Width
% 
%     % Calculate the rotation angle
%     delta_y = right_eye_pos(2) - left_eye_pos(2);
%     delta_x = right_eye_pos(1) - left_eye_pos(1);
%     angle = atan2(delta_y, delta_x);
% 
%     % Translate the image so left eye is at origin
%     translation_to_origin = -left_eye_pos';
%     im= input_image(:,:,1);
%     translated_image = imtranslate(im, translation_to_origin, 'OutputView','full');
% imshow(translated_image);
%     % Rotate the image around the origin
%     rotated_image = imrotate(translated_image, -rad2deg(angle), 'bicubic');
% 
%     % Translate the image back
%     translated_back_image = imtranslate(rotated_image, -translation_to_origin);
%     imshow(translated_back_image);
%     % Calculate new eye positions after transformation
%     % (These will be needed for scaling and cropping)
%     rotation_matrix = [cos(angle), -sin(angle); sin(angle), cos(angle)];
%     new_left_eye_pos = rotation_matrix * (left_eye_pos - left_eye_pos); % Should be [0,0] after rotation
%     new_right_eye_pos = rotation_matrix * (right_eye_pos - left_eye_pos);
% 
%     % Calculate scaling factor
%     current_distance_between_eyes = norm(new_right_eye_pos - new_left_eye_pos);
%     scaling_factor = desired_distance_between_eyes / current_distance_between_eyes;
% 
%     % Resize the image
%     scaled_image = imresize(translated_back_image, scaling_factor);
% imshow(scaled_image);
% 
%     % Calculate new eye positions after scaling
%     scaled_left_eye_pos = new_left_eye_pos * scaling_factor;
%     scaled_right_eye_pos = new_right_eye_pos * scaling_factor;
% 
%     % Calculate the top-left corner for cropping
%     crop_x = scaled_left_eye_pos(1) - desired_left_eye_pos(1);
%     crop_y = scaled_left_eye_pos(2) - desired_left_eye_pos(2);
%     crop_rectangle = [crop_x, crop_y, desired_size(2), desired_size(1)];
% 
%     % Crop the image
%     processed_image = imcrop(scaled_image, crop_rectangle);
% end

function processed_image = CropImages(input_image, left_eye_pos, right_eye_pos)
% Parameters
    desired_left_eye_pos = [85, 125];
    desired_right_eye_pos = [200, 125];
    desired_distance_between_eyes = norm(desired_right_eye_pos - desired_left_eye_pos);
    desired_size = [350, 300]; % Height x Width

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

    % Create the affine transformation matrix
    % The matrix has the form: [a b 0; c d 0; e f 1]
    % where a = scaling_factor * cos(angle)
    %       b = scaling_factor * sin(angle)
    %       c = -scaling_factor * sin(angle)
    %       d = scaling_factor * cos(angle)
    %       e = translation_x
    %       f = translation_y
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
