function data = TX_power( data_set,band,channel )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

cfg = [];
cfg.method = 'mtmfft';
cfg.output = 'pow';
cfg.channel = channel;
cfg.foilim     = band;

 data = ft_freqanalysis(cfg, data_set);


end

