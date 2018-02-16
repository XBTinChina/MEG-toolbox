function [ chl_block_comodulation ] = TX_PhasePowerCoupling_AllTrial_wavelet( ft_cell,trl_num,window_length,channels,time_range)
%  Compute phase-power coupling using Hilbert transform
%  Most part of the codes are from Adriano Tort.
%  Reference: Tort, Kopell et al. 2010
%  [ chl_block_comodulation,chl_avr_comodulation ] = TX_PhasePowerCoupling( ft_cell,trl_num,channls)




chl_num = channels;

srate = 200
'just for modulation'

%srate = ft_cell.fsample;




PhaseFreqVector=2:1:15;
AmpFreqVector=10:1:60;



Phase_data =  TX_Phase_wavelet( ft_cell,time_range,PhaseFreqVector,window_length,channels,trl_num );
Power_data =  TX_Power_wavelet( ft_cell,time_range,AmpFreqVector,window_length,channels,trl_num );

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


for chl = 1:length(channels)
    avr_co = zeros(length(PhaseFreqVector),length(AmpFreqVector));
    clear block_comodulation
    
    for trl = 1:trl_num
        
        

       
        
        AmpFreqTransformed{trl} = zeros(length(AmpFreqVector), length(time_range));
        PhaseFreqTransformed{trl} = zeros(length(PhaseFreqVector), length(time_range));
        
        for ii=1:length(AmpFreqVector)
            
            
            AmpFreqTransformed{trl}(ii, :) = squeeze(Power_data{trl}(channels(chl),ii,:));
            
        end
        
        for jj=1:length(PhaseFreqVector)
            
            PhaseFreqTransformed{trl}(jj, :) = squeeze(Phase_data{trl}(chl,jj,:));
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
    
    
    block_comodulation = Comodulogram;
    
    chl_block_comodulation{chl} = block_comodulation;
    
end



'Finish'
end

