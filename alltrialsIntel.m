function [trl, event ] = alltrialsIntel( cfg )

% this function does NOT sort trials by trigger

% read the header information and the events from the data
hdr   = ft_read_header(cfg.dataset);

event = ft_read_event(cfg.dataset,'trigindx',163,'threshold',5000); %depending on loading function, use threshold of 1e3 or 2.5

% search for "trigger" events
[sample,ind] = unique([event.sample]');
type = str2double({event(ind).type});
% determine the number of samples before and after the trigger
pretrig  = -cfg.trialdef.prestim  * hdr.Fs;
posttrig =  cfg.trialdef.poststim * hdr.Fs;

trl = zeros(length(sample),4);

% outputs sample limits for each new trial and the trigger type for
% classification later.
for j = 1:length(sample);
    trlbegin = sample(j) + pretrig ;
    offset   = pretrig;

    if trlbegin<1
        trlbegin = 1;
        offset = -(sample(j)-1);
    end
    trlend   = sample(j) + posttrig ;
    trl(j,:)   = [trlbegin trlend offset type(j)];
end


end

