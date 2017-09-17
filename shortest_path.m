function optimized_path_index=shortest_path(start_pos,end_pos)
%construct shortest_path matrix
    global M;
    global total_row;
    global total_column;
    global limit_height;
    global safe_distance;
    limit_height_inner=limit_height-safe_distance;
%first, find the limit_height_innering box between the start_index and end_index    
    [global_index_start,x_offset_start,y_offset_start]=pos_to_index(start_pos(1),start_pos(2));
    [global_index_end,x_offset_end,y_offset_end]=pos_to_index(end_pos(1),end_pos(2));
    row_lower=min(x_offset_start,x_offset_end);
    row_higher=max(x_offset_start,x_offset_end);
    column_lower=min(y_offset_start,y_offset_end);
    column_higher=max(y_offset_start,y_offset_end);
    estimated_size=8*(column_higher-column_lower)*(row_higher-row_lower);
    C=zeros([estimated_size,2]);
    weight=ones([length(C),1]);

    size_cnt=1;  
    for i=row_lower:row_higher
        for j=column_lower:column_higher
                if M(i,j)<limit_height_inner
                    %to rightside
                    if j<total_column && M(i,j+1)<limit_height_inner
                        C(size_cnt,:)=[total_column*(i-1)+j,total_column*(i-1)+j+1];
                        size_cnt=size_cnt+1;
                    end
                    %to downside
                    if i<total_row 
                        if M(i+1,j)<limit_height_inner
                            C(size_cnt,:)=[total_column*(i-1)+j,total_column*i+j];
                            size_cnt=size_cnt+1;                                       
                        end
                    %to downright-side
                        if j<total_column && M(i+1,j+1)<limit_height_inner
                            C(size_cnt,:)=[total_column*(i-1)+j,total_column*i+j+1];
                            weight(size_cnt)=1.414;
                            size_cnt=size_cnt+1;
                        end
                        if j>1 && M(i+1,j-1)<limit_height_inner
                            C(size_cnt,:)=[total_column*(i-1)+j,total_column*i+j-1];
                            weight(size_cnt)=1.414;                            
                            size_cnt=size_cnt+1;                                       
                        end    
                    end
                end
        end
    end
    C(size_cnt:end,:)=[];
    weight(size_cnt:end)=[];
    %max_num=max(max(C));
    %DG=sparse(C(:,1),C(:,2),weight,max_num,max_num);
    DG=graph(C(:,1),C(:,2),weight);
    optimized_path=shortestpath(DG,global_index_start,global_index_end);

    disp('compute turning')
    %compute all turning point
    size_cnt=1;
    turning_points=zeros([length(optimized_path),1]);
    %turning_points(1)=optimized_path(1);
    mode=-1;%0, left-right; 1 up-down; 2 left-diagonal; 3 right-diagonal
    for i=2:length(optimized_path)
        if(mode==0 && abs(optimized_path(i)-optimized_path(i-1))==1)
            continue;
        elseif(mode==1 && abs(optimized_path(i)-optimized_path(i-1))==total_column)
            continue;
        elseif(mode==2 && abs(optimized_path(i)-optimized_path(i-1))==total_column+1)
            continue;
        elseif(mode==3 && abs(optimized_path(i)-optimized_path(i-1))==total_column-1)
            continue;
        else
            turning_points(size_cnt)=optimized_path(i-1);
            size_cnt=size_cnt+1;
            if(abs(optimized_path(i)-optimized_path(i-1))==1)
                mode=0;
            elseif(abs(optimized_path(i)-optimized_path(i-1))==total_column)
                mode=1;
            elseif(abs(optimized_path(i)-optimized_path(i-1))==total_column+1)
                mode=2;
            elseif(abs(optimized_path(i)-optimized_path(i-1))==total_column-1)
                mode=3;
            else
                disp('fatal error!')
                break
            end
        end
    end     
    turning_points(size_cnt)=global_index_end;
    size_cnt=size_cnt+1;
    turning_points(size_cnt:end)=[];
    %use visibility graph to optimize the path
    fprintf('turning pt cnt:%d\n',length(turning_points))
    disp('final optimize')
    [turning_points_x,turning_points_y,turning_points_x_offset,turning_points_y_offset]=index_to_pos(turning_points);
    size_cnt=1;
    C=zeros([length(turning_points)*(length(turning_points)-1)/2,2]);
    weight=ones([length(turning_points)*(length(turning_points)-1)/2,1]);    
    for i=1:length(turning_points)
        hasConnection=false;
        for j=(i+1):length(turning_points)
            if(LineOfSight([turning_points_x_offset(i),turning_points_y_offset(i)],[turning_points_x_offset(j),turning_points_y_offset(j)]))
                weight(size_cnt)=norm([turning_points_x(i)-turning_points_x(j),turning_points_y(i)-turning_points_y(j)]);
                C(size_cnt,:)=[turning_points(i),turning_points(j)];
                size_cnt=size_cnt+1;
                hasConnection=true;
            end
        end
        if(~hasConnection) 
            disp(i)
        end
    end
    C(size_cnt:end,:)=[];
    weight(size_cnt:end)=[];
    DG=graph(C(:,1),C(:,2),weight);
    optimized_path_index=shortestpath(DG,global_index_start,global_index_end);
    
end
