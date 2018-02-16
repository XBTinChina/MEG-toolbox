function [cormatrx, SigValue] = cor_ave_fourA(data, wgtvar, pre)
%this function takes the RMS of the datastack (or any 2-d data array) and the weight variable, 
%finds the correlation coefficients, then returns the SigValue, 
%which is the smallest of these correlations that is significant. 
%then plots the correlations with a line separating
%the significant correlations from the insignificant ones. 
for i = 1:(length(data(:,1)))
    [c, p] = corrcoef(data(i,:), wgtvar(:));
    cormatrx(i) = c(1,2);
    signif(i) = p(1,2);
end
[SigValue] = sig_valueA(signif,cormatrx);
x = (-pre):(length(cormatrx(1,:))-pre-1);
plot (x, cormatrx, 'b','LineWidth',3,'DisplayName', 'cormatrx', 'YDataSource', 'cormatrx');figure(gcf);
hold all
plot (x, (SigValue + (x*0)),'-.k');
hold all
plot (x, ((x*0) - SigValue),'-.k');
xlabel('Time from Stimulus Onset (ms)');
ylabel('Strength of Correlation');
end