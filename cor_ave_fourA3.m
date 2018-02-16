function [cormatrx, cormatrx2, cormatrx3, SigValue, SigValue2, SigValue3] = cor_ave_fourA3(data, data2, data3, wgtvar, wgtvar2, wgtvar3, pre)
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
for i = 1:(length(data2(:,1)))
    [c, p] = corrcoef(data2(i,:), wgtvar2(:));
    cormatrx2(i) = c(1,2);
    signif2(i) = p(1,2);
end
for i = 1:(length(data3(:,1)))
    [c, p] = corrcoef(data3(i,:), wgtvar3(:));
    cormatrx3(i) = c(1,2);
    signif3(i) = p(1,2);
end
[SigValue2] = sig_valueA(signif2,cormatrx2);
[SigValue3] = sig_valueA(signif3,cormatrx3);
Sig = [SigValue,SigValue2,SigValue3];
SigValue4 = max(Sig);
x = (-pre):(length(cormatrx(1,:))-pre-1);
plot (x, cormatrx, 'b','LineWidth',3,'DisplayName', 'cormatrx', 'YDataSource', 'cormatrx');figure(gcf);
hold all
plot (x, cormatrx2, 'r','LineWidth',3,'DisplayName', 'cormatrx', 'YDataSource', 'cormatrx');figure(gcf);
plot (x, cormatrx3, 'g','LineWidth',3,'DisplayName', 'cormatrx', 'YDataSource', 'cormatrx');figure(gcf);
legend('Cond1', 'Cond2', 'Cond3');
%if SigValue4~=1
%   plot (x, (SigValue4 + (x*0)),'-.k','LineWidth',1.2);
%end
hold all
%if SigValue4~=1
%    plot (x, ((x*0) - SigValue4),'-.k','LineWidth',1.2);
%end
if SigValue~=1
    plot (x, (SigValue + (x*0)),'-.b','LineWidth',1);
    plot (x, ((x*0) - SigValue),'-.b','LineWidth',1);
end
if SigValue2~=1
    plot (x, (SigValue2 + (x*0)),'-.r','LineWidth',1);
    plot (x, ((x*0) - SigValue2),'-.r','LineWidth',1);
end
if SigValue3~=1
    plot (x, (SigValue3 + (x*0)),'-.g','LineWidth',1);
    plot (x, ((x*0) - SigValue3),'-.g','LineWidth',1);
end
xlabel('Time from Stimulus Onset (ms)','FontSize',14);
ylabel('Strength of Correlation','FontSize',14);
end