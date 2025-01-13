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