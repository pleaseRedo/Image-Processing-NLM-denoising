function [ii] = computeIntegralImage(image)
% The following implementation is based on the recursion approach based on
% the slides:
% s(x,y) = s(s,y-1)+ I(x,y)
% I_int(x,y) = I_int(x-1,y) + s(x,y)
%REPLACE THIS
im = double(image);
ii = zeros(size(image));
[n_row , n_col, dim] = size(image);
cumulate = zeros(size(image));

% Note, each recursion is based on the previous recursion's result. So we
% have to initialize the value and start recursion at i j = 2
cumulate(1,1:n_col,:) = image(1,1:n_col,:);
ii(1,2:n_col,:) = image(1,2:n_col,:);
ii(1:n_row,1,:) = image(1:n_row,1,:);
%cumulate(1,1,:) = im(1,1,:);
% Cumulative sum for the first column and row.
for i = 2:n_col
    ii(1,i,:) = ii(1,i-1,:) + im(1,i,:);
end
for i = 2:n_row
   ii(i,1,:) = ii(i-1,1,:) + ii(i,1,:);

end

for j = 2:n_col
    for i = 2:n_row            
        cumulate(i,j,:) = cumulate(i-1,j,:) + im(i,j,:);
        ii(i,j,:) =  cumulate(i,j,:) + ii(i,j-1,:);        
    end
end
end