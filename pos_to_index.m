function global_index=pos_to_index(x,y)
%x,y in km
%scale in meter
global scale;
global total_column;
x_offset=x*1000/scale;
y_offset=y*1000/scale;
global_index=floor(x_offset)*total_column+floor(y_offset)+1;
end