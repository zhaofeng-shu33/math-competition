clc;
global M;
global scale;
global total_row;
global total_column;
global limit_height;
global x_center;
global y_center;
global radius;
global base_pos;
global safe_distance;
M=csvread('height_data.csv');
scale=38.2;
total_row=2775;
total_column=2913;
limit_height=4200;
x_center=[30.3,66,98.4,73.7,57.9,86.8,93.6];
y_center=[89.8,84.7,76.7,61,47.6,22,48];
base_pos=[110,0];
safe_distance=50;%meter
radius=5;
%user rountine


