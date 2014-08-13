function [aligned, segments]=misa(spectra, n_of_segments, Scal, plot_diff)
% [xCS,ints,ind,target] = icoshift(xT,xP,inter[,n[,options[,Scal]]])
% MISA: Minimally Improved Segmental Alignment
%
% [aligned, segments]=bass(spectra, ppm, n_of_segments)
%
% An algorithm for selection of segments for subsequent icoshift-based alignment.
% Provide with a spectra-like dataset and the minimum number of segments to begin 
% optimising from. The algorithm will return an optimised set by optionally reducing
% segments to align them on local minima. This reduces the likelihood of segment edges
% landing in peaks and preventing alignment.
%
% INPUT
% spectra        : target vector.
% n_of_segments  : target number of segments (will optimised upwards)
% Scal           : optional x axis scale
%
% OUTPUT
% aligned       : Vector of adjusted segments in the format to pass to icoshift
% segments      : Segments used for alignment
%
    segments = misa_find_segments(spectra, n_of_segments)

    % Perform icoshift aligned with bin segments + offset at bin N segments
    [xCS,ints,ind,target] = icoshift('median', spectra, segments);
    aligned = xCS;

    % Scale provided so do the plots
    if exist('Scal')
        % Plot figure showing segments    
        figure;
        hold on;
    
        plot(Scal, aligned);   
        set(gca, 'XDir', 'reverse')
        overall_max = max( aligned(:) );
        % Define regular regions across the spectra to n segments
        spec_size = length(spectra);
        n_per_segment = fix( spec_size/n_of_segments );
    
        % Draw regular segments (icoshift default)
        for i = 1:n_of_segments
            o = (n_per_segment*(i-1))+1;
            line([Scal(o) Scal(o)],[0 overall_max],'Color','b');
        end
        % Draw segments that were used
        for i = 1:length(segments)/2
            s = segments(i*2-1);
            line([Scal(s) Scal(s)],[0 overall_max],'Color','r');
        end
    
        hold off;
        
        if exist('plot_diff')
            figure;
            hold on;
            plot(Scal, median(aligned), 'b');   
            [xCS,ints,ind,target] = icoshift('median', spectra, n_of_segments);
            plot(Scal, median(xCS), 'r');   
            set(gca, 'XDir', 'reverse')
            hold off;
        end
        
        
    end
end
