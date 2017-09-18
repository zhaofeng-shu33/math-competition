function global_index_lst=min_pos(region_index,required_points)
    global M;
    global limit_height;
    global scale;
    global total_column;
    global required_height;
    global x_center;
    global y_center;
    global phi_elevation;
    global radius;   
%first find the lowest point
rmin=(limit_height-required_height)*tan(phi_elevation/2)/1000;
[~,x_offset_1,y_offset_1]=pos_to_index(x_center(region_index)-radius,y_center(region_index)-radius);
[~,x_offset_2,y_offset_2]=pos_to_index(x_center(region_index)+radius,y_center(region_index)+radius);
global_index_lst=zeros([required_points,1]);
%copy M into a new array
height_bound=1e4;
x_offset_len=x_offset_2-x_offset_1+1;
y_offset_len=y_offset_2-y_offset_1+1;
M_local=M(x_offset_1:x_offset_2,y_offset_1:y_offset_2);
equivalent_radius=radius*1000/scale;
total_region=0;
for i=1:x_offset_len
    for j=1:y_offset_len
        if((i-x_offset_len/2)^2+(j-y_offset_len/2)^2<equivalent_radius*equivalent_radius)
            if(M_local(i,j)<required_height)
            total_region=total_region+1;
            end
        else
             M_local(i,j)=height_bound;
        end
    end
end
fprintf('total region cnt: %d\n',total_region);
coverage_cnt=0;
for r=1:required_points
[min_pos_tmp,min_pos_tmp_index]=min(M_local(:));
fprintf('min_height:%d\n',min_pos_tmp);
auv_y_tmp=floor((min_pos_tmp_index-1)/x_offset_len)+1;
auv_x_tmp=mod(min_pos_tmp_index-1,x_offset_len)+1;
global_index_lst(r)=(auv_x_tmp+x_offset_1-1)*total_column+auv_y_tmp+y_offset_1;
auv_x=scale*(auv_x_tmp+x_offset_1)/1000;
auv_y=scale*(auv_y_tmp+y_offset_1)/1000;
fprintf('min_height_pos:%f,%f\n',auv_x,auv_y);
rectangle('Position',[auv_x-rmin,auv_y-rmin,2*rmin,2*rmin],'Curvature',[1,1])

size_cnt=0;
for i=1:x_offset_len
    for j=1:y_offset_len
        if((i-x_offset_len/2)^2+(j-y_offset_len/2)^2<equivalent_radius*equivalent_radius)
            %total_region=total_region+1;
            projection_height=scale*sqrt((i-auv_x_tmp)^2+(j-auv_y_tmp)^2);
            z=limit_height-projection_height*cot(phi_elevation/2);            
            if(M_local(i,j)<required_height)
                %important_region=important_region+1;
                if z>=M_local(i,j)
                    M_local(i,j)=height_bound;
                    size_cnt=size_cnt+1;
                    coverage_cnt=coverage_cnt+1;
                end                
            end
        end
    end
end
fprintf('coverage cnt:%d\n',size_cnt);
end
fprintf('total coverage rate: %f\n',coverage_cnt/total_region);   