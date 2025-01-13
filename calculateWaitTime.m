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