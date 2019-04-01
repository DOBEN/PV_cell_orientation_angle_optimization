function [f,minimum,maximum,optimum_angles] =  print_2D_graph(gamma,N,T,Norm,Input_t_GHI_DHI_DNI_Load,Output_t_I_Ib_ReindlId_Ig_cosAOI_omega,at_bt_ct,range_of_optimum_points)
  
    f = figure;
    set(f,'position',[100  100 550 450])

    theta = zeros(1,2);
    V(1:181,1:181) = 100000;
    [X,Y] = meshgrid(-90:1:90);
    optimum_angles = zeros(1,2);
   
    for theta_1 = -90:90
        for theta_2 = -90:90
            theta(1) = theta_1;
            theta(2) = theta_2;
            V(theta_1+91,theta_2+91) = normalized_energy_drawn_from_the_main_grid(gamma,N,T,Norm,Input_t_GHI_DHI_DNI_Load,Output_t_I_Ib_ReindlId_Ig_cosAOI_omega,theta,at_bt_ct);
        end
    end

    minimum = min(min(V));
    maximum = max(max(V));    

    set(surf(X,Y,V),'edgecolor','none');
    set(gca,'position',[0.2 0.2 0.6 0.6]);
    axis([-90 90 -90 90 minimum maximum]);
    xticks(-90:45:90);
    yticks(-90:45:90);
    set(gca,'FontSize',14);
    
    colormap( flipud(colormap) );
    colorBar = colorbar;
    colorBar.Label.String ='Normalized Energy drawn from the Grid         ';
    colorBar.Label.FontSize = 14;
    set(gca,'FontSize',14)

    xlabel ('Orientation Angle of PV Cell 1 (\theta_1)');
    ylabel ('Orientation Angle of PV Cell 2 (\theta_2)    ');
    zlabel ('Normalized Energy drawn from the Grid ');

    % mark all optimum points with red points
    hold on
    minimum = round(minimum*range_of_optimum_points)/range_of_optimum_points;
    j = 1;
    for theta_1 = -90:90
        for theta_2 = -90:90  
            val=round(V(theta_1+91,theta_2+91)*range_of_optimum_points)/range_of_optimum_points;
            if val <= minimum    
                view(0, 90);
                plot3(X(theta_1+91,theta_2+91),Y(theta_1+91,theta_2+91),V(theta_1+91,theta_2+91),'.r','markersize',20);
                optimum_angles(j,1) = theta_1;
                optimum_angles(j,2) = theta_2;
                j = j+1;  
            end
        end
    end  
end

