function[MM_T1, MM_T2] = calculateMeanMotion(Planet_T1, Planet_T2)
% CalculateMeanMotion calculates the mean motion of the planet of origin
% and the target planet with the output in radians per day
% Formula = (2*pi)/orb_period_T#

orbital_period_T1 = cell2mat(Planet_T1(1, 10)); %<SM:REF:ZEIGER>
orbital_period_T2 = cell2mat(Planet_T2(1, 10)); %<SM:REF:ZEIGER>

MM_T1 = (2*pi)/orbital_period_T1; 
MM_T2 = (2*pi)/orbital_period_T2; 
end