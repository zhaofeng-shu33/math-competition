function y=isAdjacent(global_index_1,global_index_2)
global total_column;
isAdjacent_difference=global_index_1-global_index_2;
if(mod(isAdjacent_difference,total_column)==0 || abs(isAdjacent_difference)==1)
    y=true;
else
    y=false;
end
end