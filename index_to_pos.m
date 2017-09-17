function [x,y,x_offset,y_offset]=index_to_pos(global_index)
%x,y in km
%scale in meter
global scale;
global total_column;
x_offset=floor((global_index-1)/total_column);
y_offset=mod(global_index-1,total_column);
x=x_offset*scale/1000;
y=y_offset*scale/1000;
x_offset=x_offset+1;
y_offset=y_offset+1;
end