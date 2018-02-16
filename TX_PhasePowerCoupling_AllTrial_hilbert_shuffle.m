function [ chl_comodulation ] = TX_PhasePowerCoupling_AllTrial_hilbert_shuffle( ft_cell,trl_num,channels,shuffle_range,baseline_range,shuffle_time,shuffle_number)
%  Compute phase-power coupling using Hilbert transform
%  Most part of the codes are from Adriano Tort.
%  Reference: Tort, Kopell et al. 2010
%  [ chl_comodulation ] = TX_PhasePowerCoupling_AllTrial_hilbert_shuffle( ft_cell,trl_num,channels,shuffle_range,baseline_range,shuffle_time,shuffle_number)



srate = ft_cell.fsample;  % sampling rate


PhaseFreqVector=3:1:20;
AmpFreqVector=10:1:50;

PhaseFreq_BandWidth=4;
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

'Computing'

for times = 1:shuffle_number
    
    for chl = 1:length(channels)
        
        clear block_comodulation
        
        for trl = 1:trl_num
            
            
            
            t = ft_cell.time{trl};
            
            base_line = ((t>baseline_range(1))&(t<baseline_range(2)));
            
            shuffle_data = ((t>shuffle_range(1))&(t<shuffle_range(2)));
            data_length = length(find(shuffle_data == 1));
            
            shuffle_whole = ((t>shuffle_time(1))&(t<shuffle_time(2)));
            
            shuffle_point = length(shuffle_whole) - length(shuffle_data);
            
            lfp = ft_cell.trial{trl}(channels(chl),:);
            
            'CPU filtering'
            tic
            
            AmpFreqTransformed{trl} = zeros(length(AmpFreqVector), length(lfp(shuffle_data)));
            PhaseFreqTransformed{trl} = zeros(length(PhaseFreqVector), length(lfp(shuffle_data)));
            
            for ii=1:length(AmpFreqVector)
                Af1 = AmpFreqVector(ii) - AmpFreq_BandWidth/2;
                Af2= AmpFreqVector(ii) + AmpFreq_BandWidth/2;
                AmpFreq = eegfilt(lfp,srate,Af1,Af2); % just filtering
                temp_amp = abs(hilbert(AmpFreq));% getting the amplitude envelope
                
                
                data_data = temp_amp(shuffle_whole);
                base_base = temp_amp(base_line);
                datadata = data_data / mean(base_base);
                
                start_point = length(datadata) - data_length;
                start_point = floor(start_point * rand);
                
                
                AmpFreqTransformed{trl}(ii, :) = datadata(start_point+1:start_point+data_length);
            end
            
            for jj=1:length(PhaseFreqVector)
                Pf1 = PhaseFreqVector(jj) - PhaseFreq_BandWidth/2;
                Pf2 = PhaseFreqVector(jj) + PhaseFreq_BandWidth/2;
                PhaseFreq = eegfilt(lfp,srate,Pf1,Pf2); % this is just filtering
                temp_pha = angle(hilbert(PhaseFreq)); % this is getting the phase time series
                
                
                temp_pha = temp_pha(shuffle_whole);
                
                
                start_point = length(datadata) - data_length;
                start_point = floor(start_point * rand);
                
                PhaseFreqTransformed{trl}(jj, :) = temp_pha(start_point+1:start_point+data_length);
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
        
        
        
        chl_comodulation{times,channls(chl)} = Comodulogram;
        
    end
    
    
end

end

