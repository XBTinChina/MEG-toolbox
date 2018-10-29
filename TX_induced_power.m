function POW_data = TX_induced_power( data_set,time_point,freq_rang,window_length,channel,trial,base )
%POW_data = TX_induced_power( data_set,time,channel,trial )
%time: a vector of time points
%trial: trial number

baseline = 131:170 ;  % for modulation




trl_num = trial;


cfg = [];
cfg.trials     = 1:trl_num;
cfg.keeptrials = 'yes';
cfg.method     = 'wavelet';
cfg.output     = 'pow';
cfg.channel    = channel;
cfg.width      = window_length;
cfg.foi        = freq_rang;
cfg.toi        = time_point;
POW_data = ft_freqanalysis(cfg, data_set);



starting_point = 2
sampling_rate = 10


if exist('base') == 1
    
 
    pow_temp = POW_data.powspctrm;
    pow_temp = squeeze(mean(pow_temp(1:trl_num,:,:,:)));
    base_temp = repmat(mean(squeeze(pow_temp(:,:,baseline)),3),[1 1 length(time)]);
    pow_temp(:,:,:) = 10*log10(squeeze(pow_temp(:,:,:))./base_temp);
    POW_data = TX_mat2ft_data(pow_temp,'chan_freq_time',starting_point,sampling_rate,freq_rang);
else
    pow_temp = POW_data.powspctrm;
    pow_temp = squeeze(mean(pow_temp(1:trl_num,:,:,:)));
    POW_data = TX_mat2ft_data(pow_temp,'chan_freq_time',starting_point,sampling_rate,freq_rang); %
    %     wrong
end

%
%
%
% if exist('base') == 1
%     pow_temp = POW_data.powspctrm;
%     average_temp = zeros(size(squeeze(pow_temp(1,:,:,:))));
%
%     for iiii = 1:trl_num
%
%         pow_temp_trl = squeeze(pow_temp(iiii,:,:,:));
%
%
%         base_temp = repmat(mean( pow_temp_trl(:,:,baseline),3),[1 1 length(time)]);
%         pow_temp_trl = 10*log10(pow_temp_trl./base_temp);
%
%         average_temp = average_temp +  pow_temp_trl / trl_num;
%
%     end
%
%     POW_data = TX_mat2ft_data( average_temp,'chan_freq_time',1,200,freq_rang);
%
%
%
%
% else
%     pow_temp = POW_data.powspctrm;
%     pow_temp = squeeze(mean(pow_temp(1:trl_num,:,:,:)));
%     POW_data = TX_mat2ft_data(pow_temp,'chan_freq_time',1,100,freq_rang); %
%     %     wrong
% end





end

