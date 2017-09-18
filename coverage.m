function covered_points_pos=coverage(region_index,auv_pos)
    global M;
    global limit_height;
    global scale;
    global required_height;
    global x_center;
    global y_center;
    global phi_elevation;
    global coverage_matrix;
    global radius;
    %first find the lowest point
[~,x_offset_0,y_offset_0]=pos_to_index(x_center(region_index),y_center(region_index));
[~,x_offset_1,y_offset_1]=pos_to_index(x_center(region_index)-radius,y_center(region_index)-radius);
[~,x_offset_2,y_offset_2]=pos_to_index(x_center(region_index)+radius,y_center(region_index)+radius);
covered_points_pos = zeros([(y_offset_2-y_offset_1)*(x_offset_2-x_offset_1),2]);
equivalent_radius=radius*1000/scale;
%total_region=0;
%important_region=0;
size_cnt=1;
auv_pos_x_index=floor(1000*auv_pos(1)/scale);
auv_pos_y_index=floor(1000*auv_pos(2)/scale);
for i=x_offset_1:x_offset_2
    for j=y_offset_1:y_offset_2
        if((i-x_offset_0)^2+(j-y_offset_0)^2<equivalent_radius*equivalent_radius)
            %total_region=total_region+1;
            projection_height=scale*sqrt((i-auv_pos_x_index)^2+(j-auv_pos_y_index)^2);
            z=limit_height-projection_height*cot(phi_elevation/2);            
            if(M(i,j)<required_height)
                %important_region=important_region+1;
                if z>=M(i,j)
                    coverage_matrix(i,j)=true;
                    covered_points_pos(size_cnt,:)=[i,j]*scale/1000;
                    size_cnt=size_cnt+1;
                end                
            end
        end
    end
end
covered_points_pos(size_cnt:end,:)=[];
    %then push all find points to a new list
    %local computation 
    
end