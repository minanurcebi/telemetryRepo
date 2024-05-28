%% Conversion from Quaternions to Euler Angles
% Retrieve and assign quaternion components from dataset_struct to variables
eval(["q_w" + "=" + char(dataset_struct_name) + "quat_e0"  + ".Data;"])     % orientation quaternion W component (scalar)
eval(["q_x" + "=" + char(dataset_struct_name) + "quat_ex"  + ".Data;"])     % orientation quaternion X component  
eval(["q_y" + "=" + char(dataset_struct_name) + "quat_ey"  + ".Data;"])     % orientation quaternion Y component   
eval(["q_z" + "=" + char(dataset_struct_name) + "quat_ez"  + ".Data;"])     % orientation quaternion Z component   

%% Yaw: rotation around the z-axis (psi)
[YAW,~,~] = funcToEuler(q_w, q_x, q_y, q_z, row);

%% Pitch: rotation around the y-axis (theta)
[~,PITCH,~] = funcToEuler(q_w, q_x, q_y, q_z, row);

%% Roll: rotation around the x-axis (phi)
[~,~,ROLL] = funcToEuler(q_w, q_x, q_y, q_z, row);

% Clear unnecessary variables
clearvars q_w q_x q_y q_z
