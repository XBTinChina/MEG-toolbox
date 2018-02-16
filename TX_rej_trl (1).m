function [ data ] = TX_rej_trl( data_set,fs,cha_num,winlength,scale )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here


eeg_data = TX_ft2eeg_matrix(data_set);

eegplot(eeg_data,'srate' ,fs,'dispchans',cha_num,'winlength',winlength)

pause 
trash = input('trial num you need to get rid of ');


data_set.trial(trash) = [];
data_set.time(trash) = [];
data_set.sampleinfo(trash,:) =[]; 
data_set.trash = trash;

data = data_set;
close all;
end

