function telemetriGUI
%% Create and position the GUI components
    fig = uifigure('Name', 'Telemetry Data Analysis', 'Position', [100, 100, 800, 600]);
        % Create the 'Select File' button
    fileButton = uibutton(fig, 'push', 'Text', 'Select File', 'Position', [20, 550, 100, 30], 'ButtonPushedFcn', @(src, event) fileButtonPushed());
        % Create the variable listbox
    variableList = uilistbox(fig, 'Position', [20, 400, 200, 130], 'Multiselect', 'on');
        % Create the text area to display selected variables
    selectedVariablesTextArea = uitextarea(fig, 'Position', [20, 300, 200, 80]);
        % Create the axes panel for plotting
    axesPanel = uipanel(fig, 'Position', [240, 20, 540, 560]);
        % Create the 'Plot Graph' button
    plotButton = uibutton(fig, 'push', 'Text', 'Plot Graph', 'Position', [130, 550, 100, 30], 'ButtonPushedFcn', @(src, event) plotButtonPushed());

%% Global variables to store telemetry data and results
    global telemetryData RESULTS;

%% Function to be executed when the 'Select File' button is pressed
    function fileButtonPushed()
        % Open a file selection dialog
        [fileName, pathName] = uigetfile({'*.csv', 'CSV Files (*.csv)'}, 'Select Telemetry File');
        if fileName == 0
            % Display an error message if no file is selected
            uialert(fig, 'No file selected.', 'File Selection Error');
            return;
        end
        % Construct the full file path
        filePath = fullfile(pathName, fileName);
        % Process the selected telemetry file
        telemetryData = processTelemetryFile(filePath);
        % Get the variable names from the telemetry data
        variableNames = fieldnames(telemetryData);
        
        fileName = strrep(fileName, '.csv', '');
        addpath('Functions')
        [dataset_struct] = csv2struct(fileName, pathName);
        % Calculate aerodynamic coefficients (CL, CD, CM)
        [CL, CD, CM] = aerodynamicCoefficients(dataset_struct);
        % Convert quaternions to Euler angles (yaw, pitch, roll)
        [YAW, PITCH, ROLL] = quaternions2euler(dataset_struct);
        % Convert latitude, longitude, and altitude to NED coordinates
        [LATITUDE, LONGITUDE, ALTITUDE] = lla2nedCoords(dataset_struct);
        % Calculate airspeed components (u, v, w)
        [u, v, w] = calculateAirSpeedComponents(dataset_struct);

        % Store the results in the RESULTS structure
        % Retrieve the time data from the dataset structure
        Time = dataset_struct.time_sn.Data;

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
        % Runs the 'mainFunction.m' that calculates the desired results and retrieves them
%         RESULTS = mainFunction();  % Load the RESULTS structure
        % Get the field names from the RESULTS structure
        resultsFields = fieldnames(RESULTS);
        % Update the variable listbox with the variable names
        variableList.Items = [resultsFields; variableNames];
    end

%% Function to be executed when the 'Plot Graph' button is pressed
    function plotButtonPushed()
        % Get the selected variables
        selectedVariables = variableList.Value;
        % Update the text area with the selected variables
        selectedVariablesTextArea.Value = selectedVariables;
        % Update the plots with the selected variables
        updatePlots(selectedVariables);
    end

%% Function to process the selected telemetry file
    function data = processTelemetryFile(filePath)
        % Read the CSV file into a table
        dataTable = readtable(filePath);
        
        % Convert the table to a structure
        data = table2struct(dataTable);
    end

