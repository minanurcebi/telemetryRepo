function [CL, CD, CM] = aerodynamicCoefficients(dataset_struct)
    % Constants
    g = 9.81;        % gravitational acceleration (m/s^2)   
    H = 8400;        % scale height (m)
    ro0 = 1.225;     % air density at sea level (kg/m^3)
    S = 0.55;        % wing area (m^2)
    c = 0.19;        % mean aerodynamic chord (m)

    % Retrieve and assign data from dataset_struct to variables
    mass = dataset_struct.mass_kg.Data;     % aircraft mass (kg)
    thrust = dataset_struct.thrust_N_1.Data; % aircraft thrust (N)
    h = dataset_struct.alt_m.Data;         % altitude (m)
    V = dataset_struct.tas_m_s.Data;       % true airspeed (m/s)
    alpha = dataset_struct.alpha_rad.Data; % angle of attack (rad)      
    a_x = dataset_struct.ax_m_s2.Data;     % acceleration in x-direction (m/s^2)  
    a_y = dataset_struct.ay_m_s2.Data;     % acceleration in y-direction (m/s^2)  
    a_z = dataset_struct.az_m_s2.Data;     % acceleration in z-direction (m/s^2)  
    
    % Calculate the aerodynamic coefficients
    [CL, CD, CM] = funcAeroCoeff(mass, thrust, h, V, alpha, a_x, a_z, length(mass), g, H, S, ro0, c);

    % Assign the results to the base workspace
%     assignin('base', 'CL', CL);
%     assignin('base', 'CD', CD);
%     assignin('base', 'CM', CM);
end
