function user_plot_global()
global scale;
global total_column;
global total_row;
global M;
Y=linspace(0,scale*total_column/1000,total_column);
X=linspace(0,scale*total_row/1000,total_row);
contour(X,Y,M',[4000,4200],'ShowText','on')
end