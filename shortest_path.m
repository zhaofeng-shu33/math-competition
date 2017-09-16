%construct shortest_path matrix
    global M;
    global total_row;
    global total_column;
    global C;
    global DG;
    estimated_size=4*total_row*total_column;
    C=zeros([estimated_size,2]);
    size_cnt=1;
    bound=4200;
    for i=1:total_row
        for j=1:total_column
                if M(i,j)<bound
                    if j<total_column && M(i,j+1)<bound
                        C(size_cnt,:)=[total_column*(i-1)+j,total_column*(i-1)+j+1];
                        size_cnt=size_cnt+1;
                        C(size_cnt,:)=[total_column*(i-1)+j+1,total_column*(i-1)+j];
                        size_cnt=size_cnt+1;
                    end
                    if i<total_row && M(i+1,j)<bound
                        C(size_cnt,:)=[total_column*(i-1)+j,total_column*i+j];
                        size_cnt=size_cnt+1;                                       
                        C(size_cnt,:)=[total_column*i+j,total_column*(i-1)+j];                    
                        size_cnt=size_cnt+1;                   
                    end
                end
        end
        disp(i)
    end
    C(size_cnt:end,:)=[];
    weight=ones([length(C),1]);
    max_num=max(max(C));
    DG=sparse(C(:,1),C(:,2),weight,max_num,max_num);
    
%    [dist, path] = graphshortestpath(DG,start_index,end_index);
