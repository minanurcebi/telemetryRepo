%% Calculation of Aircraft Speed Components
% Retrieve and assign beta (sideslip angle), alpha (angle of attack), and true airspeed data from dataset_struct to variables
eval(["beta"    + "=" + char(dataset_struct_name) + "beta_rad"  + ".Data;"])     % Aircraft sideslip angle (rad)  
eval(["alpha"   + "=" + char(dataset_struct_name) + "alpha_rad" + ".Data;"])     % Aircraft angle of attack (rad)      
eval(["V"       + "=" + char(dataset_struct_name) + "tas_m_s"   + ".Data;"])     % Aircraft true airspeed (m/s)

%% Calculation of Aircraft Velocity Components in the Local Fixed Coordinate System
% Calculate the velocity components in the local fixed coordinate system using the function funcAirSpeedComponents
[u, v, w] = funcAirSpeedComponents(V, alpha, beta, row);

% Clear unnecessary variables
clearvars alpha beta V row  
