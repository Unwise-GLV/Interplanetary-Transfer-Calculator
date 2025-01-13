function[T_syn_day, T_syn_year] = calculateSynodicPeriod(Planet_T1, Planet_T2)
% CalculateSynodicPeriod calculates the synodic period (in days) of the target planet
% (T2) relative to the planet of origin (T1)
% Formula = (orbital_period_T1 * orbital_period_T2)/(abs(orbital_period_T1-orbital_period_T2))

orbital_period_T1 = cell2mat(Planet_T1(1, 10)); %<SM:REF:ZEIGER>
orbital_period_T2 = cell2mat(Planet_T2(1, 10)); %<SM:REF:ZEIGER>

T_syn_day = (orbital_period_T1 * orbital_period_T2)/(abs(orbital_period_T1-orbital_period_T2)); 
T_syn_year = T_syn_day/365.2;
end