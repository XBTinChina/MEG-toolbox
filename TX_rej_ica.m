function [ data ] = TX_rej_ica( ica_data )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

load layout.mat
cfg = [];
cfg.viewmode = 'component';
cfg.continuous = 'no';
cfg.blocksize = 20;
cfg.channels = [1:10];

cfg.layout      =layout;
cfg.component = [1:20]; 


ft_databrowser(cfg,ica_data);






cfg = [];
cfg.component = input('input the number of component you want to reject');
data = ft_rejectcomponent(cfg, ica_data);



end

