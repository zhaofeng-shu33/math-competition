function [global_index,x_offset,y_offset]=pos_to_index(x,y)
%x,y in km
%scale in meter
global scale;
global total_column;
x_offset=floor(x*1000/scale);
y_offset=floor(y*1000/scale);
global_index=x_offset*total_column+y_offset+1;
x_offset=x_offset+1;
y_offset=y_offset+1;
end