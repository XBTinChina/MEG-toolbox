function [ AVG ] = TX_temporal_average( data_set,trial,time_range )
%[ AVG ] = TX_temporal_average( data_set,trial,lp_freq,time_range )
%   Detailed explanation goes here



for i = 1:length(data_set.trial)
 mat = (data_set.time{i}>= time_range(1))&( data_set.time{i}<= time_range(2));
 data_set.time{i} = data_set.time{i}(mat);
 data_set.trial{i} = data_set.trial{i}(:,mat);
end

load layout

cfg = [];

cfg.detrend    = 'no';
cfg.demean = 'yes';
cfg.baselinewindow  = [-1 0];

temp  = ft_preprocessing(cfg,data_set);

cfg = [];
cfg.trials = 1:trial;
%cfg.time = -1:0.002:3;
AVG = ft_timelockanalysis(cfg, temp);




end

