function [cormatrx, cormatrx2, SigValue, SigValue2] = cor_ave_fourA2(data, data2, wgtvar, wgtvar2, pre)
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
ave = mean(data,2);
for i = 1:(length(data2(:,1)))
    [c, p] = corrcoef(data2(i,:), wgtvar2(:));
    cormatrx2(i) = c(1,2);
    signif2(i) = p(1,2);
end
[SigValue2] = sig_valueA(signif2,cormatrx2);
ave2 = mean(data2,2);
SigValue3 = max(SigValue,SigValue2);
if SigValue3 == 1;
    SigValue3 = min(SigValue,SigValue2);
end
x = (-pre):(length(cormatrx(1,:))-pre-1);
plot (x, cormatrx, 'b','LineWidth',3,'DisplayName', 'cormatrx', 'YDataSource', 'cormatrx');figure(gcf);
hold all
plot (x, cormatrx2, 'r','LineWidth',3,'DisplayName', 'cormatrx', 'YDataSource', 'cormatrx');figure(gcf);
legend('Cond1', 'Cond2');
plot (x, (SigValue3 + (x*0)),'-.k','LineWidth',1.2);
hold all
plot (x, ((x*0) - SigValue3),'-.k','LineWidth',1.2);
xlabel('Time from Stimulus Onset (ms)','FontSize',14);
ylabel('Strength of Correlation','FontSize',14);
end