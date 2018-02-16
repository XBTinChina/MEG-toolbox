function [ selected_data ] = TX_get_channel_data( channel,data,format )
%   [ selected_data ] = TX_get_channel_data( channel,data,format )
%   channel: is 2*N matrix, the first row for left side, the second row for
%   right side.
%   data: could be fieldtrip data or matrix, with channel at first
%   dimension.
%   format: 'cell','matrix'

if strcmp(format,'matrix')
    if ndims(data) == 2
        left = data(channel(1,:),:);
    elseif ndimes(data) ==3 
        left = data(channel(1,:),:,:);
    end
    selected_data{1} = left;
    if size(channel,1) == 2
        
    if ndims(data) == 2
        right = data(channel(1,:),:);
    elseif ndimes(data) ==3 
        right = data(channel(1,:),:,:);
    end
    selected_data{2} = right;
    end
    
    
    
    
    
    
elseif strcmp(format,'cell')
    length_cell = length(data);
    for i = 1:length_cell
        if ndims(data{i}) == 2
            left = data{i}(channel(1,:),:);
        elseif ndimes(data{i}) ==3 
            left = data{i}(channel(1,:),:,:);
        end
        selected_data{i,1} = left;
        if size(channel,1) == 2
            if ndims(data{i}) == 2
                right = data{i}(channel(1,:),:);
            elseif ndimes(data) ==3 
                right = data{i}(channel(1,:),:,:);
            end
            selected_data{i,2} = right;
        end
               
    end

end

