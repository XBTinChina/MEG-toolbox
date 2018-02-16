function [ left_channel,right_channel ] = TX_select_channel( name,max_point,num_cha,bad_channel )
%[ N_l_cha,P_l_cha,N_r_cha,P_r_cha ] = TX_select_channel( name,time_channel
%)
% distance should be around 100

left_channel = [8:15 24:31 40:47 56 58:63 72:79 88:95 104:111 119:127 131 136:143 152:155] + 1;
right_channel = 1:157;
load('layout.mat','grad');
pos  = grad.chanpos;
for i=left_channel
    right_channel(i) = 0;
end

right_channel = find(right_channel ~=0);



data = ft_read_data(name);

if exist('bad_channel','var')
    ft_data = TX_mat2ft_data(data(1:157,:),'chan_time',0.2,1000);
    ft_data = TX_repair_channel(ft_data,bad_channel);
    data = ft_data.trial{1};
else 
    display('no bad channel')
    pause(2)
end


%[a max_point] = max(data(time_channel,:));

max_time = [max_point-5:max_point+5];
data = data(1:157,max_time);
ddata = sum(data,2);

l_data = ddata(left_channel);
r_data = ddata(right_channel);

%%
[a min_l_n] = sort(l_data);


Peak_N = left_channel(min_l_n(1));
X_L_N = pos(Peak_N,:);

sensor_L_N = [];
for i = left_channel
    if ((pos(i,1)-X_L_N(1))^2 + (pos(i,2)-X_L_N(2))^2 +(pos(i,3)-X_L_N(3))^2 < 100)
        sensor_L_N = [sensor_L_N i];
    end
end

LN_data = ddata(sensor_L_N);
[a min_L_N] = sort(LN_data);
N_l_cha = sensor_L_N(min_L_N(1:num_cha));

%%


Peak_P = left_channel(min_l_n(end));
X_L_P = pos(Peak_P,:);

sensor_L_P = [];
for i = left_channel
    if ((pos(i,1)-X_L_P(1))^2 + (pos(i,2)-X_L_P(2))^2 +(pos(i,3)-X_L_P(3))^2< 100)
        sensor_L_P = [sensor_L_P i];
    end
end

LP_data = ddata(sensor_L_P);
[a min_L_P] = sort(LP_data);
P_l_cha = sensor_L_P(min_L_P(end-num_cha+1:end));




%%



[a min_r_n] = sort(r_data);
Peak_N = right_channel(min_r_n(1));
X_R_N = pos(Peak_N,:);

sensor_R_N = [];
for i = right_channel
    
    if ((pos(i,1)-X_R_N(1))^2 + (pos(i,2)-X_R_N(2))^2 +(pos(i,3)-X_R_N(3))^2 < 100)
        sensor_R_N = [sensor_R_N i];
    end
end

RN_data = ddata(sensor_R_N);
[a min_R_N] = sort(RN_data);
N_r_cha = sensor_R_N(min_R_N(1:num_cha));

%%


Peak_P = right_channel(min_r_n(end));
X_R_P = pos(Peak_P,:);

sensor_R_P = [];
for i = right_channel
    if ((pos(i,1)-X_R_P(1))^2 + (pos(i,2)-X_R_P(2))^2 +(pos(i,3)-X_R_P(3))^2< 100)
        sensor_R_P = [sensor_R_P i];
    end
end

RP_data = ddata(sensor_R_P);
[a min_R_P] = sort(RP_data);
P_r_cha = sensor_R_P(min_R_P(end-num_cha+1:end));



left_channel  = sort([N_l_cha P_l_cha]);

right_channel = sort([N_r_cha  P_r_cha]);



%%%%%% Check channels %%%%%%

map = zeros(157,1);
map([left_channel right_channel]) = 0.5;
TX_multiplot( TX_mat2ft_data(map),'topo3','no', [0 1],[0 1],[0 0.5] )
pause


end




