function [ chl_block_comodulation ] = TX_PhasePowerCoupling_AllTrial( ft_cell,trl_num,channls,time_range,baseline_range)
%  Compute phase-power coupling using Hilbert transform
%  Most part of the codes are from Adriano Tort.
%  Reference: Tort, Kopell et al. 2010
%  [ chl_block_comodulation,chl_avr_comodulation ] = TX_PhasePowerCoupling( ft_cell,trl_num,channls)




chl_num = channls;

srate = 200  %% just for modulation
%srate = ft_cell.fsample;




PhaseFreqVector=2:1:15;
AmpFreqVector=10:1:50;

PhaseFreq_BandWidth=2;
AmpFreq_BandWidth=10;




% For comodulation calculation (only has to be calculated once)
nbin = 18;
position=zeros(1,nbin); % this variable will get the beginning (not the center) of each phase bin (in rads)
winsize = 2*pi/nbin;
for j=1:nbin
    position(j) = -pi+(j-1)*winsize;
end



clear block_comodulation
clear chl_block_comodulation
clear chl_avr_comodulation

for chl = 1:length(channls)
    avr_co = zeros(length(PhaseFreqVector),length(AmpFreqVector));
    clear block_comodulation
    
    for trl = 1:trl_num
        
        
        lfp = ft_cell.trial{trl}(channls(chl),:);
        
        t = ft_cell.time{trl};
        
        real_data = ((t>time_range(1))&(t<time_range(2)));
        base_line = ((t>baseline_range(1))&(t<baseline_range(2)));
        
        
        
        data_length = length(lfp);
        
        
        'CPU filtering'
        tic
        
        AmpFreqTransformed{trl} = zeros(length(AmpFreqVector), length(lfp(real_data)));
        PhaseFreqTransformed{trl} = zeros(length(PhaseFreqVector), length(lfp(real_data)));
        
        for ii=1:length(AmpFreqVector)
            Af1 = AmpFreqVector(ii) - AmpFreq_BandWidth/2;
            Af2 = AmpFreqVector(ii) + AmpFreq_BandWidth/2;
            AmpFreq = eegfilt(lfp,srate,Af1,Af2); % just filtering
            temp_amp = abs(hilbert(AmpFreq));% getting the amplitude envelope
            
            data_data = temp_amp(real_data);
            base_base = temp_amp(base_line);
            datadata = data_data / mean(base_base);
            AmpFreqTransformed{trl}(ii, :) = datadata;
            
            
        end
        
        for jj=1:length(PhaseFreqVector)
            Pf1 = PhaseFreqVector(jj) - PhaseFreq_BandWidth/2;
            Pf2 = PhaseFreqVector(jj) + PhaseFreq_BandWidth/2;
            PhaseFreq = eegfilt(lfp,srate,Pf1,Pf2); % this is just filtering
            temp_pha = angle(hilbert(PhaseFreq)); % this is getting the phase time series
            PhaseFreqTransformed{trl}(jj, :) = temp_pha(real_data);
        end
        toc
        
        
    end
    
    
    Comodulogram=single(zeros(length(PhaseFreqVector),length(AmpFreqVector)));
    
    
    % Do comodulation calculation
    'Comodulation loop'
    
    
    
    
    counter1=0;
    for ii=1:length(PhaseFreqVector)
        counter1=counter1+1;
        
        Pf1 = PhaseFreqVector(ii);
        Pf2 = Pf1+PhaseFreq_BandWidth;
        
        counter2=0;
        for jj=1:length(AmpFreqVector)
            counter2=counter2+1;
            
            Af1 = AmpFreqVector(jj);
            Af2 = Af1+AmpFreq_BandWidth;
            
            
            phasephase = []; ampamp = [];
            for trl = 1:trl_num
                phasephase = cat(2,phasephase,PhaseFreqTransformed{trl}(ii, :));
                ampamp =  cat(2,ampamp,AmpFreqTransformed{trl}(jj, :));
            end
            
            [MI,MeanAmp]=ModIndex_v2(phasephase, ampamp , position);
            Comodulogram(counter1,counter2)=MI;
        end
    end
    toc
    
    block_comodulation = Comodulogram;
    
    chl_block_comodulation{channls(chl)} = block_comodulation;
    
end




end

