%%% MEG160 Preprocess



%%% check the dead channels and saturated channels
checkForDeadChannels 
bad_cha = []
sqdDenoise



%%% parameters
condition = ;
triger_num = [];
filename = ;
pre_onset = 
post_onset = 
fs = 




%%% Preprocess
data = TX_preprocess(triger_num,condition,filename,pre_onset,post_onset,fs,0); % if desample, input 




%%% Do ICA decomponation
for con = 1:condition   
    ica_data{con} = TX_ica(data{con},[]);
end

%%% Reject components
for con = 1:condition   
    ica_rej_data{con} = TX_rej_ica(ica_data{con});
end


%%% Reject trials
trl_rej_data = TX_rej_trl( ica_rej_data,1000,40,1);


%%% Repair bad channel
% if bad channel is deleted
data_for_process = TX_repair_channel(TX_pre_repair_channel(trl_rej_data,[65 114]),[65 114]);
% if bad channel is included
data_for_process{con} = TX_repair_channel(trl_rej_data{con},[65 41 157]);





%%% Name of conditions
name = {'theta_left','theta_middle','theta_right','alpha_left','alpha_middle','alpha_rigth'};


%%% Induced Power
POW_data = TX_induced_power( data_set,time,channel,trial );

%%% Phase locking Value
PLV  = TX_PhaseLV( data_set,time,channel,trial );

%%% temporal average
AVG  = TX_temporal_average( data_set,trial,lp_freq );

%%% Evoked power
PAVG  = TX_evoked_power( AVG,time );









