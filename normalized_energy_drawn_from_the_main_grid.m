function [normalized_energy] = normalized_energy_drawn_from_the_main_grid(gamma,N,T,Norm,Input_t_GHI_DHI_DNI_Load,Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta,theta,at_bt_ct)
    normalized_energy = 0;
    
    for t = 1:T
        Load = Input_t_GHI_DHI_DNI_Load(t,5);
        for n = 1:N
            Load = Load - I_beam(theta(n),t,Norm,N,Input_t_GHI_DHI_DNI_Load,at_bt_ct) - I_diffuse(theta(n),gamma,t,Norm,N,Input_t_GHI_DHI_DNI_Load,Output_t_I_Ib_ReindlId_Ig_At_omega_cosZeta,at_bt_ct);
        end
        normalized_energy = normalized_energy + max(Load ,0);
    end
end

