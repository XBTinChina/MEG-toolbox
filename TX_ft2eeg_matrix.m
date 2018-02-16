function [ eeglab_matrix ] = TX_ft2eeg_matrix( ft_data )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here



[x y] = size(ft_data.trial{1});
z = length(ft_data.trial);

eeglab_matrix  = zeros(x,y,z);

for trial = 1:z
    eeglab_matrix (:,:,trial) = ft_data.trial{trial};
end

end

