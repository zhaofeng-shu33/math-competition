function Optimal_path=theta_star(start_pos,end_pos)
global total_row;
global total_column;
global M;
global limit_height;
%starting node
xStart=start_pos(1);%Starting Position
yStart=start_pos(2);%Starting Position
%target node
xTarget=end_pos(1);%X Coordinate of the Target
yTarget=end_pos(2);%Y Coordinate of the Target


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LISTS USED FOR ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%OPEN LIST STRUCTURE
%--------------------------------------------------------------------------
%IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
%--------------------------------------------------------------------------
OPEN=[];
%CLOSED LIST STRUCTURE
%--------------
%X val | Y val |
%--------------
% CLOSED=zeros(MAX_VAL,2);
CLOSED=[];

%Put all obstacles on the Closed list
k=1;%Dummy counter
for i=1:total_row
    for j=1:total_column
        if(M(i,j) > limit_height)
            CLOSED(k,1)=i; 
            CLOSED(k,2)=j; 
            k=k+1;
        end
    end
end
CLOSED_COUNT=size(CLOSED,1);
%set the starting node as the first node
xNode=xStart;
yNode=yStart;
OPEN_COUNT=1;
path_cost=0;
goal_distance=distance(xNode,yNode,xTarget,yTarget);
OPEN(OPEN_COUNT,:)=insert_open(xNode,yNode,xNode,yNode,path_cost,goal_distance,goal_distance);
OPEN(OPEN_COUNT,1)=0;
CLOSED_COUNT=CLOSED_COUNT+1;
CLOSED(CLOSED_COUNT,1)=xNode;
CLOSED(CLOSED_COUNT,2)=yNode;
NoPath=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while((xNode ~= xTarget || yNode ~= yTarget) && NoPath == 1)
    inode=node_index(OPEN,xNode,yNode);
    %Traverse OPEN and determine the parent nodes
    parent_x=OPEN(inode,4);%node_index returns the index of the node
    parent_y=OPEN(inode,5);
 exp_array=expand_array(xNode,yNode,path_cost,xTarget,yTarget,CLOSED,total_row,total_column);
 exp_count=size(exp_array,1);
 %UPDATE LIST OPEN WITH THE SUCCESSOR NODES
 %OPEN LIST FORMAT
 %--------------------------------------------------------------------------
 %IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
 %--------------------------------------------------------------------------
 %EXPANDED ARRAY FORMAT
 %--------------------------------
 %|X val |Y val ||h(n) |g(n)|f(n)|
 %--------------------------------
 for i=1:exp_count
    flag=0;
    for j=1:OPEN_COUNT
        if(exp_array(i,1) == OPEN(j,2) && exp_array(i,2) == OPEN(j,3) )%exp_array(i) belongs to OPEN[]
            %first judge whether it is visible from [xNode,yNode]'s parent node to OPEN(i,)
            if(LineOfSight([parent_x,parent_y],[OPEN(j,2),OPEN(j,3)]))
                estimated_cost=OPEN(inode,6)+distance(parent_x,parent_y,exp_array(i,1),exp_array(i,2))+exp_array(i,4);
                if OPEN(j,8)>estimated_cost
                    %UPDATE PARENTS,gn,hn
                    OPEN(j,8)=estimated_cost;
                    OPEN(j,4)=parent_x;
                    OPEN(j,5)=parent_y;
                    OPEN(j,6)=OPEN(inode,6);
                    OPEN(j,7)=OPEN(j,8)-OPEN(j,6);                
                end
            %then common A star algorithm    
            elseif OPEN(j,8)> exp_array(i,5)
                %UPDATE PARENTS,gn,hn
                OPEN(j,8)=exp_array(i,5);
                OPEN(j,4)=xNode;
                OPEN(j,5)=yNode;
                OPEN(j,6)=exp_array(i,3);
                OPEN(j,7)=exp_array(i,4);
            end;%End of minimum fn check
            flag=1;
        end;%End of node check
%         if flag == 1
%             break;
    end;%End of j for
    if flag == 0
        OPEN_COUNT = OPEN_COUNT+1;
        OPEN(OPEN_COUNT,:)=insert_open(exp_array(i,1),exp_array(i,2),xNode,yNode,exp_array(i,3),exp_array(i,4),exp_array(i,5));
     end;%End of insert new element into the OPEN list
 end;%End of i for
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %END OF WHILE LOOP
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Find out the node with the smallest fn 
  index_min_node = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget);
  if (index_min_node ~= -1)    
   %Set xNode and yNode to the node with minimum fn
   xNode=OPEN(index_min_node,2);
   yNode=OPEN(index_min_node,3);
   path_cost=OPEN(index_min_node,6);%Update the cost of reaching the parent node
  %Move the Node to list CLOSED
  CLOSED_COUNT=CLOSED_COUNT+1;
  CLOSED(CLOSED_COUNT,1)=xNode;
  CLOSED(CLOSED_COUNT,2)=yNode;
  OPEN(index_min_node,1)=0;
  else
      %No path exists to the Target!!
      NoPath=0;%Exits the loop!
  end;%End of index_min_node check
