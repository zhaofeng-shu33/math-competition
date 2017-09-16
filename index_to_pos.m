function [x,y]=index_to_pos(global_index)
%x,y in km
%scale in meter
global scale;
global total_column;
x_offset=floor(global_index/total_column);
y_offset=mod(global_index,total_column)-1;
x=x_offset*scale/1000;
y=y_offset*scale/1000;
end