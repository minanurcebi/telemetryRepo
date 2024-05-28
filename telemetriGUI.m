function telemetriGUI
    % Main function for the MATLAB GUI

    % Creating and positioning the GUI components
    fig = uifigure('Name', 'Telemetry Data Analysis', 'Position', [100, 100, 800, 600]);
    fileButton = uibutton(fig, 'push', 'Text', 'Select File', 'Position', [20, 550, 100, 30], 'ButtonPushedFcn', @(src, event) fileButtonPushed());
    variableList = uilistbox(fig, 'Position', [20, 400, 200, 130], 'Multiselect', 'on');
    axesPanel = uipanel(fig, 'Position', [240, 20, 540, 560]);
    plotButton = uibutton(fig, 'push', 'Text', 'Plot Graph', 'Position', [130, 550, 100, 30], 'ButtonPushedFcn', @(src, event) plotButtonPushed());

    % Storing the telemetry data globally
    global telemetryData RESULTS;

    % Function to be executed when a file is selected
    function fileButtonPushed()
        [fileName, pathName] = uigetfile({'*.csv', 'CSV Files (*.csv)'}, 'Select Telemetry File');
        if fileName == 0
            uialert(fig, 'No file selected.', 'File Selection Error');
            return;
        end
        filePath = fullfile(pathName, fileName);
        telemetryData = processTelemetryFile(filePath);
        variableNames = fieldnames(telemetryData);
        disp(telemetryData);
        RESULTS = mainFunction();  % This loads the RESULTS structure
        resultsFields = fieldnames(RESULTS);
        variableList.Items = [resultsFields; variableNames];
    end

    % Function to be executed when the 'Plot Graph' button is pressed
    function plotButtonPushed()
        updatePlots(variableList.Value);
    end

    % Function to process the selected telemetry file
    function data = processTelemetryFile(filePath)
        dataTable = readtable(filePath);
        disp('Data Table:');
        disp(dataTable);  % Display the structure and content of the table
        
        data = table2struct(dataTable);
        disp('Data Struct:');
        disp(data);  % Display the converted structure
    end

    % Function to update the plots with the selected variables
    function updatePlots(selectedVariables)
        delete(findobj(axesPanel, 'type', 'axes'));
        numVariables = length(selectedVariables);
        for i = 1:numVariables
            % Set the position of each axis
            plotAxes = axes('Parent', axesPanel, 'Position', [0.1, 1 - i*0.9/numVariables, 0.8, 0.8/numVariables]);
            selectedVariable = selectedVariables{i};
            if isfield(telemetryData, selectedVariable)
                plotData = [telemetryData.(selectedVariable)];
                if isfield(telemetryData, 'time_sn')
                    timeData = [telemetryData.time_sn];

                    if isempty(timeData) || isempty(plotData) || length(timeData) ~= length(plotData)
                        disp('Invalid data: Time and data arrays are empty or lengths do not match.');
                        return;
                    end
                    plot(plotAxes, timeData, plotData);
                    title(plotAxes, selectedVariable, 'Interpreter', 'none');  % Set the variable name as title
                    xlabel(plotAxes, 'Time (s)', 'Interpreter', 'none');
                    ylabel(plotAxes, 'Data', 'Interpreter', 'none');
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
                title(plotAxes, selectedVariable, 'Interpreter', 'none');  % Set the variable name as title
                xlabel(plotAxes, 'Time (s)', 'Interpreter', 'none');
                ylabel(plotAxes, 'Data', 'Interpreter', 'none');
            else
                disp(['Selected variable not found: ', selectedVariable]);
            end
        end
    end
end
