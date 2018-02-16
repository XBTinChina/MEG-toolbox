function [ Data, saminfo ] = TX_preprocess(triger,condition,data_set,preonset,postonset,resample_rate,checkdata)

% padding problem is not solved. 12/06/12




%%%% Step 1. Denoising Guide
if checkdata == 1
    checkForDeadChannels
    sqdDenoise
    data_set = [data_set '-Filtered'];
end





%%%% Step 2. Preprocess in Fieldtrip


for i = 1:condition
    
    
    cfg = [];
    cfg.dataset                 = [data_set '.sqd'];  % file name
    cfg.continuous              = 'yes';
    cfg.trialdef.prestim        = preonset;
    cfg.trialdef.poststim       = postonset;
    cfg.trialdef.trig = triger;
    cfg.trialdef.trigchannel    = sprintf('%d',triger(i));
    cfg.trialfun                = 'mytrialfun';
    cfg.channel                 = 'MEG';
    
    cfg = ft_definetrial(cfg);
    
    cfg.demean        = 'yes'; % baseline correction for the whole trial
    cfg.lpfilter   = 'yes';    % apply lowpass filter
    cfg.lpfreq     = 60;       % lowpass at 35 Hz.
    %cfg.padding      =
    temp_pre = ft_preprocessing(cfg);  %
    
    sampleinfo = temp_pre.sampleinfo;
    
    if temp_pre.fsample > resample_rate > eps
       
        cfg.resamplefs = resample_rate;
        cfg.detrend    = 'no';
        
        temp_pre  = ft_resampledata(cfg, temp_pre);
        temp_pre.sampleinfo = sampleinfo;
        
    end
    saminfo{1} = sampleinfo(:,1) - 1500;
    Data{i} = temp_pre;
    
    
    
    
end
if condition == 1
    Data = Data{1};
end


end









