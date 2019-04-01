close all
clear()
% Orientation angle optimization
% This is the code to paper:
% All angles are in degree meassures.

albedo = 0.2;   % grassland
gamma = 36;     % inclination angle, degree measure, horizontally mounted: gamma=0
theta = 0;      % inclination angle, degree measure, south=0, west=90, east=-90
Norm = 614;     % normalization of energy values, 614 W/m^2 because this is highest value for gamma=36 and
%orientation=0 at noon in Jun in Greenwich
range_of_optimum_points = 100000;  %if this parameter is very big then some of the optimum points/stripes are not visible in the output graph, if this parameter is very small then the red points (red stripes) are too thick in the graph (too many points are marked as optimum points/stripes)

N = 2;   %Number of PV cells
T = 96;  %Number of time steps
d = 165; %Day of the year (d=165 is day in June)( 1^st of January is d=1) 

lon = 0.0003;   %Longitude of Greenwich, degree measure
lat = 51.4767;  %Latitude of Greenwich, degree measure
%lon = 103.817817;%Longitude of Singapore, degree measure
%lat = 1.194444;  %Latitude of Singapore, degree measure

load_profile = 1;  % 1==Constant Load Profile, 2==Business Load Profile, 3==Residential Load Profile 
off_set = 0.9;     %off_set to the load_profile: C(t)=off_set (Constant Load Profile),C(t)=scale*C_bis+off_set (Business Load Profile), C(t)=scale*C_res+off_set (Residential Load Profile) 
scale = 1;         %scale to the load_profile: C(t)=off_set (Constant Load Profile),C(t)=scale*C_bis+off_set (Business Load Profile), C(t)=scale*C_res+off_set (Residential Load Profile) 
time_step_when_data_starts = 17;  %to read in the data from text file (17 for June in greenwich, 35 for December, 25 for September, 27 for March, 26 Singapore )
time_step_when_data_ends = T - time_step_when_data_starts + 2; %+2 fuer greenwich

Input_t_GHI_DHI_DNI_Load = zeros(T,5);
at_bt_ct = zeros(T,3);
Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta = zeros(T,8);

  fileID = fopen('jun_dailyrad512836N_000001W_0deg_0deg.txt','r'); %horizontially mounted PV cell in June at Greenwich as baseline to get GHI, DHI, DNI
for i = 1:7  % removes header from input data file
    handle = fgetl(fileID);
end

for t = time_step_when_data_starts:time_step_when_data_ends
    handle = fgetl(fileID);
    handle = fscanf(fileID,'%s',1 );
    GHI = fscanf(fileID,'%s',1 );
    DHI = fscanf(fileID,'%s',1 );
    DNI = fscanf(fileID,'%s',1 );
    
    Input_t_GHI_DHI_DNI_Load(t,2) = str2num(GHI);  
    Input_t_GHI_DHI_DNI_Load(t,3) = str2num(DHI);  
    Input_t_GHI_DHI_DNI_Load(t,4) = str2num(DNI);  
end

handle = fclose(fileID);
% symmetrisation of data
for t=1:T/2
    Input_t_GHI_DHI_DNI_Load(t,2) =  (Input_t_GHI_DHI_DNI_Load(t,2)+Input_t_GHI_DHI_DNI_Load(T-t+1,2))/2;
    Input_t_GHI_DHI_DNI_Load(T-t+1,2) = Input_t_GHI_DHI_DNI_Load(t,2);
    Input_t_GHI_DHI_DNI_Load(t,3) =  (Input_t_GHI_DHI_DNI_Load(t,3)+Input_t_GHI_DHI_DNI_Load(T-t+1,3))/2;
    Input_t_GHI_DHI_DNI_Load(T-t+1,3) = Input_t_GHI_DHI_DNI_Load(t,3);
    Input_t_GHI_DHI_DNI_Load(t,4) =  (Input_t_GHI_DHI_DNI_Load(t,4)+Input_t_GHI_DHI_DNI_Load(T-t+1,4))/2;
    Input_t_GHI_DHI_DNI_Load(T-t+1,4) = Input_t_GHI_DHI_DNI_Load(t,4);
end

for t = 1:T
    Input_t_GHI_DHI_DNI_Load(t,1)=t;
end

fileID = fopen('load_profiles.txt','r');
handle = fgetl(fileID);  %removes header of table 

