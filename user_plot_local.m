function user_plot_local(region_index)
global x_center;
global y_center;
global radius;
global M;
[~,x_offset_1,y_offset_1]=pos_to_index(x_center(region_index)-radius,y_center(region_index)-radius);
[~,x_offset_2,y_offset_2]=pos_to_index(x_center(region_index)+radius,y_center(region_index)+radius);
X=linspace(x_center(region_index)-radius,x_center(region_index)+radius,x_offset_2-x_offset_1+1);
Y=linspace(y_center(region_index)-radius,y_center(region_index)+radius,y_offset_2-y_offset_1+1);
local_matrix=M(x_offset_1:x_offset_2,y_offset_1:y_offset_2);
contour(X,Y,local_matrix',[2800,3000,3500],'ShowText','on')
hold on;
rectangle('Position',[x_center(region_index)-radius,y_center(region_index)-radius,2*radius,2*radius],'Curvature',[1,1])
text(x_center(region_index),y_center(region_index),sprintf('%d',region_index))
end