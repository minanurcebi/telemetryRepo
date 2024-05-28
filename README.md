# telemetryRepo
Flight Telemetry Data Analysis Project

Telemetry Data Analysis GUI User Guide

The telemetriGUI function provides a graphical user interface (GUI) for analyzing and visualizing telemetry data using MATLAB. Below is a step-by-step guide on the main components and functions of the GUI.
Starting the GUI

    Start the GUI by typing the telemetriGUI command in the MATLAB command window:

    >> telemetriGUI

GUI Components and Functions

    Select File Button:
        Click this button to select a CSV file. When a file is selected, the telemetry data is processed and the variable names are loaded into the variableList box.
        If no file is selected, an error message is displayed.

    Variable Listbox:
        This box contains the list of variables from the selected CSV file.
        You can select multiple variables by holding down the Ctrl key and clicking on the desired variables.

    Selected Variables TextArea:
        This area displays the selected variables.

    Plot Graph Button:
        Click this button to plot the graphs of the selected variables.
        The selected variables are displayed as graphs within the axesPanel.

Example Usage Steps

    Selecting a File:
        Click the Select File button.
        Select a CSV file from the file selection dialog.
        Once a file is selected, the list of variables will be displayed in the variableList box.

    Selecting Variables:
        Select the variables you want to plot from the variableList box.
        The selected variables will be displayed in the selectedVariablesTextArea area.

    Plotting Graphs:
        Click the Plot Graph button.
        The selected variables will be displayed as graphs within the axesPanel.
        Each variable will be plotted in a separate graph, and you can navigate between the graphs.

Warnings and Errors

    If no file is selected or if time data is missing, error messages will be displayed.
    If the lengths of the time and data arrays do not match, an appropriate error message will inform you of the issue.


**Important Warning: The csv2struct script located in the Scripts/ directory operates with a static file path and file name. Users must specify the file path and name of the CSV file they wish to use within the csv2struct.m script according to their working environment.**