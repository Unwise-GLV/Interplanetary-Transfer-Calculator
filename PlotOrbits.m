function PlotOrbits(Planet_T1, Planet_T2, phase_angle, R_T1, R_T2, T_syn_year, t_transfer_year, t_wait_year)

    theta = linspace(0, 2*pi, 100); % Every possible angle for theta
    
    % Important Values
    R_Sun = 20696000; % Radius of Sun (Not to scale)
    
    center_sun = [0, 0];
    x_sun = center_sun(1) + R_Sun * cos(theta);
    y_sun = center_sun(2) + R_Sun * sin(theta);
    
    center_orbit_T1 = [0, 0];
    x_orbit_T1 = center_orbit_T1(1) + R_T1 * cos(theta); 
    y_orbit_T1 = center_orbit_T1(2) + R_T1 * sin(theta);
    center_orbit_T2 = [0, 0];
    x_orbit_T2 = center_orbit_T2(1) + R_T2 * cos(theta); 
    y_orbit_T2 = center_orbit_T2(2) + R_T2 * sin(theta);
    x_T2 = R_T2 * cosd(phase_angle);
    y_T2 = R_T2 * sind(phase_angle);
    
    
    
    % Plotting Arc
    figure;
    angleInitial=0;
    angleFinal=phase_angle;

    center_phase=[0;0]; % Centering Arc	
    radius= 70000000; % Random radius to make graph look good
    x_angle = radius*cosd(angleFinal/2);
    y_angle = radius*sind(angleFinal/2);
    
    phi = linspace(angleInitial,angleFinal);        
    x_arc = center_phase(1)+radius*cosd(phi); 	
    y_arc = center_phase(2)+radius*sind(phi); 	            
    plot(x_arc,y_arc, 'black-.'); % Plotting Phi <SM:VIEW:ZEIGER>
    text_angle = '\phi';
    text(x_angle, y_angle, text_angle, "FontSize", 14); % Plotting Phi along the arc
    hold on % Start of plotting orbits
    plot(R_T1, 0, '.', 'color' ,'#0072BD', 'MarkerSize', 20);
    text(R_T1, 0, cell2mat(Planet_T1(:, 1)), 'Color', 'blue', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle');
    hold on
    plot(x_T2, y_T2,  '.', 'color', '#A2142F', 'MarkerSize', 20);
    text(x_T2, y_T2, cell2mat(Planet_T2(:, 1)), 'Color', 'red', 'HorizontalAlignment','right', 'VerticalAlignment', 'cap');
    hold on
    patch(x_sun, y_sun, [237/255, 177/255, 32/255], 'FaceColor', [237/255, 177/255, 32/255]);
    axis equal
    hold on
    plot(x_orbit_T1, y_orbit_T1, 'g'); % <SM:VIEW:ZEIGER>
    hold on
    plot(x_orbit_T2, y_orbit_T2, 'r'); % <SM:VIEW:ZEIGER>
    hold on
    plot([0, x_T2], [0, y_T2], 'black-'); % <SM:VIEW:ZEIGER>
    hold on
    plot([0, R_T1], [0, 0], 'black-'); % <SM:VIEW:ZEIGER>
    title('Calculations for Phase Angle \phi')
    legend_angle = sprintf('\\phi = %.1f°', phase_angle);
    legend(legend_angle, cell2mat(Planet_T1(:, 1)), cell2mat(Planet_T2(:, 1)), 'Location', 'northwest')
    % xlim([-4.5*10^8, 4*10^8])
    axis('auto');
    hold off

    calcs_text = sprintf('Phase Angle: %.4f\nSynodic Period (years): %.4f\nTrip time (years): %.4f\nMinimum Wait Time (year): %.4f\n', phase_angle, T_syn_year, t_transfer_year, t_wait_year);
    text(0.01, 0.01, calcs_text, 'Units', 'normalized', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'FontSize', 10); % Putting calculated values on the bottom left of the figure
end