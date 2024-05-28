function [u, v, w] = funcAirSpeedComponents(V, alpha, beta, row)
    % This function calculates the airspeed components in the local 
    % body-fixed coordinate system.
    % 
    % Inputs:
    %   V     : True airspeed of the aircraft (m/s)
    %   alpha : Angle of attack of the aircraft (radians)
    %   beta  : Sideslip angle of the aircraft (radians)
    %   row   : Number of data points
    %
    % Outputs:
    %   u : Airspeed component along the x-axis (m/s)
    %   v : Airspeed component along the y-axis (m/s)
    %   w : Airspeed component along the z-axis (m/s)

    for j = 1:row
        % Calculate the airspeed vector in the local body-fixed coordinate system
        V_local(j,:) = V(j) .* [cos(alpha(j)) .* cos(beta(j)), ...
                                sin(beta(j)), ...
                                sin(alpha(j)) .* cos(beta(j))];
    end

    % Extract the airspeed components
    u = V_local(:, 1);  % Airspeed component along the x-axis
    v = V_local(:, 2);  % Airspeed component along the y-axis
    w = V_local(:, 3);  % Airspeed component along the z-axis
end
