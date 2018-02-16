function [ data ] = TX_repair_channel( data,channel )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
load layout
for i = 1:length(channel)
cfgmr               = []
cfgmr.grad = grad;
cfgmr.badchannel    = data.label(channel(i));
cfgmr.neighbours = neighbours;
cfgmr.neighbourdist = 4;
data = ft_channelrepair(cfgmr,data);

end
end

