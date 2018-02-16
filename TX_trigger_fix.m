function [  ] = TX_trigger_fix( filename,trigger_matrix )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

data = sqdread(filename);

data(:,trigger_matrix) = data(:,trigger_matrix) -  repmat(mean(data(:,trigger_matrix)),length(data),1);

data(:,trigger_matrix) = data(:,trigger_matrix) * (-1);


temp =  [zeros(1,length(trigger_matrix)); diff(data(:,trigger_matrix))];
temp(temp < 0) = 0;  
data(:,trigger_matrix) = temp;


sqdwrite(filename,['revdiff_' filename],data)

end

