function [Z1 ] = PlotFFT2_angle( Fs,y1,y2,y3,y4,rangeplot,dopplerplot )
%UNTITLED4 Plots 2DFFT spectrum
%   Detailed explanation goes here
if nargin<=5
    dopplerplot='false';
    rangeplot = 'false';
end
z=[y1,y2,y3,y4];
    [L,M]=size(z);
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    NFFT2 = 2^nextpow2(M);
    Z1 = fft2(z,NFFT,NFFT2)./L./M;
    
    frange = Fs/2*linspace(0,1,NFFT/2+1);
    fangle=Fs/2*linspace(0,1,NFFT2/2+1);


% Plot single-sided amplitude spectrum.
    if strcmp(dopplerplot,'true')
        figure;
        hold all;
        surf(frange,fangle,Z1');
        
        title('Single-Sided Amplitude Spectrum of y(t)')
        xlabel('Frequency (Hz)')
        ylabel('|Y(f)|[dB]')
        %legend('Ch1','Ch2','Ch3','Ch4')
        hold off;
    end
    
    if  strcmp(rangeplot,'true')
        figure;
        hold all;
        plot(frange,10*log10(2*abs(Y1(1:NFFT/2+1,1))))
        plot(frange,10*log10(2*abs(Y2(1:NFFT/2+1,1)))) 
        plot(frange,10*log10(2*abs(Y3(1:NFFT/2+1,1)))) 
        plot(frange,10*log10(2*abs(Y4(1:NFFT/2+1,1)))) 
        title('Single-Sided Amplitude Spectrum of y(t)')
        xlabel('Frequency (Hz)')
        ylabel('|Y(f)|[dB]')
        legend('Ch1','Ch2','Ch3','Ch4');
        hold off;
    end
end

