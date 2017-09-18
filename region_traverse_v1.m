function traverse_path=region_traverse_v1(region_index)
assert(region_index==4);
%statistic of 4 <3000 coverage
% /approx 1/4
% construct graph for <3000
global x_center;
global y_center;
global radius;
global M;
global required_height;
global scale;
global total_column;
[starting_index,x_offset_0,y_offset_0]=pos_to_index(x_center(region_index),y_center(region_index));
[~,x_offset_1,y_offset_1]=pos_to_index(x_center(region_index)-radius,y_center(region_index)-radius);
[~,x_offset_2,y_offset_2]=pos_to_index(x_center(region_index)+radius,y_center(region_index)+radius);
equivalent_radius=radius*1000/scale;

estimated_size=4*(x_offset_2-x_offset_1)*(y_offset_2-y_offset_1);
C=zeros([estimated_size,2]);
weight=ones([length(C),1]);
size_cnt=1;

for i=x_offset_1:x_offset_2
    for j=y_offset_1:y_offset_2
        if((i-x_offset_0)^2+(j-y_offset_0)^2<equivalent_radius*equivalent_radius)
            if j<y_offset_2 && M(i,j+1)<required_height
                C(size_cnt,:)=[total_column*(i-1)+j+1,total_column*(i-1)+j];
                starting_index=total_column*(i-1)+j+1;%random give a starting_index
                size_cnt=size_cnt+1;
            end
            %to downside
            if i<x_offset_2
                if M(i+1,j)<required_height
                    C(size_cnt,:)=[total_column*i+j,total_column*(i-1)+j];
                    size_cnt=size_cnt+1;
                end
                %to downright-side
                if j<y_offset_2 && M(i+1,j+1)<required_height
                    C(size_cnt,:)=[total_column*i+j+1,total_column*(i-1)+j];
                    weight(size_cnt)=1.414;
                    size_cnt=size_cnt+1;
                end
                if j>y_offset_1 && M(i+1,j-1)<required_height
                    C(size_cnt,:)=[total_column*i+j-1,total_column*(i-1)+j];
                    weight(size_cnt)=1.414;
                    size_cnt=size_cnt+1;
                end
            end
        end
    end
end
    C(size_cnt:end,:)=[];
    weight(size_cnt:end)=[];
    maxCnt=max(C(:));
    DG=sparse(C(:,1),C(:,2),weight,maxCnt,maxCnt);
    
    
    assert(~isempty(find(C==starting_index)));
    %starting point=center of important region
    traverse_path=graphtraverse(DG,starting_index,'Directed',false);

end


