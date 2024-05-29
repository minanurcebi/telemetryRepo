function [dataset_struct]  = csv2struct(dataset_name, file_path)
    % The parameter values in the CSV file are converted into timeseries 
    % data as a struct to facilitate their use within Matlab.
    %
    % Parameters:
    %   dataset_name: Name of the dataset (string)
    %   file_path: Path to the folder containing the CSV file (string)
    %
    % Returns:
    %   dataset_struct: A struct containing the timeseries data

     % Construct the full file path     
     filename = fullfile(file_path, dataset_name + ".csv");

    % Open the file
    fid = fopen(filename);  
    if fid == -1
        error('File could not be opened, check the file path and name.');
    end

    % Read the first line to get the field names
    temp = fgetl(fid);

    % Process field names to replace invalid characters into a cell array
    fieldnames      = strsplit(temp, ',');  % Split by commas to get individual field names

    % Initialize the struct with field names
    dataset_struct = struct();
    for j = 1:length(fieldnames)
        dataset_struct.(fieldnames{j}) = [];
    end

    % Read the data from the CSV file
    data = readmatrix(filename);
    [row, col] = size(data);

    % Populate the struct with timeseries data
    for z = 1:col
        dataset_struct.(fieldnames{z}) = timeseries(data(:,z), data(:,1));
    end

    % Assign the struct to the base workspace
     assignin('base', 'dataset_struct', dataset_struct);

    % Close the file
    fclose(fid);
end
