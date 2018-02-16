function [  ] = TX_reverse_trigger( filename,trigger_matrix )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

data = sqdread(filename);

for tri = trigger_matrix

data(:,tri) = data(:,tri) -  repmat(mean(data(:,tri)),length(data),1);

data(:,tri) = data(:,tri) * (-1);

data(data(:,tri) > 2.6 * 1e4,tri) = 2.7 * 1e4;

end

sqdwrite(filename,['rev_' filename],data)

end




