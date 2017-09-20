function global_index_lst=region_cover_v2()
%reduce 1/25
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
global_index_lst=zeros([total_region,2]);
coverage_cnt=0;
global_index_cnt=1;
for x_pointer=1:total_row
    if(mod(x_pointer,10)==0)
                fprintf('total coverage rate: %f\n',coverage_cnt/total_region);   
    end    
    for y_pointer=1:total_column
        if(M_local(x_pointer,y_pointer)<required_height_2)
            global_index_lst(global_index_cnt,:)=[x_pointer,y_pointer];
            global_index_cnt=global_index_cnt+1;
            %M_local(x_pointer,y_pointer)=inf;
            %coverage_cnt=coverage_cnt+1;
        else
            continue
        end

        for i=x_pointer:total_row
            for j=y_pointer:total_column
                %total_region=total_region+1;
                projection_height=scale*sqrt((i-x_pointer)^2+(j-y_pointer)^2);
                z=limit_height-projection_height*cot(phi_elevation/2);            
                if(M_local(i,j)<required_height_2 && z>=M_local(i,j))
                    %important_region=important_region+1;
                        M_local(i,j)=inf;
                        coverage_cnt=coverage_cnt+1;

                else
                    break;
                end
            end
            if(j==y_pointer)
                break;
            end

        end

        if(coverage_cnt==total_region)
            global_index_lst(global_index_cnt:end,:)=[];
            return
        end
    end
end
global_index_lst(global_index_cnt:end,:)=[];
%fprintf('coverage cnt:%d\n',size_cnt);
