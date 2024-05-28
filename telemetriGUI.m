function telemetriGUI
    % Main function for the MATLAB GUI

    %% Create and position the GUI components
    fig = uifigure('Name', 'Telemetry Data Analysis', 'Position', [100, 100, 800, 600]);
    fileButton = uibutton(fig, 'push', 'Text', 'Select File', 'Position', [20, 550, 100, 30], 'ButtonPushedFcn', @(src, event) fileButtonPushed());
    variableList = uilistbox(fig, 'Position', [20, 400, 200, 130], 'Multiselect', 'on');
    axesPanel = uipanel(fig, 'Position', [240, 20, 540, 560]);
    plotButton = uibutton(fig, 'push', 'Text', 'Plot Graph', 'Position', [130, 550, 100, 30], 'ButtonPushedFcn', @(src, event) plotButtonPushed());

    % Global variables to store telemetry data and results
    global telemetryData RESULTS;

    % Function to be executed when the 'Select File' button is pressed
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
        disp(telemetryData);
        % Execute the main function to calculate and retrieve the desired results
        RESULTS = mainFunction();  % Load the RESULTS structure
        % Get the field names from the RESULTS structure
        resultsFields = fieldnames(RESULTS);
        % Update the variable listbox with the variable names
        variableList.Items = [resultsFields; variableNames];
    end

    % Function to be executed when the 'Plot Graph' button is pressed
    function plotButtonPushed()
        updatePlots(variableList.Value);
    end

    % Function to process the selected telemetry file
    function data = processTelemetryFile(filePath)
        % Read the CSV file into a table
        dataTable = readtable(filePath);
        disp('Data Table:');
        disp(dataTable);  % Display the structure and content of the table
        
        % Convert the table to a structure
        data = table2struct(dataTable);
        disp('Data Struct:');
        disp(data);  % Display the converted structure
    end

    % Function to update the plots with the selected variables
    function updatePlots(selectedVariables)
        % Delete existing axes
        delete(findobj(axesPanel, 'type', 'axes'));
        % Get the number of selected variables
        numVariables = length(selectedVariables);
        % Get the height and width of the axes panel
        panelHeight = axesPanel.Position(4);
        panelWidth = axesPanel.Position(3);
        % Define the margin size
        margin = 70; % margin size
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
                    plot(plotAxes, timeData, plotData);
                    grid(plotAxes, 'on'); % Add grid
                    % Set the title and axis labels
                    title(plotAxes, selectedVariable, 'Interpreter', 'none', 'FontSize', 12, 'FontName', 'Times New Roman');  % Set the variable name as title
                    xlabel(plotAxes, 'Time (s)', 'Interpreter', 'none', 'FontSize', 12, 'FontName', 'Times New Roman');
                    ylabel(plotAxes, 'Data', 'Interpreter', 'none', 'FontSize', 12, 'FontName', 'Times New Roman'); % Set the font size and weight
                    % Calculate and set the x-axis limits
                    xlimRange = [min(timeData), max(timeData)];
                    ylimRange = [min(plotData), max(plotData)];
                    
                    xlim(plotAxes, xlimRange);
                    ylim(plotAxes, ylimRange);
                else
                    disp('Time data not found.');
                end
            elseif isfield(RESULTS, selectedVariable)
                tsObj = RESULTS.(selectedVariable);
                plot(plotAxes, tsObj.Time, tsObj.Data);
                grid(plotAxes, 'on'); % Add grid
                title(plotAxes, selectedVariable, 'Interpreter', 'none', 'FontSize', 12, 'FontName', 'Times New Roman');  % Set the variable name as title
                xlabel(plotAxes, 'Time (s)', 'Interpreter', 'none', 'FontSize', 12, 'FontName', 'Times New Roman');
                ylabel(plotAxes, 'Data', 'Interpreter', 'none', 'FontSize', 12, 'FontName', 'Times New Roman'); % Set the font size and weight
            else
                disp(['Selected variable not found: ', selectedVariable]);
            end
        end
    end
end
