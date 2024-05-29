function [YAW, PITCH, ROLL] = quaternions2euler(dataset_struct)
    % Retrieve and assign quaternion components from dataset_struct to variables
    q_w = dataset_struct.quat_e0.Data;     % orientation quaternion W component (scalar)
    q_x = dataset_struct.quat_ex.Data;     % orientation quaternion X component  
    q_y = dataset_struct.quat_ey.Data;     % orientation quaternion Y component   
    q_z = dataset_struct.quat_ez.Data;     % orientation quaternion Z component   
    
    % Get the number of data points
    row = length(q_w);

    % Calculate the Euler angles
    [YAW, ~, ~] = funcToEuler(q_w, q_x, q_y, q_z, row);
    [~, PITCH, ~] = funcToEuler(q_w, q_x, q_y, q_z, row);
    [~, ~, ROLL] = funcToEuler(q_w, q_x, q_y, q_z, row);

    % Assign the results to the base workspace
%     assignin('base', 'YAW', YAW);
%     assignin('base', 'PITCH', PITCH);
%     assignin('base', 'ROLL', ROLL);
end