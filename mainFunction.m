function RESULTS = mainFunction()
    % Main function to run various scripts and store the results
    % in the RESULTS structure.

    % Add paths to the necessary function and script directories
    addpath('Functions\')
    addpath('Scripts\')

    % Run the necessary scripts to perform calculations

    % Convert CSV data to a structured format with timeseries
    run('csv2struct.m')
    
    % Calculate aerodynamic coefficients (CL, CD, CM)
    run('aerodynamicCoefficients.m')
end