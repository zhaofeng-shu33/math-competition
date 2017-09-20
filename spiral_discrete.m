function [x_tmp,y_tmp]=spiral_discrete(from_center_index,target_center_index)
global x_center;
global y_center;
global radius;
global required_height;
global limit_height;
global phi_elevation;
rmin=(limit_height-required_height)*tan(phi_elevation/2)/1000;
b=rmin/pi;
theta_sample=linspace(0,radius/b,50);

if(nargin==2)
delta_x=x_center(target_center_index)-x_center(from_center_index);
delta_y=y_center(target_center_index)-y_center(from_center_index);


%next_start_x=x_center(i)+radius*delta_x/delta_len;
%next_start_y=y_center(i)+radius*delta_y/delta_len;
 


    %add spiral plot
    tmp_phi=radius/b-atan(delta_y/delta_x);
    if(delta_x<0)
        tmp_phi=tmp_phi-pi;
    end
else
    tmp_phi=0;
end
    x_tmp=x_center(from_center_index)+b*theta_sample.*cos(theta_sample-tmp_phi);
    y_tmp=y_center(from_center_index)+b*theta_sample.*sin(theta_sample-tmp_phi);
    %plot(x_tmp,y_tmp,'g');
end