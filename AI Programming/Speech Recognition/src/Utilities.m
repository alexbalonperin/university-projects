classdef Utilities
   properties(Access = private)
       nb_files = 25
   end
    
   methods (Static = true)
       
       function [t,s]=zerocros(x,m)
             % Inputs:  x = input waveform
             %          m = mode string containing:
             %              'p' - positive crossings only
             %              'n' - negative crossings only
             %              'b' - both (default)
             %              'r' - round to integer values
             %
             % Outputs: t = sample positions of zero crossings (not necessarily integers)
             %          s = estimated slope of x at the zero crossing
             if nargin<2
                 m='b';
             end
             s=x>=0;
             k=s(2:end)-s(1:end-1);
             if any(m=='p')
                 f=find(k>0);
             elseif any(m=='n')
                 f=find(k<0);
             else
                 f=find(k~=0);
             end
             s=x(f+1)-x(f);
             t=f-x(f)./s;
             if ~nargout
                 n=length(x);
                 plot(1:n,x,'-',t,zeros(length(t),1),'o');
             end
        end
       
       function y = readFileWAV(filepath)
            try
                y = wavread(filepath);
                %figure(1)
                %plot(1:size(y),y)
            catch ERR_MSG
                disp('Error Reading Data! Check Unit')
                rethrow(ERR_MSG)
            end
        end
       
       function count = getNbLines(filepath)
            [~, result] = system( ['wc -l ', filepath] );
            i=1;
            while isspace(result(i))
                i=i+1;
            end
            count = result(i);
            i=i+1;
            while ~isspace(result(i))
                count = strcat(count,result(i));
                i=i+1;
            end
       end
       
       
       
       function [maxtab, mintab]=peakdet(v, delta, x)
            %PEAKDET Detect peaks in a vector
            %        [MAXTAB, MINTAB] = PEAKDET(V, DELTA) finds the local
            %        maxima and minima ("peaks") in the vector V.
            %        MAXTAB and MINTAB consists of two columns. Column 1
            %        contains indices in V, and column 2 the found values.
            %      
            %        With [MAXTAB, MINTAB] = PEAKDET(V, DELTA, X) the indices
            %        in MAXTAB and MINTAB are replaced with the corresponding
            %        X-values.
            %
            %        A point is considered a maximum peak if it has the maximal
            %        value, and was preceded (to the left) by a value lower by
            %        DELTA.

            % Eli Billauer, 3.4.05 (Explicitly not copyrighted).
            % This function is released to the public domain; Any use is allowed.

            maxtab = [];
            mintab = [];

            v = v(:); % Just in case this wasn't a proper vector

            if nargin < 3
              x = (1:length(v))';
            else 
              x = x(:);
              if length(v)~= length(x)
                error('Input vectors v and x must have same length');
              end
            end

            if (length(delta(:)))>1
              error('Input argument DELTA must be a scalar');
            end

            if delta <= 0
              error('Input argument DELTA must be positive');
            end

            mn = Inf; mx = -Inf;
            mnpos = NaN; mxpos = NaN;

            lookformax = 1;

            for i=1:length(v)
              this = v(i);
              if this > mx, mx = this; mxpos = x(i); end
              if this < mn, mn = this; mnpos = x(i); end

              if lookformax
                if this < mx-delta
                  maxtab = [maxtab ; mxpos mx];
                  mn = this; mnpos = x(i);
                  lookformax = 0;
                end  
              else
                if this > mn+delta
                  mintab = [mintab ; mnpos mn];
                  mx = this; mxpos = x(i);
                  lookformax = 1;
                end
              end
            end
       end
   end
       
      
   
   methods 
        function output_filename = concatFilesWAV(obj, word)
           output_filename = strcat('files/sounds/',word,'.wav');
           if exist(output_filename)
               delete(output_filename); 
           end
           
           output = Utilities.readFileWAV(strcat('files/soundfile-wav/',word,'_0.wav'));
           for file_nb=1:obj.nb_files
               input_filename = strcat('files/soundfile-wav/',word,'_',int2str(file_nb),'.wav');
               output = [output; Utilities.readFileWAV(input_filename)];
           end
           wavwrite(output, output_filename);           
        end
       
   end
end