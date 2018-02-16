function [ ica_data_set ] = TX_ica( data_set, channel)



cfg = [];
cfg.channel = channel;
cfg.method = 'runica';
cfg.numcomponent = 30;

ica_data_set = ft_componentanalysis(cfg,data_set);


end


