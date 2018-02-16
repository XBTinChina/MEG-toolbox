function [ PLV ] = TX_shufflecondition_PhaseLV_wavelet( data_set1,data_set2,data_set3,shuffle_timerange,channel,trial,shuffle_number )
%    [ PLV ] = TX_shufflecondition_PhaseLV_wavelet( data_set1,data_set2,data_set3,shuffle_timerange,channel,trial,shuffle_number )
%   Detailed explanation goes here


data_set = data_set1;
data_set.trial = [data_set1.trial data_set2.trial data_set3.trial];
data_set.time = [data_set1.time data_set2.time data_set3.time];

if isfield(data_set1,'sampleinfo')
data_set.sampleinfo = [data_set1.sampleinfo; data_set2.sampleinfo; data_set3.sampleinfo];
end

clear cha

for i = 1:floor(length(channel)/5)
    cha{i} = channel((((i-1)*5)+1):(i*5))
end

if floor(length(channel)/5) < length(channel)/5
    cha{i+1} = channel((i*5 + 1 ):end);
end

freq = 1:1:50;

for shu = 1:shuffle_number
    PLV{shu} = zeros(length(channel),length(freq),length(shuffle_timerange));
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
    
    
    for t = 1:trial_num
        
        num2str(t)
        waveletData{t} = squeeze(unwrap(angle(temp_data(t,1:length(cha{i}),:,:))));
        
    end
    
    clear temp_data
    
    for shu = 1:shuffle_number
        
        num2str(shu)
        
        trl_rand = randperm(length(data_set.trial));
                
        temp_plv = zeros(size(waveletData{1}));
        
        for t = 1:trial
            
            temp_plv = temp_plv + exp(1j.*waveletData{trl_rand(t)});
            
        end
        
        plv_data = abs(temp_plv)/trial;
        
        PLV{shu}(cha{i},:,:) = plv_data;
        
    end
    
end



end



