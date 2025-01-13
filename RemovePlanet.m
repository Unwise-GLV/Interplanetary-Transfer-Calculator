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



