function [ ft_cell ] = TX_seperate_ftdata(  combine, ft_matrix)%,sampleinfo)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

num_cell = length(ft_matrix);


ft_cell{1} = combine;

matrix = cumsum(ft_matrix);
matrix = [0 matrix];

for n = 1:num_cell
    
    ft_cell{n} = combine;
    ft_cell{n}.time = combine.time(matrix(n)+1:matrix(n+1));
    ft_cell{n}.trial = combine.trial(matrix(n)+1:matrix(n+1));
    
%     if n > 1
%         difference = 5000000
%     end
    
    ft_cell{n}.sampleinfo = combine.sampleinfo(matrix(n)+1:matrix(n+1),:) ;
    
end


end

