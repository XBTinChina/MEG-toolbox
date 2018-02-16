function [ chl_block_comodulation ] = TX_PhasePowerCoupling_AllTrial_wavelet_shuffle( ft_cell,trl_num,channels,time_range,shuffle_range,shuffle_time)
%  Compute phase-power coupling using Hilbert transform
%  Most part of the codes are from Adriano Tort.
%  Reference: Tort, Kopell et al. 2010
%  [ chl_block_comodulation,chl_avr_comodulation ] = TX_PhasePowerCoupling( ft_cell,trl_num,channls)




chl_num = channels;

srate = ft_cell.fsample;




PhaseFreqVector=4:1:20;
AmpFreqVector=10:1:50;



Phase_data =  TX_Phase_wavelet( ft_cell,shuffle_range,PhaseFreqVector,channels,trl_num );
Power_data =  TX_Power_wavelet( ft_cell,shuffle_range,AmpFreqVector,channels,trl_num );

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
for times = 1:shuffle_time

for chl = 1:length(channels)
    
    clear block_comodulation
    
    for trl = 1:trl_num 
        
        AmpFreqTransformed{trl} = zeros(length(AmpFreqVector), length(time_range));
        PhaseFreqTransformed{trl} = zeros(length(PhaseFreqVector), length(time_range));
        
        shuffle_number = length(shuffle_range) - length(time_range);
        
        
        for ii=1:length(AmpFreqVector)
            
            shuffle_start = floor (shuffle_number * rand(1));  
            
            AmpFreqTransformed{trl}(ii, :) = squeeze(Power_data{trl}(channels(chl),ii,shuffle_start+1:shuffle_start+length(time_range) ));
            
        end
        
        for jj=1:length(PhaseFreqVector)
            
            shuffle_start = floor (shuffle_number * rand(1));  
            
            PhaseFreqTransformed{trl}(jj, :) = squeeze(Phase_data{trl}(channels(chl),jj,shuffle_start+1:shuffle_start+length(time_range) ));
            
        end   
        
    end
    
    
    Comodulogram=single(zeros(length(PhaseFreqVector),length(AmpFreqVector)));
    
    
    % Do comodulation calculation
    'Comodulation loop'
    
    
    
    
    counter1=0;
    for ii=1:length(PhaseFreqVector)
        counter1=counter1+1;
        
        
        
        counter2=0;
        for jj=1:length(AmpFreqVector)
            counter2=counter2+1;
           
            
            
            phasephase = []; ampamp = [];
            for trl = 1:trl_num
                phasephase = cat(2,phasephase,PhaseFreqTransformed{trl}(ii, :));
                ampamp =  cat(2,ampamp,AmpFreqTransformed{trl}(jj, :));
            end
            
            [MI,MeanAmp]=ModIndex_v2(phasephase, ampamp , position);
            Comodulogram(counter1,counter2)=MI;
        end
    end
    
    
    
    
    chl_block_comodulation{channels(chl),times} = Comodulogram;
    
end


['shuffle_' num2str(times)]

end
'Finish'
end

