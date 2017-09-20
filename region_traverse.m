function traverse_path=region_traverse(global_index_lst)
%tsp integer programming problem
nStops=length(global_index_lst);
idxs = nchoosek(1:nStops,2);
[x,y]=index_to_pos(global_index_lst);
dist = hypot(x(idxs(:,1)) - x(idxs(:,2)), ...
             y(idxs(:,1)) - y(idxs(:,2)));
lendist = length(dist);
Aeq = spones(1:length(idxs)); % Adds up the number of trips
beq = nStops;
Aeq = [Aeq;spalloc(nStops,length(idxs),nStops*(nStops-1))]; % allocate a sparse matrix
for ii = 1:nStops
    whichIdxs = (idxs == ii); % find the trips that include stop ii
    whichIdxs = sparse(sum(whichIdxs,2)); % include trips where ii is at either end
    Aeq(ii+1,:) = whichIdxs'; % include in the constraint matrix
end
beq = [beq; 2*ones(nStops,1)];
intcon = 1:lendist;
lb = zeros(lendist,1);
ub = ones(lendist,1);

opts = optimoptions('intlinprog','Display','off');
x_tsp= intlinprog(dist,intcon,[],[],Aeq,beq,lb,ub,opts);


%traverse_path=graphtraverse(sparse(G),1,'Directed',false);
%use global_index_lst to convert traverse_path_local_index to global 

tours = detectSubtours(x_tsp,idxs);
numtours = length(tours); % number of subtours
fprintf('# of subtours: %d\n',numtours);
A = spalloc(0,lendist,0); % Allocate a sparse linear inequality constraint matrix
b = [];
while numtours > 1 % repeat until there is just one subtour
    % Add the subtour constraints
    b = [b;zeros(numtours,1)]; % allocate b
    A = [A;spalloc(numtours,lendist,nStops)]; % a guess at how many nonzeros to allocate
    for ii = 1:numtours
        rowIdx = size(A,1)+1; % Counter for indexing
        subTourIdx = tours{ii}; % Extract the current subtour
%         The next lines find all of the variables associated with the
%         particular subtour, then add an inequality constraint to prohibit
%         that subtour and all subtours that use those stops.
        variations = nchoosek(1:length(subTourIdx),2);
        for jj = 1:length(variations)
            whichVar = (sum(idxs==subTourIdx(variations(jj,1)),2)) & ...
                       (sum(idxs==subTourIdx(variations(jj,2)),2));
            A(rowIdx,whichVar) = 1;
        end
        b(rowIdx) = length(subTourIdx)-1; % One less trip than subtour stops
    end

    % Try to optimize again
    x_tsp = intlinprog(dist,intcon,A,b,Aeq,beq,lb,ub,opts);
    % Visualize result
    
    
    % How many subtours this time?
    tours = detectSubtours(x_tsp,idxs);
    numtours = length(tours); % number of subtours
    fprintf('# of subtours: %d\n',numtours);
end

segments = find(x_tsp);% Get indices of lines on optimal path
traverse_path=idxs(segments,:);
%plotting rountine
for i=1:length(traverse_path)
[x,y]=index_to_pos(global_index_lst(traverse_path(i,:)));
plot(x,y,'r');
end


end
