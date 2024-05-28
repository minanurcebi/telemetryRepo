function RESULTS = mainFunction()
    % Main function to run various scripts and store the results
    % in the RESULTS structure.

    % Add paths to the necessary function and script directories
    addpath('Functions\')
    addpath('Scripts\')

    % Run the necessary scripts to perform calculations

    % Convert CSV data to a structured format with timeseries
    run('csv2struct.m')
    
    % Calculate aerodynamic coefficients (CL, CD, CM)
    run('aerodynamicCoefficients.m')
    
    % Convert quaternions to Euler angles (yaw, pitch, roll)
    run('quaternions2euler.m')
    
    % Convert latitude, longitude, and altitude to NED coordinates
    run('lla2nedCoords.m')
    
    % Calculate airspeed components (u, v, w)
    run('calculateAirSpeedComponents.m')
    
    % Store the results in the RESULTS structure
    % Retrieve the time data from the dataset structure
    Time = eval([char(dataset_struct_name) + "time_sn" + ".Data;"]);

    % Store aerodynamic coefficients in the RESULTS structure
    RESULTS.CL = timeseries(CL, Time);
    RESULTS.CD = timeseries(CD, Time);
    RESULTS.CM = timeseries(CM, Time);

    % Store Euler angles in the RESULTS structure
    RESULTS.YAW = timeseries(YAW, Time);
    RESULTS.PITCH = timeseries(PITCH, Time);
    RESULTS.ROLL = timeseries(ROLL, Time);

    % Store NED coordinates in the RESULTS structure
    RESULTS.LATITUDE = timeseries(LATITUDE, Time);
    RESULTS.LONGITUDE = timeseries(LONGITUDE, Time);
    RESULTS.ALTITUDE = timeseries(ALTITUDE, Time);

    % Store airspeed components in the RESULTS structure
    RESULTS.u = timeseries(u, Time);
    RESULTS.v = timeseries(v, Time);
    RESULTS.w = timeseries(w, Time);
    
    % Clear variables to free up memory
    clearvars scriptname scriptname2 scriptname3 scriptname4 scriptname5 CL CD CM ...
    YAW PITCH ROLL LATITUDE LONGITUDE ALTITUDE u v w Time dataset_struct_name

end