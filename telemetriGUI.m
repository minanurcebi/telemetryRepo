function telemetriGUI
    % Main function for the MATLAB GUI

    % Creating and positioning the GUI components
    fig = uifigure('Name', 'Telemetry Data Analysis', 'Position', [100, 100, 800, 600]);
    fileButton = uibutton(fig, 'push', 'Text', 'Select File', 'Position', [20, 550, 100, 30], 'ButtonPushedFcn', @(src, event) fileButtonPushed());
    variableList = uilistbox(fig, 'Position', [20, 400, 200, 130]);
    axesPanel = uipanel(fig, 'Position', [240, 20, 540, 560]);
    plotButton = uibutton(fig, 'push', 'Text', 'Plot Graph', 'Position', [130, 550, 100, 30], 'ButtonPushedFcn', @(src, event) plotButtonPushed());

end