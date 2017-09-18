function user_plot_global()
global scale;
global total_column;
global total_row;
global x_center;
global y_center;
global radius;
global M;
Y=linspace(0,scale*total_column/1000,total_column);
X=linspace(0,scale*total_row/1000,total_row);
contour(X,Y,M',[2500,3000,4200],'ShowText','on')
hold on
for i=1:length(x_center)
rectangle('Position',[x_center(i)-radius,y_center(i)-radius,2*radius,2*radius],'Curvature',[1,1])
text(x_center(i),y_center(i),sprintf('%d',i))
end
end