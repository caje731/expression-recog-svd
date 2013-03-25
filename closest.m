function [index, min_distance] = closest(input, target)

% INPUTS
% input = single column vector mX1
% target= mXn matrix of vectors with which to match the input

% OUTPUTS
% index         = column index of target where the input has the best match
% min_distance  = measure of the least MEAN SQUARED ERROR when traversing
%                 through the target space


% This function finds the index of the column vector in the target space
% to which the input is closest in Euclidean distance


[m n] = size(target);
min_distance = 10000000000;
index = -1;
for i=1:n
     curr_distance = sum((input-target(:,i)).^2).^0.5;
     if curr_distance < min_distance
         min_distance = curr_distance;
         index = i;
     end
end
