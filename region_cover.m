function global_index_lst=region_cover()
    global M;
    global limit_height;
    global scale;
    global total_column;
    global total_row;
    global required_height;
    global required_height_2;
    global phi_elevation;
%first find the lowest point
%copy M into a new array
M_local=M;
total_region=0;
for i=1:total_row
    for j=1:total_column
            if(M_local(i,j)<required_height_2)
            total_region=total_region+1;
            end        
    end
end
fprintf('total region cnt: %d\n',total_region);
global_index_lst=zeros([total_region,1]);
coverage_cnt=0;
global_index_cnt=1;
while true
[min_pos_tmp,min_pos_tmp_index]=min(M_local(:));
fprintf('min_height:%d\n',min_pos_tmp);
auv_y_tmp=floor((min_pos_tmp_index-1)/total_row)+1;
auv_x_tmp=mod(min_pos_tmp_index-1,total_row)+1;
auv_x=scale*auv_x_tmp/1000;
auv_y=scale*auv_y_tmp/1000;
global_index_lst(global_index_cnt)=min_pos_tmp_index;
global_index_cnt=global_index_cnt+1;
%fprintf('min_height_pos:%f,%f\n',auv_x,auv_y);
%rmin=(limit_height-min_pos_tmp)*tan(phi_elevation/2)/1000;
%rectangle('Position',[auv_x-rmin,auv_y-rmin,2*rmin,2*rmin],'Curvature',[1,1])

size_cnt=0;
for i=1:total_row
    for j=1:total_column
            %total_region=total_region+1;
            projection_height=scale*sqrt((i-auv_x_tmp)^2+(j-auv_y_tmp)^2);
            z=limit_height-projection_height*cot(phi_elevation/2);            
            if(M_local(i,j)<required_height)
                %important_region=important_region+1;
                if z>=M_local(i,j)
                    M_local(i,j)=inf;
                    size_cnt=size_cnt+1;
                    coverage_cnt=coverage_cnt+1;
                end                
            end
     
    end
end
fprintf('total coverage rate: %f\n',coverage_cnt/total_region);   
if(coverage_cnt==total_region)
    break;
end
%fprintf('coverage cnt:%d\n',size_cnt);
end
