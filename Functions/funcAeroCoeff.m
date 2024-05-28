function [x,y,z] = funcAeroCoeff(mass,thrust,h,V,alpha,a_x,a_z,row,g,H,S,ro0,c)
    % Function to calculate aerodynamic coefficients: Lift Coefficient (CL),
    % Drag Coefficient (CD), and Pitching Moment Coefficient (CM)

    for j = 1:row
        % Calculate the lift force (L)
        L = mass(j) * (a_z(j) + g) - thrust(j) * sin(alpha(j));           
        % Calculate the lift coefficient (CL)
        CL_temp(j,1) = L / (0.5 * (ro0 * exp(-h(j,1)/H)) * V(j)^2 * S);              

        % Calculate the drag force (D)
        D = thrust(j) * cos(alpha(j)) - mass(j) * a_x(j);                 
        % Calculate the drag coefficient (CD)
        CD_temp(j,1) = D / (0.5 * (ro0 * exp(-h(j,1)/H)) * V(j)^2 * S);              

        % Calculate the pitching moment (M)
        M = mass(j) * (a_z(j) - g) * c + thrust(j) * c * sin(alpha(j));   
        % Calculate the pitching moment coefficient (CM)
        CM_temp(j,1) = M / (0.5 * (ro0 * exp(-h(j,1)/H)) * V(j)^2 * S * c);          
    end

    % Assign the calculated coefficients to the output variables
    x = CL_temp;
    y = CD_temp;
    z = CM_temp;
end
