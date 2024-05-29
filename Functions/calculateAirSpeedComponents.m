function [u, v, w] = calculateAirSpeedComponents(dataset_struct)
    % Retrieve and assign beta (sideslip angle), alpha (angle of attack), and true airspeed data from dataset_struct to variables
    beta = dataset_struct.beta_rad.Data;     % Aircraft sideslip angle (rad)  
    alpha = dataset_struct.alpha_rad.Data;   % Aircraft angle of attack (rad)      
    V = dataset_struct.tas_m_s.Data;         % Aircraft true airspeed (m/s)
    
    % Get the number of data points
    row = length(beta);

    % Calculate the velocity components in the local fixed coordinate system using the function funcAirSpeedComponents
    [u, v, w] = funcAirSpeedComponents(V, alpha, beta, row);

    % Assign the results to the base workspace
%     assignin('base', 'u', u);
%     assignin('base', 'v', v);
%     assignin('base', 'w', w);
end
