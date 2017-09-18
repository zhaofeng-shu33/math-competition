function traverse_path=region_traverse(global_index_lst)
[x,y]=index_to_pos(global_index_lst);
G=zeros(length(global_index_lst));
for i=1:length(global_index_lst)
    for j=1:i
        G(i,j)=norm([x(i)-x(j),y(i)-y(j)]);
    end
end
traverse_path=graphtraverse(sparse(G),1,'Directed',false);
%use global_index_lst to convert traverse_path_local_index to global 
end


