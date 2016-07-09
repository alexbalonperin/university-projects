classdef Encoding
    properties (Access = private)
        utilities
        nb_features = 2
    end
    
    methods
        function obj = Encoding
            obj.utilities = Utilities;
        end

        function observations = encodeSignal(obj, filepath)
            y = obj.utilities.readFileWAV(filepath);
            frames_size = 100;
            b = buffer(y, frames_size);
            observations = zeros(size(b,2),obj.nb_features);
 
            for i = 1:size(b,2)
                w = hamming(frames_size);
                W = diag(sparse(w));
                yW = W * b(1:end,i);
                %figure(i+1);
                %plot(1:size(yW),yW);
                %Utilities.zerocros(b(1:end,i));
                observations(i,:) = obj.fourier_transform(yW);
            end
        end
        
         function [max_frequencies] = fourier_transform(obj,y)
            
            % FOURIER TRANSFORM
            %%%%%%%%%%%%%%%%%%%%%%

            Fs = 100; % Sampling frequency 
            T = 1/Fs; % Sample time 
            L =  size(y,1);% Length of signal 
            t = (0:L-1)*T; % Time vector
            maxFFTIdx = L/2;
            NFFT = 2^nextpow2(L); % Next power of 2 from length of y 
            Y = fft(y,NFFT)/L; % Y = FFT of original data 

            %compute energy
            log_e = sum(( abs( y(1:maxFFTIdx) ) ).^2);
            
            f = Fs/2*linspace(0,1,NFFT/2+1); % Frequencies used by FFT 
            %Generate and plot single-sided amplitude spectrum. 
            amplitudes = 2*abs(Y(1:NFFT/2+1));
            [maxtab, ~] = peakdet(amplitudes,1e-6,f);
            if(size(maxtab,1) ~= 1)
                %max_frequencies = zeros(1,3);
                max_frequencies = zeros(1,2);
                if ~isempty(maxtab)
                    [sorted_max, ~] = sortrows(maxtab,-2); % Sort it 
                    max_frequencies(1) = sorted_max(1,2);
                    max_frequencies(2) = sorted_max(2,2);
                    
   
                end
            else
                 max_frequencies(1) = maxtab(1,2);
                 max_frequencies(2) = log_e;
                 %max_frequencies(2) = 0;
            end
            %max_frequencies(3) = log_e;
            
            %       Plot of the peaks
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %figure(2);
            %plot(Fs*t,y); 
            %title('Original Signal: Current frame');

%              figure
%              plot(f,amplitudes); 
%              title('Single-Sided Amplitude Spectrum of y(t)');
%              hold on; %plot(mintab(:,1), mintab(:,2), 'g*');
%              xlabel('\omega')
%              ylabel('Y(\omega)')
%              plot(maxtab(:,1), maxtab(:,2), 'r*');
%               plot(sorted_max(1,1), sorted_max(1,2), 'g*');
%               plot(sorted_max(2,1), sorted_max(2,2), 'g*');
%               hold off;
%               pause;


            
            %       For Information
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Get the main frequencies and amplitudes 
            %[~, idx] = sort(amplitudes, 'descend'); % Sort it 
            % NOTE! 
            % In speech, I will not simply take the <n> largest 
            % amplitudes, but look for <n> PEAKS in the spectrum. 
            % For Matlab users: Download and look at peakdet. 
            %rc = zeros(size(transpose(y))); % rc == Reconstructed signal 
            %n=2; % No. frequencies to use --> n sine functions (see slides)
            % Plot the data and overlayed reconstruction 
            % using the <n> most prominent frequencies 
            % figure(4);
            %plot(Fs*t,y, 'b-.'); hold on; % Original data 
            %title('Original signal and reconstruction'); 
            % for rr = 1:n % Add up for important frequencies
            %     rc = rc + amplitudes(idx(rr))*sin(2*pi*f(idx(rr))*t); 
            % end
            %plot(Fs*t, rc, 'r-', 'LineWidth',2);
       end
    end

end