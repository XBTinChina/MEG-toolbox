function [ data ] = TX_pre_repair_channel( data_set,channel )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

load label
channel = sort(channel);
if length(channel) == 1
    cha = [1:channel(1)-1 channel(1)+1:157];
elseif length(channel) == 2
    cha = [1:channel(1)-1 channel(1)+1:channel(2)-1 channel(2)+1:157];
elseif length(channel) == 3
    cha = [1:channel(1)-1 channel(1)+1:channel(2)-1 channel(2)+1:channel(3)-1 channel(3)+1:157];
elseif length(channel) == 4
    cha = [1:channel(1)-1 channel(1)+1:channel(2)-1 channel(2)+1:channel(3)-1 channel(3)+1:channel(4)-1 channel(4)+1:157];
elseif length(channel) == 5
    cha = [1:channel(1)-1 channel(1)+1:channel(2)-1 channel(2)+1:channel(3)-1 channel(3)+1:channel(4)-1 channel(4)+1:channel(5)-1 channel(5)+1:157];
elseif length(channel) == 6
    cha = [1:channel(1)-1 channel(1)+1:channel(2)-1 channel(2)+1:channel(3)-1 channel(3)+1:channel(4)-1 channel(4)+1:channel(5)-1 channel(5)+1:channel(6)-1  channel(6)+1:157];
elseif length(channel) == 7
    cha = [1:channel(1)-1 channel(1)+1:channel(2)-1 channel(2)+1:channel(3)-1 channel(3)+1:channel(4)-1 channel(4)+1:channel(5)-1 channel(5)+1:channel(6)-1  channel(6)+1:channel(7)-1  channel(7)+1:157];
    
end


for i = 1:length(data_set.trial)
    zero = zeros(157,length(data_set.trial{i}));
    size(data_set.trial{i})
    zero(cha,:) = data_set.trial{i};
    data_set.trial{i} = zero;
end

data_set.label = label;
data = data_set;

end

