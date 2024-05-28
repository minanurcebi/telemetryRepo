function telemetriGUI
    % Main function for the MATLAB GUI

    % Creating and positioning the GUI components
    fig = uifigure('Name', 'Telemetry Data Analysis', 'Position', [100, 100, 800, 600]);
    fileButton = uibutton(fig, 'push', 'Text', 'Select File', 'Position', [20, 550, 100, 30], 'ButtonPushedFcn', @(src, event) fileButtonPushed());
    variableList = uilistbox(fig, 'Position', [20, 400, 200, 130]);
    axesPanel = uipanel(fig, 'Position', [240, 20, 540, 560]);
    plotButton = uibutton(fig, 'push', 'Text', 'Plot Graph', 'Position', [130, 550, 100, 30], 'ButtonPushedFcn', @(src, event) plotButtonPushed());

    % Storing the telemetry data globally
    global telemetryData;

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
        variableList.Items = variableNames;
    end

    % Function to be executed when the 'Plot Graph' button is pressed
    function plotButtonPushed()
        updatePlots(variableList.Value);
    end

    % Function to process the selected telemetry file
    function data = processTelemetryFile(filePath)
        dataTable = readtable(filePath);
        data = table2struct(dataTable);
    end

    % Function to update the plots with the selected variable
    function updatePlots(selectedVariable)
        delete(findobj(axesPanel, 'type', 'axes'));
        plotAxes = axes(axesPanel);
        if isfield(telemetryData, selectedVariable)
            plotData = telemetryData.(selectedVariable);
            if isfield(telemetryData, 'time_sn')
                timeData = telemetryData.time_sn;

                % Plot the data
                plot(plotAxes, timeData, plotData);
                xlabel(plotAxes, 'Time (s)');
                ylabel(plotAxes, selectedVariable);
                xlim(plotAxes, [min(timeData) max(timeData)]);
                ylim(plotAxes, [min(plotData) max(plotData)]);
            else
                disp('Time data not found.');
            end
        else
            disp(['Selected variable not found: ', selectedVariable]);
        end
    end
end