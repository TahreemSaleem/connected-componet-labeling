function [ image ] = connected( input )

    A = im2bw(input, 0.5);
    B =  zeros(size(A));
  
    global label
    label = 1;
    [m n] = size(A);
   
    L = zeros(1000,1);
    C = cell(size(L));
    for i = 1: m;
        for j = 1: n;
            
            if A(i,j) == 0
                continue;
            elseif j == 1 && i ==1 %if first element in matrix  assign a new label
                
                B(i,j) = label;
                label = label + 1;
            elseif j~=1 && i == 1 %if in first row of matrix
                if B(i,j-1) ~=0  %left neighbor is not zero
                   B(i,j) = B(i,j-1); %assign value of left neihbour
                else 
                   B(i,j) = label; %else assign a new label
                   label = label+1;
                end
                
            elseif j==1 && i ~= 1 %if in the first column of matrix
                if B(i-1,j) ~=0   %if top neighbour is not zero
                    B(i,j) = B(i-1,j); %take the value of top neighbour
                else 
                    B(i,j) = label; %otherwise assign a new label
                    label = label+1;
                end
                
            else  %if somwhere in the middle 
                if B(i-1,j) == 0 && B(i,j-1) ==0 %both top and left neighbour are zero
                    B(i,j) = label; %assign new label
                    label = label+1;
                elseif B(i-1,j) == B(i,j-1) %else if both top and left neighbour have same value
                    B(i,j) = B(i-1,j); %assign value of top neighbour
                elseif B(i-1,j) == 0 && B(i,j-1) ~=0% if left neighbour has some value and top naighbour doesnot
                    B(i,j) = B(i,j-1); %take  value of left naighbour
                elseif B(i-1,j) ~= 0 && B(i,j-1) == 0 % if left neighbour is zero and top has some value
                    B(i,j) = B(i-1,j); %take value of top neigbour
                else
                    B(i,j) = min(B(i-1,j),B(i,j-1)); %if neighbours are different take the smallest of the two 
                    C{B(i,j)} = union(C{B(i,j)}, max(B(i-1,j),B(i,j-1))); %store the larger of two i-e the child in the parent(smaller) index of array 
                end
            end
        end
    end

for i = 1: m;
        for j = 1: n;
            if A(i,j) ~=0 %if not background
                for k = 1 :size(C); %traverse the union array C
                    if  find([C{k}] ==  B(i,j)) %find the element in the cells
                        B(i,j) = k ; %if found then replace the child with the parent
                   
                        break;
                    end
                end
            end
        end
end
  imagesc(A);
image = B;


end


