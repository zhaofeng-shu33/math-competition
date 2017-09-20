function [c,ceq]=circle_constraint(x,terminals,auv_s)
%function prototype for circle constraint
%use anonymous function to provide interface for fmincon
%for example:x = fmincon(fun,[6.5,7.5],[],[],[],[],[],[],user_non_linear_constraint_fun)
%user_non_linear_constraint_fun=@(x) circle_constraint(x,[7,8],[5,6])
global r_aa;
global r_at;
[h_terminals,~]=size(terminals);
[h_auv_s,~]=size(auv_s);
c=zeros(h_terminals+h_auv_s,1);
for i=1:h_terminals
    c(i) = (x(1)-terminals(i,1))^2 + (x(2)-terminals(i,2))^2 - r_at;
end
for i=1:h_auv_s
    c(i+h_terminals) = (x(1)-auv_s(i,1))^2 + (x(2)-auv_s(i,2))^2 - r_aa;
end
ceq = [];
end