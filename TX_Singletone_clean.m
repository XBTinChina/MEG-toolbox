function [] = TX_Singletone_clean(sqdname,badchannel)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


if ~exist('badchannel')
    badchannel = [ 20 112 115 152 40  64]
    
end

sqdDenoise(50000,-50:50,0,[sqdname '.sqd'],badchannel,'yes',180);







condition = 1;
triger_num = [161];
pre_onset = 0.5;
post_onset = 1;
fs = 1000;

%%% Preprocess
%  filename = 'Block1-Filtered';
%  data_1 = TX_preprocess(triger_num,condition,filename,pre_onset,post_onset,fs,0); % if desample, input 

filename = [sqdname '-Filtered'];

TX_reverse_trigger([filename '.sqd'],[161]) 

filename = ['rev_' filename ]

data = TX_preprocess(triger_num,condition,filename,pre_onset,post_onset,fs,0); % if desample, input 


data = TX_rej_trl(data,1000,60,1);


temp = 1:157;
temp(badchannel+1) = []
good_channel = temp;



ica_data = TX_ica(data,good_channel);

ica_rej_data = TX_rej_ica(ica_data);


 data = TX_pre_repair_channel(ica_rej_data,badchannel+1);
  data_for_process = TX_repair_channel(data,badchannel+1);


ave = zeros(size(data_for_process.trial{1}));

for i = 1:length(data_for_process.trial)
    ave = ave + data_for_process.trial{i};
end
ave = ave / length(data_for_process.trial);
ave_1 = cat(1,ave,zeros(35,length(ave)));

sqdwrite([sqdname '.sqd'], [sqdname(1:5) '_singletone.ave'],ave_1' * 1e16)

end

