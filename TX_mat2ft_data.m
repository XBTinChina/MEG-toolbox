function [ ft_data ] = TX_mat2ft_data( matrix,format,start,fs,freq)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%  TX_mat2ft_data( matrix,'chan_freq_time',1,100,4:50)
if nargin <2
    fs = 1;
    format = [];
    start = 0;
end


ft_data = [];
load label
load ftgrad

ft_data.label = label;
ft_data.grad = ftgrad;




if length(size(matrix )) == 2 && min(size(matrix)) == 1
    ft_data.time = (-1:0.5:1) - start;
    ft_data.freq = 1:5;
    ft_data.dimord = 'chan_freq_time';
    ft_data.powspctrm = repmat(matrix, [1 5 5]);
    
elseif length(size(matrix )) == 2 && min(size(matrix)) > 1 && strcmp(format, 'time')
    ft_data.time = (1:size(matrix,2)) /fs  - start;
    ft_data.freq = 1;
    ft_data.dimord = 'chan_freq_time';
    ft_data.powspctrm = permute(matrix,[1 3 2]);
    
elseif length(size(matrix )) == 2 && min(size(matrix)) > 1 && strcmp(format, 'freq' )
    ft_data.time = (-1:0.5:1) - start;
    ft_data.freq = freq;
    ft_data.dimord = 'chan_freq_time';
    ft_data.powspctrm = repmat(matrix,[1 1 5]);
    
elseif strcmp(format, 'chan_time' ) && length(size(matrix )) == 3
    for i = 1 : size(matrix,3)
        ft_data.trial{i} = matrix(:,:,i);
        ft_data.time{i} = (1:size(matrix,2))/fs - start;
        ft_data.fsample = fs;
        sam1 = (1:2:size(matrix,3)*2);
        sam2 = sam1 + size(matrix,3);
        ft_data.sampleinfo = [sam1' sam2'];
    end
    
elseif strcmp(format, 'chan_time' ) && length(size(matrix )) == 2    
    ft_data.trial{1} = matrix;
    ft_data.time{1} = (1:size(matrix,2))/fs - start;
    ft_data.fsample = fs;
        
elseif  strcmp(format, 'chan_freq_time' ) && length(size(matrix )) == 3
    ft_data.time = (1:size(matrix,3)) /fs  - start;
    ft_data.freq = freq;
    ft_data.dimord = 'chan_freq_time';
    ft_data.powspctrm = matrix;
end




end

