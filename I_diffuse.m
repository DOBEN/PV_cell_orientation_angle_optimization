function [ I_d ] =  I_diffuse(theta,gamma,t,Norm,N,Input_t_GHI_DHI_DNI_Load, Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta,at_bt_ct)
% Calculation of  the sky-diffuse  irradiance I_d (Reindl model)

small = 0.000001;
if Input_t_GHI_DHI_DNI_Load(t,2) < small
    % prevent division by zero
    Input_t_GHI_DHI_DNI_Load(t,2) = small;
end

A_t = Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta(t,6); %A_t is anisotropy index
cos_of_zeta = Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta(t,8); %zeta is solar zenith angle
cos_of_AOI = at_bt_ct(t,1) + at_bt_ct(t,2)*sind(theta) +  at_bt_ct(t,3)*cosd(theta); %AOI is angle of incidence
GHI = Input_t_GHI_DHI_DNI_Load(t,2);
DHI = Input_t_GHI_DHI_DNI_Load(t,3);
DNI = Input_t_GHI_DHI_DNI_Load(t,4);

I_d = (DHI/(Norm*N))*((A_t*max(0,cos_of_AOI)/max(0.000001,cos_of_zeta))+(1-A_t)*((1+cosd(gamma))/2)*(1+sqrt(max(0,DNI*cos_of_zeta)/GHI)*(sind(gamma/2)^3)));
end

