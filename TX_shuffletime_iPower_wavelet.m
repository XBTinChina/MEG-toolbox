function pow = TX_shuffletime_iPower_wavelet( data_set,shuffle_timerange,channel,trial,shuffle_timelength,shuffle_number )
%   [ PLV ] = TX_shuffletime_iPower_wavelet( data_set,time,channel,trial,shuffle_timerange )
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
    pow{shu} = zeros(length(channel),length(freq),shuffle_timelength);
end

disp(['Calculating iPOW for trials...']);

for i = 1:length(cha)
    
    cfg = [];
    cfg.trials     = 1:length(data_set.trial);
    cfg.keeptrials = 'yes';
    cfg.channel    = cha{i};
    cfg.method     = 'wavelet';
    cfg.width      = [linspace(1.5,7,20) linspace(7,15,30)];
    cfg.output     = 'pow';
    cfg.foi        = freq;
    cfg.toi        = shuffle_timerange;
    spectra_data = ft_freqanalysis(cfg,data_set);
    temp_data = spectra_data.powspctrm;
    
    trial_num = size(temp_data,1);
    if trial > trial_num
        error('not enough trials')
    end
    
    temp_data = temp_data(1:trial,:,:,:);
     
    for shu = 1:shuffle_number

        ['shuffling: ' num2str(shu)]
        
        temp_pow = zeros(length(cha{i}),length(freq),shuffle_timelength);
          
        for t = 1:trial
            
            start_point = floor(jitter * rand);
            
            temp_pow = temp_pow + squeeze(temp_data(t,:,:,start_point+1:start_point+shuffle_timelength));
            
        end
        
        pow_data = temp_pow/trial;
        
        pow{shu}(cha{i},:,:) = pow_data;
        
    end
    
end



end



