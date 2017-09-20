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
global velocity;
global phi_elevation;
global turning_radius;
global required_height;
global coverage_matrix;
global required_height_2;
global r_aa;
global r_at;
global activity_range_radius;
M=csvread('height_data.csv');
scale=38.2;
total_row=2775;
total_column=2913;
limit_height=4200;
velocity=60;
phi_elevation=pi/3;
turning_radius=0.1;
x_center=[30.3,66,98.4,73.7,57.9,86.8,93.6];
y_center=[89.8,84.7,76.7,61,47.6,22,48];
base_pos=[110,0];
safe_distance=50;%meter
radius=5;
required_height=3000;
required_height_2=4000;
r_aa=6;%km
r_at=3;%km
activity_range_radius=2;%km
coverage_matrix=logical(zeros(size(M)));
%user rountine


