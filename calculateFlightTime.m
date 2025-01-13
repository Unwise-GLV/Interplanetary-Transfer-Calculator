function[t_total_day, t_total_year] = calculateFlightTime(t_transfer, min_positive_wait)
% CalculateFlightTime calculates the total flight time of the mission to
% and from the target planet
% Formula = 2*(t_transfer) + t_wait
% Formula outputs the time in days

t_total_day = 2*(t_transfer) + min_positive_wait; 
t_total_year = t_total_day/365.2; % Converting days to years 
end