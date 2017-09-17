function [x,y]=auv_move(given_path)
global total_column;
global total_row;
global base_pos;
global x_center;
global y_center;
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
for j=2:length(given_path)
    index=shortest_path([x_center(given_path(j-1)),y_center(given_path(j-1))],[x_center(given_path(j)),y_center(given_path(j))]);    
    fprintf('from center %d,to center %d, turn %d\n',given_path(j-1),given_path(j),length(index))
    [x_1,y_1]=index_to_pos(index);
    x=[x,x_1];
    y=[y,y_1];
end
%save(sprintf('Problem_1_toTarget_%d.mat',i),'x6','y6');

end