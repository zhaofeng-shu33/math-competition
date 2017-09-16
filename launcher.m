clc;
global M;
global scale;
global total_row;
global total_column;
M=csvread('height_data.csv');
scale=38.2;
total_row=2775;
total_column=2913;


%user rountine
index_A=pos_to_index(30.3,89.8);
index_start=1;

%compute index max and index min