function [ waveletData ] = TX_Power_wavelet( data_set,time,AmpFreqVector,window_length,channel,trial )
%  [ PLV ] = TX_PhaseLV( data_set,time,channel,trial )
%   Detailed explanation goes here

clear cha


baseline = 11:31 ;  %% just for modulation

freq = AmpFreqVector;

disp(['Calculating POW for trials...']);

power_data = zeros(trial,length(channel),length(freq),length(time));

%window_length = [linspace(1.5,5,15) linspace(5,15,25)];




%% compute fourier
cfg = [];
cfg.trials     = 1:length(data_set.trial);
cfg.keeptrials = 'yes';
cfg.channel    =  1:157;
cfg.method     = 'wavelet';
cfg.width      = window_length;
cfg.output     = 'pow';
cfg.foi        = freq;
cfg.toi        = time;
spectra_data = ft_freqanalysis(cfg,data_set);
pow_temp = spectra_data.powspctrm;


trial_num = size(pow_temp,1);
if trial > trial_num
    error('not enough trials')
end
% 
% 
% baseline_temp = squeeze(mean(pow_temp(1:trial_num,:,:,:)));
% base_temp = repmat(squeeze(mean(baseline_temp(:,:,baseline),3)),[1 1 length(time)]);
% 
% 
% base_correct_power = zeros(size(pow_temp));
% 
% for nnn =  1:trial
%     
%     base_correct_power (nnn,:,:,:) = 10*log10(squeeze(pow_temp(nnn,:,:,:))./base_temp);
%     
% end


for t = 1:trial
    waveletData{t} = squeeze((pow_temp (t,:,:,:)));
end



end