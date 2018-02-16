function [cormatrx, signif, SigValue, RMS] = cor_ave_four(datastack, wgtvar, pre, smpr)
%this function takes the datastack and weight variable, makes a matrix of
%the correlation coefficients, then returns the SigValue, 
%which is the smallest of these correlations that is significant. 
%then plots the correlations with a line separating
%the significant correlations from the insignificant ones. Also plots the
%RMS of the correlations. 
for i = 1:(length(datastack(:,1,1)))
    for j = 1:length(datastack(1,:,1))
        [c, p] = corrcoef(datastack(i,j,:), wgtvar(:));
        cormatrx(i,j) = c(1,2);
        signif(i,j) = p(1,2);
    end;
end;
SigValue = sig_value(signif,cormatrx);
x = (-pre):(1/smpr):((length(cormatrx(:,1))-(pre*smpr)-1)*(1/smpr));
plot (x, cormatrx, 'DisplayName', 'cormatrx', 'YDataSource', 'cormatrx');figure(gcf);
hold on
plot (x,SigValue+(0*x),'k','LineWidth',1);
plot (x,-SigValue+(0*x),'k','LineWidth',1);
RMS = sqrt(mean((cormatrx(:, :).^2), 2));
plot (x,RMS,'-.k','LineWidth',2);
xlabel('Time from Stimulus Onset (ms)');
ylabel('Strength of Correlation');
end