for t = 1:T
    handle = fscanf(fileID,'%s',1 );
    C_con = fscanf(fileID,'%s',1 );
    C_bis = fscanf(fileID,'%s',1 );
    C_res = fscanf(fileID,'%s',1 );

    if (load_profile==1)
        Input_t_GHI_DHI_DNI_Load(t,5) = str2num(C_con)*scale+off_set;  
    else if  load_profile==2
        Input_t_GHI_DHI_DNI_Load(t,5) = str2num(C_bis)*scale+off_set; 
        else if load_profile==3
            Input_t_GHI_DHI_DNI_Load(t,5) = str2num(C_res)*scale+off_set; 
            else 
                disp('Error load_profile_index');
            end
        end
    end
end

handle = fclose(fileID);

E_con = 1367;
%Calculation of extraterrestrial radiation (depends on the day of the year), in degree measure
E_d = E_con*(1+0.033*cosd((360/365)*d));
%Calculation of declination angle (depends on the day of the year), in degree measure
delta = 23.45*sind(360/365*(284+d));


%the following for-loop calculates the the energy generation profile of 1 PV cell out of
%the N PV cells

for t = 1:T
   % time step index
   Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta(t,1) = t;
   
   % Calculation of anisotropy index A_t
   Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta(t,6) = Input_t_GHI_DHI_DNI_Load(t,4)/E_d;
   
   % Calculation of omega at greenwich
   Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta(t,7) = -180+1.875+(t-1)/T*360;
   
   % Calculation of cos(zeta), zeta is solar zenith angle
   omega = Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta(t,7);
   Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta(t,8)=sind(lat)*sind(delta)+cosd(lat)*cosd(delta)*cosd(omega);

  
   % Calculation of a_t, b_t, and c_t 
   at_bt_ct(t,1) = sind(delta)*sind(lat)*cosd(gamma)+cosd(delta)*cosd(lat)*cosd(gamma)*cosd(omega);
   at_bt_ct(t,2) = cosd(delta)*sind(gamma)*sind(omega);
   at_bt_ct(t,3) = -sind(delta)*cosd(lat)*sind(gamma)+cosd(delta)*sind(lat)*sind(gamma)*cosd(omega);
 
   
   % Calculation of the direct-beam irradiance I_b = DNI*max(0,cos(AOI))
   Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta(t,3) = I_beam(theta,t,Norm,N,Input_t_GHI_DHI_DNI_Load,at_bt_ct);

   % Calculation of the sky-diffuse irradiance I_d (Reindl model)
   Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta(t,4) = I_diffuse(theta,gamma,t,Norm,N,Input_t_GHI_DHI_DNI_Load, Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta,at_bt_ct);

   % Calculation of the ground-reflected irradiance I_g = GHI*albedo*(1-cosd(gamma))/2
   Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta(t,5) = I_ground(gamma,albedo,t,Norm,N,Input_t_GHI_DHI_DNI_Load);

   % Calculation of total irradiance I=I_b+I_d+I_g;
   Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta(t,2) = Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta(t,3) + Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta(t,4) + Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta(t,5);

   % Remove ground-reflected irradiance (it is independent of the orientation angle theta) from load profile
   Input_t_GHI_DHI_DNI_Load(t,5) = Input_t_GHI_DHI_DNI_Load(t,5) - N*Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta(t,5);
end




% Creation of output graph for 1 PV cell/ 2 PV cells or 3 PV cells,  
% Ground-reflected irradiance is already removed from load profile

 
if (N==1)
   [f,minimum,maximum,optimum_angles] = print_1D_graph(gamma,N,T,Norm,Input_t_GHI_DHI_DNI_Load,Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta,at_bt_ct,range_of_optimum_points);
else if (N==2)
    [f,minimum,maximum,optimum_angles] = print_2D_graph(gamma,N,T,Norm,Input_t_GHI_DHI_DNI_Load,Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta,at_bt_ct,range_of_optimum_points);
    else if (N==3)
    	[f,minimum,maximum,optimum_angles] = print_3D_graph(gamma,N,T,Norm,Input_t_GHI_DHI_DNI_Load,Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta,at_bt_ct,range_of_optimum_points);
        else 
            disp('Error: N is not 1, 2, or 3')
        end
    end
end

