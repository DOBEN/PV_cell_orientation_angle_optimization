function [f,minimum,maximum,optimum_angles] = print_3D_graph(gamma,N,T,Norm,Input_t_GHI_DHI_DNI_Load,Output_t_I_Ib_ReindlId_Ig_cosAOI_omega,at_bt_ct,range_of_optimum_points)

    f = figure;
    set(f,'position',[50  50 900 800])

    theta = zeros(1,3);
    V(1:181,1:181,1:181) = 100000;
    [X,Y,Z] = meshgrid(-90:1:90);
    optimum_angles = zeros(1,3);
    maximum = 0;
   
    %Generates several layers
    for theta_1 = -90:1:90
    	for theta_2 = -90:1:90 
        	for theta_3 = -90:1:90 
            	theta(1) = theta_1;
                theta(2) = theta_2;
                theta(3) = theta_3;
                V(theta_1+91,theta_2+91,theta_3+91) = normalized_energy_drawn_from_the_main_grid(gamma,N,T,Norm,Input_t_GHI_DHI_DNI_Load,Output_t_I_Ib_ReindlId_Ig_cosAOI_omega,theta,at_bt_ct);
            end
        end
    end

    %Generates one x-layer
%     for theta_1 = 0:1:0
%     	for theta_2 = -90:1:90 
%         	for theta_3 = -90:1:90 
%             	theta(1) = theta_1;
%                 theta(2) = theta_2;
%                 theta(3) = theta_3;
%                 V(theta_1+91,theta_2+91,theta_3+91) = normalized_energy_drawn_from_the_main_grid(gamma,N,T,Norm,Input_t_GHI_DHI_DNI_Load,Output_t_I_Ib_ReindlId_Ig_cosAOI_omega,theta,at_bt_ct); 
%             end
%         end
%     end

    minimum = min(min(min(V)));
    maximum = max(max(max(V)));
    
    for i = 1:2
    	if i == 1  
        	subplot(3,2,[1,3]);              
        end
        if i== 2
        	subplot(3,2,[2,4]);
        end

        xslice = [];
        yslice = 0;
        zslice = [-90,-45,0,45,90];
            
        set(slice(X,Y,Z,V,xslice,yslice,zslice),'edgecolor','none')
        axis([-90 90 -90 90 -90 90 minimum maximum])
        xticks(-90:45:90)
        yticks(-90:45:90)
        zticks(-90:45:90)
%       set(gca,'Ydir','reverse') % This should be active for the second
%       column in Table V (see reference to paper in the main file)
            
        % mark all optimum points with red points
        hold on
        minimum = round(minimum*range_of_optimum_points)/range_of_optimum_points;  
        j = 1;
        for theta_1 = -90:90  
        	for theta_2 = -90:90
            	for theta_3 = -90:90
                    val = round(V(theta_1+91,theta_2+91,theta_3+91)*range_of_optimum_points)/range_of_optimum_points;
                	if val <= minimum                          
                    	plot3(theta_2,theta_1,theta_3,'.r','markersize',20)
                        if i == 1 
                        	optimum_angles(j,1) = theta_1;
                            optimum_angles(j,2) = theta_2;
                            optimum_angles(j,3) = theta_3;
                            j = j+1;
                        end
                    end
                end
            end
        end
    
        if i == 1
            view(10,20)
        else if i == 2
                view(10,-20)     
            end
        end
     
        handle = get(gca,'xlabel'); 
        pos = get(handle,'position'); 
        pos(2) = 1.1*pos(2) ;                       
        set(handle,'position',pos);

        handle = get(gca,'ylabel'); 
        pos = get(handle,'position');
        pos(3) = -95 ;        
        pos(1) = pos(1)*1.05 ;
        set(handle,'position',pos);

        handle = get(gca,'zlabel');
        pos = get(handle,'position'); 
        pos(2) = 0.5*pos(2) ;                   
        set(handle,'position',pos);
            
        set(gca,'FontSize',17)
        xlabel ('\theta_1');
        ylabel ('\theta_2');
        zlabel ('\theta_3');                
    end
    
    set(gca,'FontSize',17)
    colorBar = colorbar('southoutside');
    colorBar.Label.FontSize = 22; 
    colormap(colorBar, flipud(colormap));
    colormap(flipud(colormap));
    set(colorBar,'Position',[0.1 0.3 0.85  0.02])
    colorBar.Label.String = 'Normalized Energy drawn from the Grid        ';      
end

