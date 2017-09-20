function [x,y]=auv_move(given_path,auv_num)
%first auv:[x,y]=auv_move([5,1],1)
%second auv:[x,y]=auv_move([4,3]),ignore 4
%third auv: to lowest point of 4, then to 2
%global_index_lst=min_pos(4,20);
global total_row;
global base_pos;
global x_center;
global y_center;
global radius;
global scale;
%first compute the line(base_pos to the i-th important region) and
x_start=(total_row-1)*scale/1000;
i=given_path(1);
slope=(base_pos(2)-y_center(i))/(base_pos(1)-x_center(i));
intercept=base_pos(2)-base_pos(1)*slope;
y_start=slope*x_start+intercept;
index=shortest_path([x_start,y_start],[x_center(i),y_center(i)]);    
fprintf('from base,to center %d, turn %d\n',i,length(index))    
[x,y]=index_to_pos(index);
x(1)=base_pos(1);
y(1)=base_pos(2);
if(auv_num==3)
x(length(x))=[];
y(length(y))=[];
end
%use spiral strategy
%first get max height
%maxHeight=getMaxHeight(i);
%fprintf('region %d maxHeight:%d\n',i,maxHeight);
%fprintf('time used to cover region %d:%f\n',i,time_spiral(maxHeight));
%compute angle from i to given_path(2)
if(auv_num==3)
    global_index_lst=min_pos(4,20);
    [next_start_x,next_start_y]=index_to_pos(global_index_lst(1));
    traverse_path=region_traverse(global_index_lst);
for i=1:length(traverse_path)
[x_tmp,y_tmp]=index_to_pos(global_index_lst(traverse_path(i,:)));
x=[x,x_tmp(1)];
y=[y,y_tmp(1)];
end
else
delta_x=x_center(given_path(2))-x_center(i);
delta_y=y_center(given_path(2))-y_center(i);
delta_len=norm([delta_x,delta_y]);
next_start_x=x_center(i)+radius*delta_x/delta_len;
next_start_y=y_center(i)+radius*delta_y/delta_len;
if(auv_num==1)
    [x_tmp,y_tmp]=spiral_discrete(i,given_path(2));
    x=[x,x_tmp];
    y=[y,y_tmp];
end
end
x=[x,next_start_x];
y=[y,next_start_y];
index=shortest_path([next_start_x,next_start_y],[x_center(given_path(2)),y_center(given_path(2))]);    
fprintf('from center periperal %d,to center %d, turn %d\n',given_path(1),given_path(2),length(index))
    [x_1,y_1]=index_to_pos(index);
    x=[x,x_1];
    y=[y,y_1];

   [x_tmp,y_tmp]=spiral_discrete(given_path(2));
    x=[x,x_tmp];
    y=[y,y_tmp];
    
    
    %save(sprintf('Problem_1_toTarget_%d.mat',i),'x6','y6');
end
%load ('51.mat')
%p1=plot(x,y,'g')
%load ('42.mat')
%p2=plot(x,y,'r')
%load ('43.mat')
%p3=plot(x,y,'m')
%legend([p1,p2,p3],'first auv','second auv','third auv')
%title('paths of 3 AUVs')
%xlabel('x/km')
%ylabel('y/km')