end;%End of While Loop
%Once algorithm has run The optimal path is generated by starting of at the
%last node(if it is the target node) and then identifying its parent node
%until it reaches the start node.This is the optimal path

i=size(CLOSED,1);
Optimal_path=[];
xval=CLOSED(i,1);
yval=CLOSED(i,2);
i=1;
Optimal_path(i,1)=xval;
Optimal_path(i,2)=yval;
i=i+1;

if((xval == xTarget) && (yval == yTarget))
    inode=node_index(OPEN,xval,yval);
   %Traverse OPEN and determine the parent nodes
   parent_x=OPEN(inode,4);%node_index returns the index of the node
   parent_y=OPEN(inode,5);
   
   while( parent_x ~= xStart || parent_y ~= yStart)
           Optimal_path(i,1) = parent_x;
           Optimal_path(i,2) = parent_y;
           %Get the grandparents:-)
           inode=node_index(OPEN,parent_x,parent_y);
           parent_x=OPEN(inode,4);%node_index returns the index of the node
           parent_y=OPEN(inode,5);
           i=i+1;
    end;
%Plot the Optimal Path!
else
 disp('no path found!')
end

%function definition
function dist = distance(x1,y1,x2,y2)
    %This function calculates the distance between any two cartesian 
    %coordinates.
    %   Copyright 2009-2010 The MathWorks, Inc.
    dist=sqrt((x1-x2)^2 + (y1-y2)^2);
end
function exp_array=expand_array(node_x,node_y,hn,xTarget,yTarget,CLOSED,MAX_X,MAX_Y)
    %Function to return an expanded array
    %This function takes a node and returns the expanded list
    %of successors,with the calculated fn values.
    %The criteria being none of the successors are on the CLOSED list.
    %
    %   Copyright 2009-2010 The MathWorks, Inc.
    
    exp_array=[];
    exp_count=1;
    c2=size(CLOSED,1);%Number of elements in CLOSED including the zeros
    for k= 1:-1:-1
        for j= 1:-1:-1
            if (k~=j || k~=0)  %The node itself is not its successor
                s_x = node_x+k;
                s_y = node_y+j;
                if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y))%node within array bound
                    flag=1;                    
                    for c1=1:c2
                        if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2))
                            flag=0;
                        end;
                    end;%End of for loop to check if a successor is on closed list.
                    if (flag == 1)
                        exp_array(exp_count,1) = s_x;
                        exp_array(exp_count,2) = s_y;
                        exp_array(exp_count,3) = hn+distance(node_x,node_y,s_x,s_y);%cost of travelling to node
                        exp_array(exp_count,4) = distance(xTarget,yTarget,s_x,s_y);%distance between node and goal
                        exp_array(exp_count,5) = exp_array(exp_count,3)+exp_array(exp_count,4);%fn
                        exp_count=exp_count+1;
                    end%Populate the exp_array list!!!
                end% End of node within array bound
            end%End of if node is not its own successor loop
        end%End of j for loop
    end%End of k for loop
end    
function new_row = insert_open(xval,yval,parent_xval,parent_yval,hn,gn,fn)
    %Function to Populate the OPEN LIST
    %OPEN LIST FORMAT
    %--------------------------------------------------------------------------
    %IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
    %-------------------------------------------------------------------------
    %
    %   Copyright 2009-2010 The MathWorks, Inc.
    new_row=[1,8];
    new_row(1,1)=1;
    new_row(1,2)=xval;
    new_row(1,3)=yval;
    new_row(1,4)=parent_xval;
    new_row(1,5)=parent_yval;
    new_row(1,6)=hn;
    new_row(1,7)=gn;
    new_row(1,8)=fn;
end
function i_min = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget)
    %Function to return the Node with minimum fn
    % This function takes the list OPEN as its input and returns the index of the
    % node that has the least cost
    %
    %   Copyright 2009-2010 The MathWorks, Inc.

    temp_array=[];
    k=1;
    flag=0;
    goal_index=0;
    for j=1:OPEN_COUNT
     if (OPEN(j,1)==1)
         temp_array(k,:)=[OPEN(j,:) j]; %#ok<*AGROW>
         if (OPEN(j,2)==xTarget && OPEN(j,3)==yTarget)
             flag=1;
             goal_index=j;%Store the index of the goal node
         end;
         k=k+1;
     end;
    end;%Get all nodes that are on the list open
    if flag == 1 % one of the successors is the goal node so send this node
     i_min=goal_index;
    end
    %Send the index of the smallest node
    if size(temp_array ~= 0)
    [min_fn_tmp,temp_min]=min(temp_array(:,8));%Index of the smallest node in temp array
    i_min=temp_array(temp_min,9);%Index of the smallest node in the OPEN array
    else
     i_min=-1;%The temp_array is empty i.e No more paths are available.
    end;
end
function n_index = node_index(OPEN,xval,yval)
    %This function returns the index of the location of a node in the list
    %OPEN
    %
    %   Copyright 2009-2010 The MathWorks, Inc.
    i=1;
    while(OPEN(i,2) ~= xval || OPEN(i,3) ~= yval )
        i=i+1;
    end;
    n_index=i;
end
end