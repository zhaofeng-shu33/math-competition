function [node_type,mixed_pos,DG]=communication(max_iteration)
global r_aa;
global r_at;
global activity_range_radius;
equivalent_r_at=r_at-activity_range_radius;
terminal_pos=csvread('terminal.csv');
estimated_graph_size=4*length(terminal_pos(:,1));
node_type=zeros([estimated_graph_size,1]);
mixed_pos=zeros([estimated_graph_size,2]);
DG=zeros(estimated_graph_size);
size_cnt=3;
%first add auv between the first two terminal
distance_first_two=norm(terminal_pos(2,:)-terminal_pos(1,:));
mixed_pos(1,:)=terminal_pos(1,:);
mixed_pos(2,:)=terminal_pos(2,:);
if(distance_first_two<equivalent_r_at*2)%one auv is enough
    %add this auv to the node center
    mixed_pos(size_cnt,:)=(terminal_pos(2,:)+terminal_pos(1,:))/2;
    DG(1,3)=1;DG(3,1)=1;
    DG(2,3)=1;DG(3,2)=1;    
    node_type(3)=1;%type:auv
    size_cnt=size_cnt+1;
else
    add_new_auv_num=floor((distance_first_two-2*equivalent_r_at)/r_aa)+2;
    mixed_pos(size_cnt,:)=(equivalent_r_at*terminal_pos(2,:)+(distance_first_two-equivalent_r_at)*terminal_pos(1,:))/distance_first_two;
    size_cnt=size_cnt+1;
    node_type(3)=1;
    mixed_pos(size_cnt,:)=(equivalent_r_at*terminal_pos(1,:)+(distance_first_two-equivalent_r_at)*terminal_pos(2,:))/distance_first_two;
    node_type(4)=1;    
    size_cnt=size_cnt+1;
    DG(1,3)=1;DG(3,1)=1;
    DG(2,4)=1;DG(4,2)=1;
    %add interval auv
    increment_tmp=r_aa+equivalent_r_at;
    while(add_new_auv_num>2)
        add_new_auv_num=add_new_auv_num-1;
        mixed_pos(size_cnt,:)=(increment_tmp*terminal_pos(1,:)+(distance_first_two-increment_tmp)*terminal_pos(2,:))/distance_first_two;
        node_type(size_cnt)=1;                 
        DG(size_cnt,size_cnt-1)=1;DG(size_cnt-1,size_cnt)=1;
        size_cnt=size_cnt+1;
        increment_tmp=increment_tmp+r_aa;
    end
    if(increment_tmp>(r_aa+equivalent_r_at))
        DG(3,size_cnt-1)=1;DG(size_cnt-1,3)=1;
    end
end
for considered_pos=3:min(max_iteration,length(terminal_pos))
    assert(size_cnt<estimated_graph_size);
    current_terminal_pos=terminal_pos(considered_pos,:);    
    mixed_pos(size_cnt,:)=current_terminal_pos;
    size_cnt=size_cnt+1;
    min_candidate_auv=3;
    min_candidate_dis=inf;
    for candidate_auv=3:(size_cnt-1)
        if(~node_type(candidate_auv))%ignore terminal type
            continue
        end
        tmp_norm=norm(mixed_pos(candidate_auv,:)-current_terminal_pos);
        if(tmp_norm<equivalent_r_at)
            DG(candidate_auv,size_cnt-1)=1;DG(size_cnt-1,candidate_auv)=1;
        end
        if(min_candidate_dis>tmp_norm)
            min_candidate_dis=tmp_norm;
            min_candidate_auv=candidate_auv;
        end
%         gathering terminal constraint
%         connected_nodes_index=find(DG(candidate_auv,:)>0);
%         terminal_pos=[];
%         auv_pos=[];
%         for i=1:length(connected_nodes_index)
%             if(node(connected_nodes_index(i))<1)% terminal constraint
%                 terminal_pos=[terminal_pos;mixed_pos(connected_nodes_index(i))];
%             else
%                 i_is_added=false;
%                 for j=(i+1):length(connected_nodes_index)
%                     if(node(connected_nodes_index(i))>0 && norm(mixed_pos(connected_nodes_index(i))-mixed_pos(connected_nodes_index(j)))>r_aa)% i,j are two auv index
%                         if(~i_is_added)
%                         auv_pos=[auv_pos;mixed_pos(connected_nodes_index(i))];
%                         end
%                         auv_pos=[auv_pos;mixed_pos(connected_nodes_index(j))];      
%                         i_is_added=true;
%                     end
%                 end
%             end
%         end
%         user_non_linear_constraint_fun=@(x) circle_constraint(x,terminal_pos,auv_pos);  
%         fun_to_min=@(x) (current_terminal_pos(1)-x(1))^2+(current_terminal_pos(2)-x(2))^2;
%         optimized_pos = fmincon(fun_to_min,mixed_pos(candidate_auv,:),[],[],[],[],[],[],user_non_linear_constraint_fun);
%         if(norm(current_terminal_pos-optimized_pos)<equivalent_r_at)%no need to add auv
%             %recompute the graph connection 
%             break;
%         end
    end
    if(sum(DG(candidate_auv,:))>0)%already has auv
        continue;
    else  %append auv between min_candidate_auv and  terminal |size_cnt|
        candidate_auv_pos=mixed_pos(min_candidate_auv,:);
        add_new_auv_num=floor((min_candidate_dis-equivalent_r_at)/r_aa)+1;
        mixed_pos(size_cnt,:)=(equivalent_r_at*candidate_auv_pos+(min_candidate_dis-equivalent_r_at)*current_terminal_pos)/min_candidate_dis;
        node_type(size_cnt)=1;
        DG(size_cnt,size_cnt-1)=1;DG(size_cnt-1,size_cnt)=1;        
        last_size_cnt=size_cnt;        
        size_cnt=size_cnt+1;
        %add interval auv
        increment_tmp=r_aa;
        while(add_new_auv_num>1)
            add_new_auv_num=add_new_auv_num-1;
            mixed_pos(size_cnt,:)=(increment_tmp*current_terminal_pos+(min_candidate_dis-increment_tmp)*candidate_auv_pos)/min_candidate_dis;
            node_type(size_cnt)=1;
            if(increment_tmp>r_aa)
            DG(size_cnt,size_cnt-1)=1;DG(size_cnt-1,size_cnt)=1;
            else
            DG(size_cnt,min_candidate_auv)=1;DG(min_candidate_auv,size_cnt)=1;
            end
            size_cnt=size_cnt+1;
            increment_tmp=increment_tmp+r_aa;
        end
        if(increment_tmp>r_aa)
            DG(last_size_cnt,size_cnt-1)=1;DG(size_cnt-1,last_size_cnt)=1;
        end
        
    end
end


%trim task
node_type(size_cnt:end)=[];
mixed_pos(size_cnt:end,:)=[];
DG(size_cnt:end,:)=[];
DG(:,size_cnt:end)=[];
%plotting routine
p1=scatter(mixed_pos(:,1),mixed_pos(:,2));
hold on
auv_pos=mixed_pos(node_type>0,:);
p2=scatter(auv_pos(:,1),auv_pos(:,2),'r');
legend([p1,p2],'terminal','auv');
title('communicaton relay deployment');
xlabel('x/km');
ylabel('y/km');
grid on;
end