%% Function to update the plots with the selected variables
    function updatePlots(selectedVariables)
        % Delete existing axes
        delete(findobj(axesPanel, 'type', 'axes'));
        % Get the number of selected variables
        numVariables = length(selectedVariables);
        % Get the height and width of the axes panel
        panelHeight = axesPanel.Position(4);
        panelWidth = axesPanel.Position(3);
        % Define the margin size
        margin = 70; 
        % Calculate the height and width of each axis
        axesHeight = (panelHeight - margin * (numVariables + 1)) / numVariables; % Height of each axis
        axesWidth = panelWidth - 2 * margin; % Width of each axis
        % Define the offset for shifting the plots to the right
        xOffset = 30; % offset for shifting the plots to the right

        % Loop through each selected variable
        for i = 1:numVariables
            % Set the position of each axis
            plotAxes = axes('Parent', axesPanel, 'Position', [(margin + xOffset) / panelWidth, 1 - (i * (axesHeight + margin) / panelHeight), axesWidth / panelWidth, axesHeight / panelHeight]);
            selectedVariable = selectedVariables{i};
            if isfield(telemetryData, selectedVariable)
                % Get the data for the selected variable
                plotData = [telemetryData.(selectedVariable)];
                if isfield(telemetryData, 'time_sn')
                    % Get the time data
                    timeData = [telemetryData.time_sn];

                    % Check the validity of the time and data arrays
                    if isempty(timeData) || isempty(plotData) || length(timeData) ~= length(plotData)
                        disp('Invalid data: Time and data arrays are empty or lengths do not match.');
                        return;
                    end
                    
                    % Plot the data
                    plot(plotAxes, timeData, plotData, 'LineWidth', 1.5);
                    % Add grid to the plot
                    grid(plotAxes, 'on'); 
                    % Set the title and axis labels
                    title(plotAxes, selectedVariable, 'Interpreter', 'none', 'FontSize', 12, 'FontName', 'Times New Roman'); 
                    xlabel(plotAxes, 'Time (s)', 'Interpreter', 'none', 'FontSize', 12, 'FontName', 'Times New Roman');
                    ylabel(plotAxes, 'Data', 'Interpreter', 'none', 'FontSize', 12, 'FontName', 'Times New Roman'); 
                    % Calculate and set the x-axis limits
                    xlimRange = [min(timeData), max(timeData)];
                    % Calculate and slightly expand the y-axis limits
                    ylimMin = min(plotData);
                    ylimMax = max(plotData);
                    ylimPadding = (ylimMax - ylimMin) * 0.1; % 10% padding
                    ylimRange = [ylimMin - ylimPadding, ylimMax + ylimPadding];
                    
                    % Check if the y-axis limits are valid, if not set default limits
                    if ylimRange(1) == ylimRange(2)
                        ylimRange = [ylimRange(1) - 1, ylimRange(2) + 1];
                    end
                    if any(isnan(ylimRange)) || any(isinf(ylimRange))
                        ylimRange = [0, 1]; % Set default y-axis limits if invalid
                    end

                    % Set the axis limits
                    xlim(plotAxes, xlimRange);
                    ylim(plotAxes, ylimRange);
                else
                    disp('Time data not found.');
                end
            elseif isfield(RESULTS, selectedVariable)
                % Get the data from the RESULTS structure
                tsObj = RESULTS.(selectedVariable);
                % Plot the data
                plot(plotAxes, tsObj.Time, tsObj.Data, 'LineWidth', 1.5);
                % Add grid to the plot
                grid(plotAxes, 'on'); 
                % Set the title and axis labels
                title(plotAxes, selectedVariable, 'Interpreter', 'none', 'FontSize', 12, 'FontName', 'Times New Roman'); 
                xlabel(plotAxes, 'Time (s)', 'Interpreter', 'none', 'FontSize', 12, 'FontName', 'Times New Roman');
                ylabel(plotAxes, 'Data', 'Interpreter', 'none', 'FontSize', 12, 'FontName', 'Times New Roman'); 
                % Calculate and slightly expand the y-axis limits
                ylimMin = min(tsObj.Data);
                ylimMax = max(tsObj.Data);
                ylimPadding = (ylimMax - ylimMin) * 0.1; % 10% padding
                ylimRange = [ylimMin - ylimPadding, ylimMax + ylimPadding];

                % Check if the y-axis limits are valid, if not set default limits
                if ylimRange(1) == ylimRange(2)
                    ylimRange = [ylimRange(1) - 1, ylimRange(2) + 1];
                end
                if any(isnan(ylimRange)) || any(isinf(ylimRange))
                    ylimRange = [0, 1]; % Set default y-axis limits if invalid
                end

                % Set the y-axis limits
                ylim(plotAxes, ylimRange);
            else
                disp(['Selected variable not found: ', selectedVariable]);
            end
        end
    end
end
