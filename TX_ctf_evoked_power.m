function [POW_data ] = TX_ctf_evoked_power( AVG,time,freq_range,window_length,base  )
%[PAVG ] = untitled10( AVG,time )
%Detailed explanation goes here


baseline = 20:80 ;  % if onset is 100.


cfg = [];
cfg.channel    = 'MEG';
cfg.method     = 'wavelet';
cfg.width      = window_length;
cfg.output     = 'pow';
cfg.foi        = freq_range;
cfg.toi        = time;
POW_data = ft_freqanalysis(cfg,AVG );




if exist('base') == 1
    
    pow_temp = POW_data.powspctrm;
    
    base_temp = repmat(mean(squeeze(pow_temp(:,:,baseline)),3),[1 1 length(time)]);
    pow_temp(:,:,:) = 10*log10(squeeze(pow_temp(:,:,:))./base_temp);
    POW_data.powspctrm = pow_temp;
  
end

