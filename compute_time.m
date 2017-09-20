function flight_time= compute_time(x,y)
global velocity;
flight_distance=hypot(diff(x),diff(y));
flight_time=sum(flight_distance)/velocity;
end

