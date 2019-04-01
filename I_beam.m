function [ I_b ] = I_beam(theta,t,Norm,N,Input_t_GHI_DHI_DNI_Load,at_bt_ct)
% Calculation of  the direct-beam  irradiance I_b = DNI*max(0,cos(AOI))
cos_of_AOI = at_bt_ct(t,1) + at_bt_ct(t,2)*sind(theta) +  at_bt_ct(t,3)*cosd(theta);  %AOI is angle of incidence
DNI = Input_t_GHI_DHI_DNI_Load(t,4);

I_b = (DNI/(Norm*N))*max(0,cos_of_AOI);
end

