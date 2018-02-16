function [ PLV ] = TX_PhaseLV_wavelet( data_set,time,freq_range,window_length,channel,trial )
%  [ PLV ] = TX_PhaseLV( data_set,time,channel,trial )
%   Detailed explanation goes here

clear cha

% for i = 1:floor(length(channel)/50)
%     cha{i} = channel((((i-1)*50)+1):(i*50));
% end
% 
% if floor(length(channel)/50) < length(channel)/50
%     cha{i+1} = channel((i*50 + 1 ):end);
% end
cha{1} = channel;

PLV = zeros(length(channel),length(freq_range),length(time));

disp(['Calculating PLV for trials...']);



    
    %% compute fourier
    cfg = [];
    cfg.trials     = 1:trial;
    cfg.keeptrials = 'yes';
    cfg.channel    = channel;
    cfg.method     = 'wavelet';
    cfg.width      = window_length;
    cfg.output     = 'fourier';
    cfg.foi        = freq_range;
    cfg.toi        = time;
    spectra_data = ft_freqanalysis(cfg,data_set);
    temp_data = spectra_data.fourierspctrm;
    
    
    trial_num = size(temp_data,1);
    if trial > trial_num
        error('not enough trials')
    end
    
    temp_data = temp_data(1:trial,:,:,:);
    
for i = 1:length(cha)    
    
    for t = 1:trial
        waveletData{t} = squeeze(unwrap(angle(temp_data(t,cha{i},:,:)),4));
    end
    
    
    temp_plv = zeros(size(waveletData{1}));
    
    
    for t = 1:trial
        
        temp_plv = temp_plv + exp(1j.*waveletData{t});
        
    end
    plv_data = abs(temp_plv)/trial;
    
    PLV(cha{i},:,:) = plv_data;
end


end

