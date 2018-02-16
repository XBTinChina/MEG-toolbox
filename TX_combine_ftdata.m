function [ combine,ft_matrix,sampleinfo] = TX_combine_ftdata( ft_cell)
%   function [ combine ] = TX_combine_ftdata( ft_cell)
%


num_cell = length(ft_cell);


ft_matrix = [];
for n = 1:num_cell
    
    if ~isempty(ft_cell{n})
        trial_num = length(ft_cell{n}.trial);
    else
        trial_num = 0;
    end
    
    ft_matrix = [ ft_matrix trial_num];
end




for n = 2:num_cell
    
    if ~isempty(ft_cell{n})
        
        ft_cell{1}.time = [ft_cell{1}.time ft_cell{n}.time];
        ft_cell{1}.trial = [ft_cell{1}.trial ft_cell{n}.trial];
        ft_cell{1}.sampleinfo = cat(1,ft_cell{1}.sampleinfo,ft_cell{n}.sampleinfo );
        
    end
    
end

combine = ft_cell{1};
sampleinfo = ft_cell{1}.sampleinfo;

end

