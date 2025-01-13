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