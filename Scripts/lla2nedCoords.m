%% Calculation of Latitude, Longitude, and Altitude in the NED Coordinate System

% Retrieve and assign latitude, longitude, and altitude data from dataset_struct to variables
eval(["latitude"  + "=" + char(dataset_struct_name) + "lat_rad"  + ".Data;"])     % Latitude  
eval(["longitude" + "=" + char(dataset_struct_name) + "lon_rad"  + ".Data;"])     % Longitude   
eval(["altitude"  + "=" + char(dataset_struct_name) + "alt_m"    + ".Data;"])     % Altitude  

% Use the first point as the reference for NED conversion
latLonBase = [latitude(1) ,longitude(1) ,altitude(1)]; % Take the first point as reference

% Convert each latitude, longitude, and altitude point to NED coordinates
for i = 1:row
    ned_xyz(i, :) = lla2ned_0([latitude(i), longitude(i), altitude(i)], ...
                                       [latLonBase(1), latLonBase(2), latLonBase(3)], ...
                                       "ellipsoid"); 
end

% Extract NED coordinates into separate variables
LATITUDE    = ned_xyz(:,1);
LONGITUDE   = ned_xyz(:,2);
ALTITUDE    = ned_xyz(:,3);

% Clear unnecessary variables
clearvars latitude longitude altitude ned_xyz latLonBase i 
