function maxHeight=getMaxHeight(region_index)
global x_center;
global y_center;
global M;
global radius;
global scale;
[~,x_offset,y_offset]=pos_to_index(x_center(region_index),y_center(region_index));        
[~,x_offset_1,y_offset_1]=pos_to_index(x_center(region_index)-radius,y_center(region_index)-radius);
[~,x_offset_2,y_offset_2]=pos_to_index(x_center(region_index)+radius,y_center(region_index)+radius);
maxHeight=0;
equivalent_radius=radius*1000/scale;
for i1=x_offset_1:x_offset_2
    for j1=y_offset_1:y_offset_2
        if((i1-x_offset)^2+(j1-y_offset)^2<equivalent_radius*equivalent_radius && M(i1,j1)>maxHeight)
             maxHeight=M(i1,j1);
        end
    end
end
    end