function coverage(auv_pos)
global M;
global coverage_matrix;
global limit_height;
global scale;
%global computation 
estimated_radius=40;
height_maximun=3000;
auv_pos_x=floor(auv_pos(1)*1000/scale);
auv_pos_y=floor(1000*auv_pos(2)/scale);
for i=-estimated_radius:estimated_radius
    for j=-estimated_radius:estimated_radius
        z=limit_height-(i).^2-(j).^2;
        if M(auv_pos_x+i,auv_pos_y+j)<height_maximun && z>=M(auv_pos_x+i,auv_pos_y+j)
            coverage_matrix(auv_pos_x+i,auv_pos_y+j)=true;
        end
    end
end


end