function[phase_angle] = calculatePhaseAngle(MM_T2, t_transfer)
% CalculatePhaseAngle calculates the phase angle required for departure
% from the planet of origin to the target planet
% phase_angle output is given in degrees
% phase_angle = (pi-MM_T2*t_transfer)*180/pi

phase_angle = (pi-MM_T2*t_transfer)*(180/pi); 

end