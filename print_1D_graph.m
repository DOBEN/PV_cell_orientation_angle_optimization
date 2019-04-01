function [f,minimum,maximum,optimum_angles] = print_1D_graph(gamma,N,T,Norm,Input_t_GHI_DHI_DNI_Load,Output_t_I_Ib_ReindlId_Ig_cosAOI_omega,at_bt_ct,range_of_optimum_points)

    f = figure;
    set(f,'position',[50  50 700 700])
 
    theta = zeros(1,1);
    V(1:181,1:181) = 100000;
    [X,Y] = meshgrid(-90:90);
    optimum_angles = zeros(1,1);
   
    for theta_1 = -90:90    
    	theta(1) = theta_1;   
        for i = 1:181
            V(theta_1+91,i) = normalized_energy_drawn_from_the_main_grid(gamma,N,T,Norm,Input_t_GHI_DHI_DNI_Load,Output_t_I_Ib_ReindlId_Ig_cosAOI_omega,theta,at_bt_ct);
        end
    end

    minimum = min(min(V));
    maximum = max(max(V));
 
    axis([-90 90 -90 90 minimum maximum]);
    xticks(-90:45:90);
    yticks([]);
    set(gca,'FontSize',16);
    xlabel ('Orientation Angle of PV Cell 1 (\theta_1)');
    
    % mark all optimum points with red stripes
    hold on
    minimum = round(minimum*range_of_optimum_points)/range_of_optimum_points;
    j = 1;
    for theta_1 = -90:90
        for theta_2 = -90:90
            val = round(V(theta_1+91,theta_2+91)*range_of_optimum_points)/range_of_optimum_points;     
            if val <= minimum
                view(0, 90);
                set(gca,'position',[0.5 0.5 0.4 0.05]);
                plot3(Y(theta_1+91,theta_2+91),X(theta_1+91,theta_2+91),V(theta_1+91,theta_2+91),'.r','markersize',20);
              if theta_2 == 0
                optimum_angles(j,1) = theta_1;
                j = j+1;  
              end         
            end
        end
    end
  
    set(surf(Y,X,V),'edgecolor','none');
    colorBar = colorbar('southoutside');
    colormap(colorBar, flipud(colormap));
    colormap( flipud(colormap) );
    set(colorBar,'position',[0.5 0.35 0.4 0.03]);
    colorBar.Label.String = 'Normalized Energy drawn from the Grid';
    colorBar.Label.FontSize = 16.5;    
end


