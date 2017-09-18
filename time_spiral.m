function time=time_spiral(max_height)
global limit_height;
global velocity;
global radius;
global phi_elevation;
global turning_radius;
assert(limit_height>max_height);
rmin=(limit_height-max_height)*tan(phi_elevation/2)/1000;
d=2*rmin;
b=d/(2*pi);
theta_min=(radius-rmin)/b;
assert(b*(pi^2+1)^1.5>turning_radius*(pi^2+2));
s=0.5*b*(theta_min*sqrt(theta_min*theta_min+1)+asinh(theta_min));
time=(s+b*pi)/velocity;
end