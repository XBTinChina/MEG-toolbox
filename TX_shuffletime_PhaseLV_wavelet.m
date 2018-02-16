function [ PLV ] = TX_shuffletime_PhaseLV_wavelet( data_set,shuffle_timerange,channel,trial,shuffle_timelength,shuffle_number )
%   [ PLV ] = TX_shuffle_PhaseLV_wavelet( data_set,time,channel,trial,shuffle_timerange )
%   Detailed explanation goes here





clear cha

for i = 1:floor(length(channel)/10)
    cha{i} = channel((((i-1)*10)+1):(i*10));
end

if floor(length(channel)/10) < length(channel)/10
    cha{i+1} = channel((i*10 + 1 ):end);
end

freq = 1:1:50;


jitter = length(shuffle_timerange) - shuffle_timelength;

for shu = 1:shuffle_number
    PLV{shu} = zeros(length(channel),length(freq),shuffle_timelength);
end

disp(['Calculating PLV for trials...']);

for i = 1:length(cha)
    
    cfg = [];
    cfg.trials     = 1:length(data_set.trial);
    cfg.keeptrials = 'yes';
    cfg.channel    = cha{i};
    cfg.method     = 'wavelet';
    cfg.width      = [linspace(1.5,7,20) linspace(7,15,30)];
    cfg.output     = 'fourier';
    cfg.foi        = freq;
    cfg.toi        = shuffle_timerange;
    spectra_data = ft_freqanalysis(cfg,data_set);
    temp_data = spectra_data.fourierspctrm;
    
    
    trial_num = size(temp_data,1);
    if trial > trial_num
        error('not enough trials')
    end
    
    temp_data = temp_data(1:trial,:,:,:);
    
    
    
    for t = 1:trial
        waveletData{t} = squeeze(unwrap(angle(temp_data(t,1:length(cha{i}),:,:))));
    end
    
    clear temp_data
    
    for shu = 1:shuffle_number
        ['shuffling: ' num2str(shu)]
        temp_plv = zeros(length(cha{i}),length(freq),shuffle_timelength);
          
        for t = 1:trial
            
            start_point = floor(jitter * rand);
            
            temp_plv = temp_plv + exp(1j.*waveletData{t}(:,:,start_point+1:start_point+shuffle_timelength));
            
        end
        
        plv_data = abs(temp_plv)/trial;
        
        PLV{shu}(cha{i},:,:) = plv_data;
  
  %%%% save for masking experiment
  %     plv_data = squeeze (mean( plv_data(:,:,652:1401),3)) ;
  %     plv_data = squeeze (mean( plv_data)) ;
  %     PLV{shu} = plv_data;
  %%%% end %%%%%     
       
    end
    
end



end



