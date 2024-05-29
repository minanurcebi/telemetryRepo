function [LATITUDE, LONGITUDE, ALTITUDE] = lla2nedCoords(dataset_struct, dataset_struct_name)
    % Retrieve and assign latitude, longitude, and altitude data from dataset_struct to variables
    latitude = dataset_struct.lat_rad.Data;     % Latitude  
    longitude = dataset_struct.lon_rad.Data;    % Longitude   
    altitude = dataset_struct.alt_m.Data;       % Altitude  
    
    % Get the number of data points
    row = length(latitude);

    % Use the first point as the reference for NED conversion
    latLonBase = [latitude(1), longitude(1), altitude(1)]; % Take the first point as reference

    % Convert each latitude, longitude, and altitude point to NED coordinates
    ned_xyz = zeros(row, 3); % Preallocate NED coordinates array
    for i = 1:row
        ned_xyz(i, :) = lla2ned_0([latitude(i), longitude(i), altitude(i)], ...
                                           latLonBase, ...
                                           "ellipsoid"); 
    end

    % Extract NED coordinates into separate variables
    LATITUDE = ned_xyz(:,1);
    LONGITUDE = ned_xyz(:,2);
    ALTITUDE = ned_xyz(:,3);

    % Assign the results to the base workspace
%     assignin('base', 'LATITUDE', LATITUDE);
%     assignin('base', 'LONGITUDE', LONGITUDE);
%     assignin('base', 'ALTITUDE', ALTITUDE);
end
