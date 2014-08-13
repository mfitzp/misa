function [segments]=misa_find_segments(spectra, n_of_segments)
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
%
% OUTPUT
% segments      : Segments used for alignment

    % Define regular regions across the spectra to n segments
    spec_size = length(spectra);
    n_per_segment = fix( spec_size/n_of_segments );
    
    % Minimum size of each segment
    min_size_per_segment = fix(n_per_segment/2);

    segments = [];
    next_start = 1;
    
    max_spc = max(spectra);    

    while next_start < spec_size
        % Calculate the start and end point
        s = next_start;
        
        % Iterate forward from the start position collecting the max of the spectra
        % at that location; 
        
        prev_v = Inf;
        sshifts = [];

        for ss = min_size_per_segment:n_per_segment
            if s+ss > spec_size
                break
            end

            v = max_spc(s+ss);
            sshifts = [sshifts v];
            prev_v = v;        
        end
        
        idx = find( sshifts==min(sshifts) );
        % Check shift back? Note the idx vs. actual shift is off by one because matlab
        e = s+min_size_per_segment+idx; % Shift this segment equal distance
        if isempty(e) || e>spec_size% Past the end
            e = spec_size;
        end
        segments = [segments, s e];
        % Set the start of the next segment
        next_start = e+1;            
    end

    

    % Scale provided so do the plots
    if exist('x_axis')
        % Plot figure showing segments    
        figure;
        hold on;
    
        plot(x_axis, aligned);   
        set(gca, 'XDir', 'reverse')
        overall_max = max( aligned(:) );
    
        % Draw regular segments (icoshift default)
        for i = 1:n_of_segments
            o = (n_per_segment*(i-1))+1;
            line([x_axis(o) x_axis(o)],[0 overall_max],'Color','b');
        end
        % Draw segments that were used
        for i = 1:length(segments)/2
            s = segments(i*2-1);
            line([x_axis(s) x_axis(s)],[0 overall_max],'Color','r');
        end
    
        hold off;
    end
end
