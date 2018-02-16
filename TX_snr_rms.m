function [snrvector, RMS] = TX_snr_rms(data, pre, smpr)
% compute the signal to noise ratio between pre and post
% data should be 2D data

pre = pre * smpr;
RMS = sqrt(mean((data(:, :).^2), 2));
snrvector = RMS ./ mean(RMS(1:pre));