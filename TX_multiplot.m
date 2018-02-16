function [ ] = TX_multiplot( data_set,method,xlimm,ylimm,zlimm,interactive,highlight,high_channel)
%   TX_multiplot( data_set,method,
%   xlimm,ylimm,zlimm,baseline,interactive,data_type )
%   Method: 'single' 'single3' 'multi' 'multi3' 'topo' 'topo3'
%
load layout
cfg = [];
%cfg.marker = 'off';
cfg.markersize = 0.5;
cfg.comment = 'no';

if exist('highlight')
    cfg.highlight = highlight;
    cfg.highlightchannel   =  high_channel;
    
end

cfg.xlim = xlimm;

cfg.layout = layout;
cfg.channel = 1:157;
%cfg.baseline = baseline;
%cfg.baselinetype = 'absolute';



if interactive == 1
    cfg.interactive = 'yes';
end



 



switch method
    case 'single'
        cfg.ylim = ylimm;
        cfg.channel = channel;
        
        ft_singleplotER(cfg,data_set);
        
    case 'single3'
        cfg.ylim = ylimm;
        cfg.zlim = zlimm;
        ft_singleplotTFR(cfg, data_set);
        
    case 'multi'
        cfg.ylim = ylimm;
        ft_multiplotER(cfg,data_set);
        
    case 'multi3'
        cfg.ylim = ylimm;
        cfg.zlim = zlimm;
        ft_multiplotTFR(cfg,data_set);
        
    case 'topo'
        %cfg.ylimm = ylimm;
        cfg.zlim = zlimm;
        ft_topoplotER(cfg,data_set)
        
    case 'topo3'
        cfg.ylim = ylimm;
        cfg.zlim = zlimm;
        cfg.gridscale   = 10;
        cfg.contournum = 1;
        %cfg.colormap = spring(4);
        %cfg.markersymbol = 'o';
        %cfg.markersize = 4;
        cfg.markercolor = [0 0.69 0.94]
        ft_topoplotTFR(cfg,data_set)
        
end

end

