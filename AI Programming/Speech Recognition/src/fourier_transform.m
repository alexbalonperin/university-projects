function [max_frequencies] = fourier_transform(y,hz)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Created by Alexandre Balon-Perin
%   Date: 12.10.2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% FOURIER TRANSFORM
%%%%%%%%%%%%%%%%%%%%%%

Fs = hz; % Sampling frequency 
T = 1/Fs; % Sample time 
L =  size(y,1);% Length of signal 
t = (0:L-1)*T; % Time vector

NFFT = 2^nextpow2(L); % Next power of 2 from length of y 
Y = fft(y,NFFT)/L; % Y = FFT of original data 
f = Fs/2*linspace(0,1,NFFT/2+1); % Frequencies used by FFT 
%Generate and plot single-sided amplitude spectrum. 
amplitudes = 2*abs(Y(1:NFFT/2+1));
[maxtab, ~] = peakdet(amplitudes,0.0001,f);
[sorted_max, ~] = sortrows(maxtab,-2); % Sort it 
max_frequencies = [sorted_max(1,2),sorted_max(2,2)];

%
%       Plot of the peaks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%figure(2);
%plot(Fs*t,y); 
%title('Original Signal: Current frame');

% figure
% plot(f,amplitudes); 
% title('Single-Sided Amplitude Spectrum of y(t)');
% hold on; %plot(mintab(:,1), mintab(:,2), 'g*');
% plot(maxtab(:,1), maxtab(:,2), 'r*');
% plot(sorted_max(1,1), sorted_max(1,2), 'g*');
% plot(sorted_max(2,1), sorted_max(2,2), 'g*');
% hold off;


%
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
    
    
    
    
    
    
    