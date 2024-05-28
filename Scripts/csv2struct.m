%% csv to Dataset Struct
    % The parameter values in the CSV file are converted into timeseries 
    % data as a struct to facilitate their use within Matlab.
%%
    %*********** "The dataset name and file path must be provided." ***********
dataset_name    = 'dataset_1';  % Name of the dataset
file_path       = "C:\Users\mina.cebi\Downloads\BYGProje2\";  % Path to the folder containing the CSV file
filename        = file_path + dataset_name + ".csv";  % Construct the full file path

fid             = fopen(filename);  % Open the file
temp            = fgetl(fid);  % Read the first line to get the field names

% Process field names to replace invalid characters into a cell array
fieldnames      = strsplit(temp, ',');  % Split by commas to get individual field names

dataset_struct_name = dataset_name + "_struct.";  % Create the base name for the struct

% Initialize the struct with field names
for j = 1:length(fieldnames)
    eval([char(dataset_struct_name) fieldnames{j} ' = [];'])  % Create empty fields in the struct
end

data = readmatrix(filename);  % Read the data from the CSV file
[row, col] = size(data);  % Get the size of the data

% Populate the struct with timeseries data
for z = 1:col
    eval([char(dataset_struct_name) fieldnames{z} ' = timeseries(data(:,z), data(:,1));'])  % Create timeseries for each field
end

% Clear unnecessary variables
clearvars data fid fieldnames file_path filename j dataset_name col temp z
