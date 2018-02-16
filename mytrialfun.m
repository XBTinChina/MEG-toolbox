function [trl, event] = mytrialfun(cfg)

% read the header information and the events from the data
trl = [];
hdr   = ft_read_header(cfg.dataset);
event = ft_read_event(cfg.dataset,'trigindx',cfg.trialdef.trig,'threshold',3);




% search for "trigger" events according to 'trigchannel' defined outside the function
value  = [event(find(strcmp(cfg.trialdef.trigchannel, {event.type}))).value]';
sample = [event(find(strcmp(cfg.trialdef.trigchannel, {event.type}))).sample]';
pretrig = cfg.trialdef.prestim * hdr.Fs;
posttrig =  cfg.trialdef.poststim * hdr.Fs;


% creating your own trialdefinition based upon the events
for j = 1:length(value);
    trlbegin = sample(j) - pretrig ;
    trlend   = sample(j) + posttrig ;
    offset   = pretrig ;
    newtrl   = [ trlbegin trlend -offset];
    trl      = [ trl; newtrl];  
end

end



