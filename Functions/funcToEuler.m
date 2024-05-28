function [yaw, pitch, roll] = funcToEuler(quat_e0, quat_ex, quat_ey, quat_ez, row)
    % Converts quaternions to Euler angles (yaw, pitch, roll)
    % yaw   : Rotation around the z-axis (psi)
    % pitch : Rotation around the y-axis (theta)
    % roll  : Rotation around the x-axis (phi)
    %
    % Inputs:
    %   quat_e0 : W component of the quaternion (scalar)
    %   quat_ex : X component of the quaternion
    %   quat_ey : Y component of the quaternion
    %   quat_ez : Z component of the quaternion
    %   row     : Number of data points
    %
    % Outputs:
    %   yaw   : Euler angle for rotation around the z-axis (radians)
    %   pitch : Euler angle for rotation around the y-axis (radians)
    %   roll  : Euler angle for rotation around the x-axis (radians)

    % Assign quaternion components to local variables
    qw = quat_e0;
    qx = quat_ex;
    qy = quat_ey;
    qz = quat_ez;

    for j = 1:row
        % Calculate the yaw (psi) angle from the quaternion components
        yaw_tmp(j, 1) = atan2(2 * (qw(j) .* qz(j) + qx(j) .* qy(j)), ...      % Yaw (psi)
                              1 - 2 * ((qy(j).^2) + (qz(j).^2)));                            
        % Calculate the pitch (theta) angle from the quaternion components
        pitch_tmp(j, 1) = asin(2 * (qw(j) .* qy(j) - qz(j) .* qx(j)));        % Pitch (theta)
        % Calculate the roll (phi) angle from the quaternion components
        roll_tmp(j, 1) = atan2(2 * (qw(j) .* qx(j) + qy(j) .* qz(j)), ...     % Roll (phi)
                              1 - 2 * ((qx(j).^2) + (qy(j).^2)));                           
    end
    
    % Assign the calculated Euler angles to the output variables
    yaw   = yaw_tmp;
    pitch = pitch_tmp;
    roll  = roll_tmp;
end
