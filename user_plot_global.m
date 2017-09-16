global scale;
global total_column;
global total_row;
global radius;
global x_center;
global y_center;
radius=5;
x_center=[30.3,66,98.4,73.7,57.9,86.8,93.6];
y_center=[89.8,84.7,76.7,61,47.6,22,48];
Y=linspace(0,scale*total_column/1000,total_column);
X=linspace(0,scale*total_row/1000,total_row);
contour(X,Y,M',[3000,4200],'ShowText','on')
hold on
for i=1:length(x_center)
rectangle('Position',[x_center(i)-radius,y_center(i)-radius,2*radius,2*radius],'Curvature',[1,1])
end