function [hilbertData] = TX_Phase_hilbert( ft_dataCell,trial,filtSpec,channel)

%
%


if exist('channel')
else channel = 1:157;
end



if ~isstruct(ft_dataCell)
    display('need fieldtrip cell')
    
end

dataCell = ft_dataCell.trial;
trial_num = length(dataCell);
fs = ft_dataCell.fsample;
clear filteredData
if trial > trial_num
    error('not enough trials')
else
    num = randperm(trial_num);
    trial_used = num(1:trial);
end

index = 1;
for i = trial_used
    filteredData{index}  = eegfilt(dataCell{i}(channel,:), fs, filtSpec(1),filtSpec(2));
    index = index + 1;
end

clear index




disp(['Calculating PLV for trials...']);

clear hilbertData
for i = 1:trial
    hilbertData{i} =angle(hilbert(filteredData{i}));
end






end

