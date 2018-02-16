function [h,CR_test,Str_testE,CR_train]=svdboostV2pred(x,y,x_test,y_test,h,MaxIter,DeltaH)
% DeltaH will be reset to 0.005 in the function
% At least 10 iterations will be done
% After 10 iterations, prediction error works as the stop criterion
% Nai Ding 01/25/11
DeltaH=0.005;

% length of testing signal
TSlen=size(x,2)/10;
TSlen=floor(TSlen);

%vector form regression
hstr=[];
BestPos=0;
% testing_range=[1:TSlen]+TSlen*segno;
% training_range=setdiff([1:length(x)],testing_range);
% x_test=x(:,testing_range);y_test=y(:,testing_range);
% x=x(:,training_range);y=y(:,training_range);

for iter=1:MaxIter
    ypred_now=y*0;
    ypred_test=y_test*0;
    for ind=1:size(h,1)
        ypred_now=ypred_now+filter(h(ind,:),1,x(ind,:));
        ypred_test=ypred_test+filter(h(ind,:),1,x_test(ind,:));
    end
    
    rg=size(h,2):length(y);
    CR_train(iter)=sum(y(rg).*ypred_now(rg))/sqrt(sum(ypred_now(rg).*ypred_now(rg))*sum(y(rg).*y(rg)));
    rg=size(h,2):length(y_test);
    CR_test(iter)=sum(y_test(rg).*ypred_test(rg))/sqrt(sum(ypred_test(rg).*ypred_test(rg))*sum(y_test(rg).*y_test(rg)));
    
    TestE(1:size(h,1))=sum((y_test-ypred_test).^2);
    Str_testE(iter)=sum(TestE);
    TrainE(1:size(h,1))=sum((y-ypred_now).^2);
    Str_TrainE(iter)=sum(TrainE);
    
    % stop the iteration if all the following requirements are met
    % 1. more than 10 iterations are done
    % 2. The testing error in the latest iteration is higher than that in the
    % previous two iterations
    if iter>10 && Str_testE(iter)>Str_testE(iter-1) && Str_testE(iter)>Str_testE(iter-2)
        %   if iter>10 && Str_testE(iter)>Str_testE(iter-1)
        [dum,iter]=min(Str_testE);iter=iter+1;
        try h=squeeze(hstr(iter-2,:,:));
        catch h=h*0;
        end
        if size(h,2)==1
            h=h';
        end
        break;
        %     DeltaH=DeltaH*0.5;
        %     if DeltaH<0.005
        %       break;
        %     end
    end
    
    MinE(1:size(h,1))=sum((y-ypred_now).^2);
    for ind1=1:size(h,1)
        for ind2=1:size(h,2)
            ypred=ypred_now+DeltaH*[zeros(1,ind2-1) x(ind1,1:end-ind2+1)];
            e1=sum((y-ypred).^2);
            
            ypred=ypred_now-DeltaH*[zeros(1,ind2-1) x(ind1,1:end-ind2+1)];
            e2=sum((y-ypred).^2);
            
            if e1>e2
                e=e2;
                IncSignTmp=-1;
            else
                e=e1;
                IncSignTmp=1;
            end
            if e<MinE(ind1)
                BestPos(ind1)=ind2;
                IncSign(ind1)=IncSignTmp;
                MinE(ind1)=e;
            end
        end
    end
    if sum(abs(BestPos))==0;
        DeltaH=DeltaH*0.5;
        %     disp('Precision doubled')
        %     disp(DeltaH)
        if DeltaH<0.005
            %         disp('It is alreayd recise enough')
            break;
        end
        continue;
    end
    [dum, bestfil]=min(MinE);
    h(bestfil,BestPos(bestfil))=h(bestfil,BestPos(bestfil))+IncSign(bestfil)*DeltaH;
    BestPos=BestPos*0;
    hstr(iter,:,:)=h;
    try
        if sum(abs(h-hstr(iter-2,:)))==0
            disp(iter)
            break
        elseif sum(abs(h-hstr(iter-3,:)))==0
            disp(iter)
            break
        end
    end
end

% CR_test=CR_test(iter);
CR_test=CR_test(end);
return;
