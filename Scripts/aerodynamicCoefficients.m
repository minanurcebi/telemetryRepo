%% Calculation of Aerodynamic Coefficients
g           = 9.81;                             % gravitational acceleration (m/s^2)   
H           = 8400;                             % scale height (m)
ro0         = 1.225;                            % air density at sea level (kg/m^3)
S           = 0.55;                             % wing area (m^2)
c           = 0.19;                             % mean aerodynamic chord (m)
% ro        = ro0 * exp^(-h(i:,1)/H);           % air density (kg/m^3)

% Retrieve and assign data from dataset_struct to variables
eval(["mass"    + "=" + char(dataset_struct_name) + "mass_kg"   + ".Data;"])     % aircraft mass (kg)
eval(["thrust"  + "=" + char(dataset_struct_name) + "thrust_N_1"+ ".Data;"])     % aircraft thrust (N)
eval(["h"       + "=" + char(dataset_struct_name) + "alt_m"     + ".Data;"])     % altitude (m)
eval(["V"       + "=" + char(dataset_struct_name) + "tas_m_s"   + ".Data;"])     % true airspeed (m/s)
eval(["alpha"   + "=" + char(dataset_struct_name) + "alpha_rad" + ".Data;"])     % angle of attack (rad)      
eval(["a_x"     + "=" + char(dataset_struct_name) + "ax_m_s2"   + ".Data;"])     % acceleration in x-direction (m/s^2)  
eval(["a_y"     + "=" + char(dataset_struct_name) + "ay_m_s2"   + ".Data;"])     % acceleration in y-direction (m/s^2)  
eval(["a_z"     + "=" + char(dataset_struct_name) + "az_m_s2"   + ".Data;"])     % acceleration in z-direction (m/s^2)  

%% Lift Coefficient (CL)
[CL,~,~] = funcAeroCoeff(mass, thrust, h, V, alpha, a_x, a_z, row, g, H, S, ro0, c);

%% Drag Coefficient (CD)
[~, CD, ~] = funcAeroCoeff(mass, thrust, h, V, alpha, a_x, a_z, row, g, H, S, ro0, c);

%% Pitching Moment Coefficient (CM)
[~, ~, CM] = funcAeroCoeff(mass, thrust, h, V, alpha, a_x, a_z, row, g, H, S, ro0, c);

% Clear unnecessary variables
clearvars a_x a_y a_z alpha c g H h i mass ro0 S thrust V 
