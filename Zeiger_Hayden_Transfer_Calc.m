% ------------------------------------------------------------------------
%   Name: Hayden Zeiger
%   Section: 15
%   Submission Date: 4/26/2024
%
%   File Description: Calculates phase angles between two celestial bodies, 
%   synodic periods, flight times, and mean angular velocities. 
%   From this information, a figure will appear with a vector showing the
%   angle the target planet must be at ahead or behind the planet of
%   origin. The program also assumes planets are heliocentric, coplanar,
%   and have circular orbits. It does not assume parking orbits or delta-V
%   budgets and should thus not be used to determine the efficiency of
%   interplanetary transfers.
%
%
%   Citation: [Include any and all links of online resources that you
%   utilized within your file. Provide line numbers of where the code
%   can be found within your file. If a person aided you with your code, 
%   provide their full name and line numbers of what you were aided with
%   it. Example shown below
%
%
%            
%              Orbital Mechanics for|  Equations for PDF's, Line Numbers:
%               Engineering Students|  9 in SynodicPeriod.m
%                   Howard D. Curtis|  17 in calculateTransferTime
%                    Published: 2021|  7 in calculatePhaseAngle.m
%                                   |  9-10 in calculateMeanMotion.m
%                                   |  7 in calculateFlightTime.m
%                                   |  9 and 16 in calculateWaitTime.m
%
%                     Helped in AAC |  Line Number in RemovePlanet.m
%              Tutor name not known |  9-15

%                     Helped in AAC |  Line Number in calculateWaitTime.m
%              Tutor name not known |  17-19
%
%
%                            Cosmic Train Schedule|
%   http://www.clowder.net/hop/railroad/sched.html| General Information for cross checking outputs
%
%
%          NASA Planetary Info Sheet|https://nssdc.gsfc.nasa.gov/planetary/factsheet/
%                                   | Used for creating Planet_Info.xlsx
%
%   https://www.mathworks.com/matlabcentral/answers/886584-getting-an-array-of-points-along-an-arc?s_tid=prof_contriblnk
%                          MathWorks| Line Number in plotOrbits_PDF
%                  www.mathworks.com| 24-38
%   
%
% 
%               
%
%   Rubric score markers: [Provide a list of all score markers covered 
%   within this file., including the line number. Example shown below
%                  Score Marker    |  Line Number
%               %<SM:IF:LASTNAME>  |  20
%
%   Note that you are still expected to insert the score markers within 
%   your code as well.]
%
%
%
%   CORE TECHNIQUES:
%
%   <SM:ROP:ZEIGER>        9 in RemovePlanet.m
%   <SM:BOP:ZEIGER>        9 and 17 in RemovePlanet.m
%   <SM:IF:ZEIGER>         14 - 39 in calculateWaitTime.m
%   <SM:SWITCH:ZEIGER>     N/A  
%   <SM:FOR:ZEIGER>        46 - 58 in ChoosePlanet.m
%   <SM:WHILE:ZEIGER>      94 - 98 in ChoosePlanet.m 
%   <SM:RANDOM:ZEIGER>     27 in ChoosePlanet.m
%
%   SPECIFIC TECHNIQUES:
%
%   <SM:REF:ZEIGER>        6 - 7 MeanMotion.m, 6-7 SynodicPeriod.m
%   <SM:SLICE:ZEIGER>      110 in ChoosePlanet.m 
%   <SM:AUG:ZEIGER>        35 in ChoosePlanet.m
%   <SM:DIM:ZEIGER>        20 - 22 in RemovePlanet.m
%   <SM:SORT:ZEIGER>       64 in ChoosePlanet.m
%   <SM:SEARCH:ZEIGER>     N/A
%   <SM:FILTER:ZEIGER>     N/A
%   <SM:VIEW:ZEIGER>       36, 49, 51, 53 in PlotOrbits.m
%
% 
% -------------------------------------------------------------------------

clc
clear
close all

% LOADING XLSX
planet_info = readcell('Planet_Info.xlsx');
planet_info_display = planet_info(:, [1:4, 8,10, 13]);

planet_name = char(planet_info_display(:,1));
type = char(planet_info_display(:,2));
num_moons = cell2mat(planet_info_display(:,3));
ring_sys = char(planet_info_display(:,4));
% mass = cell2mat(planet_info(:,5));
% diameter = cell2mat(planet_info(:,6));
% gravity = cell2mat(planet_info(:,7));
day_length = cell2mat(planet_info_display(:,5));
% semi_major_axis = cell2mat(planet_info(:,9)); <- calculateTransferTime
% has the variable as R_T#
orbital_period = cell2mat(planet_info_display(:,6));
% orbital_velocity = cell2mat(planet_info(:,11));
% orbital_inclination = cell2mat(planet_info(:,12));
% eccentricity = cell2mat(planet_info_display(:,7));

% title_labels = {'Planet', 'Type','Number of Moons','Ring System','Mass (10^24 kg)','Diameter (km)','Gravity (m/s^2)','Length of Day (hours)','Semi-major axis (10^6 km)', 'Orbital Period (days)', 'Orbital Velocity (km/s)', 'Orbital Inclination (degrees)','Eccentricity'};
title_labels = {'Planet', 'Type','Number of Moons','Ring System','Length of Day (hours)', 'Orbital Period (days)'};

planet_table_display = table(planet_name, type, num_moons, ring_sys, day_length, orbital_period, 'VariableNames', title_labels);


% PROGRAM WELCOME

fprintf('<strong>---------------------------------------Interplanetary Transfer Calculator---------------------------------------</strong>\n\n');


fprintf('This program calculates the necessary information for interplantary transfers considering planets are heliocentric, coplanar, and circular.\n')
fprintf(2, '<strong>THIS PROGRAM DOES NOT CONSIDER PARKING ORBITS</strong>.\n');


% User chooses planet of origin
Planet_T1 = ChoosePlanet(planet_info, planet_info_display, planet_table_display, "planet of origin:");
while isempty(Planet_T1) % Error checking
    Planet_T1 = ChoosePlanet(planet_info, planet_info_display, planet_table_display, "planet of origin:"); 
end

% Updating cell arrays and tables after planet of origin is picked and removed
[planet_info, planet_info_display, planet_table_display] = RemovePlanet(Planet_T1, planet_info, planet_info_display, planet_table_display);



% User chooses target planet (planet the spacecraft is traveling to)
Planet_T2 = ChoosePlanet(planet_info, planet_info_display, planet_table_display, "target planet:");
while isempty(Planet_T2)
    Planet_T2 = ChoosePlanet(planet_info, planet_info_display, planet_table_display, "target planet:"); % Error checking
end

% Calculating synodic period
[T_syn_day, T_syn_year] = calculateSynodicPeriod(Planet_T1, Planet_T2);

% Calculating length of trip to target planet from planet of origin
[t_transfer, R_T1, R_T2, t_transfer_year] = calculateTransferTime(Planet_T1, Planet_T2);

% Calculating mean motions (angular velocities of celestial bodies)
[MM_T1, MM_T2] = calculateMeanMotion(Planet_T1, Planet_T2); % mean motion for planet of origin

% Calculating phase angle between the planet of origin and the target
% planet
phase_angle = calculatePhaseAngle(MM_T2, t_transfer);

% Calculating minimum wait time for initiating a trip from the planet of
% origin to the target planet 
[min_positive_wait, t_wait_year] = calculateWaitTime(MM_T1, MM_T2, t_transfer); 
% Calculating total flight time
[t_total_day, t_total_year] = calculateFlightTime(t_transfer, min_positive_wait);

% Plotting
PlotOrbits(Planet_T1, Planet_T2, phase_angle, R_T1, R_T2, T_syn_year, t_transfer_year, t_wait_year)

%% PDF's

function[planet_array] = ChoosePlanet(planet_info, planet_info_display, planet_table_display, location)
% ChoosePlanet grants the user the option to sort through data and choose what planet they want considered in the calculations 

    repeat = 'yes';
    while strcmpi(repeat, 'yes') % <SM:WHILE:ZEIGER>
        fprintf("\n")
        firstLine = sprintf("Please select %s ", location);
        fprintf(firstLine)
        fprintf('\n\tSort planets by: \n')
        fprintf('\t - Planet Name\n')
        fprintf('\t - Type\n')
        fprintf('\t - Number of Moons\n')
        fprintf('\t - Ring System\n')
        fprintf('\t - Length of Day\n')
        fprintf('\t - Orbital Period\n')
        fprintf(2, '\t - <strong>Random</strong>\n')

        [n_rows, ~] = size(planet_info);
        
        sort_choice = input('\nSort by: ', 's');
        sort_data = {'planet name', 'type','number of moons','ring system','length of day','orbital period', 'random'};
        while isempty(sort_choice) || ismember(lower(sort_choice), sort_data) == 0
            sort_choice = input('Error...\nSort by: ', 's');
        end
        
        if strcmpi(sort_choice, 'random')
            sort_rand_num = round(rand*5+1); % <SM:RANDOM:ZEIGER>
            sort_choice = sort_data{sort_rand_num};
            fprintf("Your sorting choice was randomly chosen for you: %s\n", sort_choice);
        end

        if strcmpi(sort_choice, 'planet name')
            disp(table(char(planet_info_display(:, 1)), 'VariableNames', {'Planet'})) 
        elseif strcmpi(sort_choice, 'type')
            disp(table(char(planet_info_display(:, 1)), char(planet_info_display(:, 2)), 'VariableNames', {'Planet', 'Type'})) % <SM:AUG:ZEIGER>
        elseif strcmpi(sort_choice, 'ring system')
            disp(table(char(planet_info_display(:, 1)), char(planet_info_display(:, 4)), 'VariableNames', {'Planet', 'Ring System'})) % <SM:AUG:ZEIGER>
        elseif strcmpi(sort_choice, 'number of moons')
            sort_q_moon = input('Would you like to sort by increasing or decreasing values?: ', 's');
            while isempty(sort_q_moon) || (~strcmpi(sort_q_moon, 'increasing') && ~strcmpi(sort_q_moon, 'decreasing'))
                sort_q_moon = input('Error...\nEnter the sorting order (increasing or decreasing): ','s');
            end
            if strcmpi(sort_q_moon, 'increasing')
                planet_info_sort = cell2mat(planet_info_display(:, 3));
                planet_sorted_names = (planet_table_display(:, 1));
                for k = 1:n_rows - 1 % <SM:FOR:ZEIGER>
                    for i = 1:n_rows - k
                        if planet_table_display{i, 3} > planet_table_display{i + 1, 3} % Sorting with for loops
                            temp_choice_sort = planet_info_sort(i);
                            planet_info_sort(i) = planet_info_sort(i + 1);
                            planet_info_sort(i + 1) = temp_choice_sort; 
                            
                            temp_name_sort = planet_sorted_names{i, 1};
                            planet_sorted_names{i, 1} = planet_sorted_names{i + 1, 1};
                            planet_sorted_names{i + 1, 1} = temp_name_sort;
                        end
                    end
                end
                sorted_names_table = sortrows(planet_table_display, 3, "ascend");
                sort_num_name = [sorted_names_table(:, 1), num2cell(planet_info_sort)];
                sort_num_name.Properties.VariableNames{2} = 'Number of Moons';
                disp(sort_num_name)
            elseif strcmpi(sort_q_moon, 'decreasing')
                sorted_moon_dec = sortrows(planet_table_display, [3, 1], {'descend', 'ascend'});
                disp(sorted_moon_dec(:, [1, 3]))
            end
        elseif strcmpi(sort_choice, 'length of day')
            sort_day = input('Would you like to sort by increasing or decreasing values?: ', 's');
            while isempty(sort_day) || (~strcmpi(sort_day, 'increasing') && ~strcmpi(sort_day, 'decreasing'))
                sort_day = input('Error...\nEnter the sorting order (increasing or decreasing): ' ,'s');
            end
            if strcmpi(sort_day, 'increasing')
                sorted_day_inc = sortrows(planet_table_display, [5, 1], {'ascend', 'descend'});
                disp(sorted_day_inc(:, [1, 5]))
            elseif strcmpi(sort_day, 'decreasing')
                sorted_day_dec = sortrows(planet_table_display, [5, 1], {'descend', 'ascend'});
                disp(sorted_day_dec(:, [1, 5]))
            end
        elseif strcmpi(sort_choice, 'orbital period')
            sort_orbital = input('Would you like to sort by increasing or decreasing values?: ', 's');
            while isempty(sort_orbital) || (~strcmpi(sort_orbital, 'increasing') && ~strcmpi(sort_orbital, 'decreasing'))
                sort_orbital = input('Error...\nEnter the sorting order (increasing or decreasing): ' ,'s');
            end
            if strcmpi(sort_orbital, 'increasing')
                sorted_orb_inc = sortrows(planet_table_display, [6, 1], {'ascend', 'descend'});
                disp(sorted_orb_inc(:, [1, 6]))
            elseif strcmpi(sort_orbital, 'decreasing')
                sorted_orb_dec = sortrows(planet_table_display, [6, 1], {'descend', 'ascend'});
                disp(sorted_orb_dec(:, [1, 6]))
            end
        end
    
        repeat = input('Would you like to sort again? (yes or no): ', 's');
        while isempty(repeat) || ~strcmpi(repeat, 'yes') && ~strcmpi(repeat, 'no') % <SM:WHILE:ZEIGER>
            repeat = input('Error...\nEnter if you would like to sort again (yes or no): ', 's');
            if strcmpi(repeat, 'no')
                repeat = 'no';
            end
        end
    end
                
    % Choosing planet
    inputString = sprintf("Enter %s ", location);
    planet_T1 = input(inputString, 's');
    [n_rows1, ~] = size(planet_info);
    
    planet_array = [];
    for k = 1:n_rows1
        if strcmpi(planet_info{k, 1}, planet_T1)
            planet_array = planet_info(k,:); % <SM:SLICE:ZEIGER>
        end
    end

    if isempty(planet_array)
        fprintf('Error...\nPlanet not found. Please select another planet.\n');
    end
end

function[planet_info, planet_info_display, planet_table_display] = RemovePlanet(Planet_T1, planet_info, planet_info_display, planet_table_display)
% Remove planet
    
    [n_row, ~] = size(planet_info);
    
    found = 0;
    index = 0;
    k = 1;
    while k <= n_row && ~found % <SM:ROP:ZEIGER> <SM:BOP:ZEIGER>
        if strcmpi(Planet_T1(1), planet_info{k, 1})
            index = k;
            found = 1;
        end
        k = k + 1;
    end
    
    if ~found % <SM:BOP:ZEIGER>
        fprintf('Error...\nPlanet not found, please re-run code.');
    else 
        planet_info(index, :) = []; % <SM:DIM:ZEIGER>
        planet_info_display(index, :) = []; % <SM:DIM:ZEIGER>
        planet_table_display(index, :) = []; % <SM:DIM:ZEIGER>
    end
end

function[T_syn_day, T_syn_year] = calculateSynodicPeriod(Planet_T1, Planet_T2)
% CalculateSynodicPeriod calculates the synodic period (in days) of the target planet
% (T2) relative to the planet of origin (T1)
% Formula = (orbital_period_T1 * orbital_period_T2)/(abs(orbital_period_T1-orbital_period_T2))

orbital_period_T1 = cell2mat(Planet_T1(1, 10)); %<SM:REF:ZEIGER>
orbital_period_T2 = cell2mat(Planet_T2(1, 10)); %<SM:REF:ZEIGER>

T_syn_day = (orbital_period_T1 * orbital_period_T2)/(abs(orbital_period_T1-orbital_period_T2)); 
T_syn_year = T_syn_day/365.2;
end

function [t_transfer, R_T1, R_T2, t_transfer_year] = calculateTransferTime(Planet_T1, Planet_T2) 
% calculateTransferTime calculates how long the journey from the planet of
% origin to the target planet is in days
% Formula = (pi/(sqrt(mu_sun))*((R_T1+R_T2)/2)^(3/2)

% mu_sun is the standard gravitation parameter of the Sun wherein it is the
% product of the gravitational constant G and the total mass M of all the
% bodies orbiting the celestial body

% R_T# is the radius of the planets orbit represented of the celestial-bodies
% semi-major axis

mu_sun = 132.71*10^9; % in km^3/s^2
R_T1 = cell2mat(Planet_T1(1, 9))*10^6; % Radius (semi-major axis is multiplied by 10^6 because the distance is to the 10^6km <SM:REF:ZEIGER>
R_T2 = cell2mat(Planet_T2(1, 9))*10^6; % Radius (semi-major axis is multiplied by 10^6 because the distance is to the 10^6km <SM:REF:ZEIGER>

t_transfer_sec = (pi/(sqrt(mu_sun)))*((((R_T1)+(R_T2))/2)^(3/2));
t_transfer = t_transfer_sec/86400;
t_transfer_year = t_transfer/365.2;
end

function[MM_T1, MM_T2] = calculateMeanMotion(Planet_T1, Planet_T2)
% CalculateMeanMotion calculates the mean motion of the planet of origin
% and the target planet with the output in radians per day
% Formula = (2*pi)/orb_period_T#

orbital_period_T1 = cell2mat(Planet_T1(1, 10)); %<SM:REF:ZEIGER>
orbital_period_T2 = cell2mat(Planet_T2(1, 10)); %<SM:REF:ZEIGER>

MM_T1 = (2*pi)/orbital_period_T1; 
MM_T2 = (2*pi)/orbital_period_T2; 
end

function[phase_angle] = calculatePhaseAngle(MM_T2, t_transfer)
% CalculatePhaseAngle calculates the phase angle required for departure
% from the planet of origin to the target planet
% phase_angle output is given in degrees
% phase_angle = (pi-MM_T2*t_transfer)*180/pi

phase_angle = (pi-MM_T2*t_transfer)*(180/pi); 

end

function[min_positive_wait, t_wait_year] = calculateWaitTime(MM_T1, MM_T2, t_transfer)
% CalculateWaitTime calculates the minimum number of days required for the
% phase angle to reach its proper value\
% "N" is chosen to make t_wait positive. This number can be any number as
% N = 0, 1, 2... all in all it's purpose is to make the wait time the
% lowest possible number so any number greater than the value which makes
% t_wait just increases the wait time.

phi_f = pi-MM_T1*t_transfer; % Finds the phase angle between the planet of origin and the target planet once the spacecraft reaches the target planet
% N = ceil(rand*3); %

min_positive_wait = inf; % Checking for smallest possible positive wait time

    if MM_T1 > MM_T2 % <SM:IF:ZEIGER>
        for N = 0:1000000
            t_wait_day = (-2*(phi_f)-2*pi*(N))/(MM_T2-MM_T1);
            if t_wait_day > 0 && t_wait_day < min_positive_wait % <SM:IF:ZEIGER>
                min_positive_wait = t_wait_day; % Chooses smallest positive wait time
            end
        end
        if isinf(min_positive_wait) % <SM:IF:ZEIGER>
            disp('Error...\nA negative wait time is not possible.\n');
        end
        t_wait_year = min_positive_wait/365.2;
    elseif MM_T1 < MM_T2
        for N = 0:1000000
            t_wait_day = (-2*(phi_f)+2*pi*(N))/(MM_T2-MM_T1);
            if t_wait_day > 0 && t_wait_day < min_positive_wait % <SM:IF:ZEIGER>
                min_positive_wait = t_wait_day; % Chooses smallest positive wait time
            end
        end
        if isinf(min_positive_wait) % <SM:IF:ZEIGER>
            disp('Error...\nA negative wait time is not possible.\n');
        end
        t_wait_year = min_positive_wait/365.2;
    else
        t_wait_year = 0;
        fprintf('Interplanetary transfer cannot be completed because selected celestial bodies have the same angular velocity');
    end
end

function[t_total_day, t_total_year] = calculateFlightTime(t_transfer, min_positive_wait)
% CalculateFlightTime calculates the total flight time of the mission to
% and from the target planet
% Formula = 2*(t_transfer) + t_wait
% Formula outputs the time in days

t_total_day = 2*(t_transfer) + min_positive_wait; 
t_total_year = t_total_day/365.2; % Converting days to years 
end

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


