function [Y1,Y2,Y3,Y4 ] = PlotFFT2( Fs,y1,y2,y3,y4,rangeplot,dopplerplot )
%UNTITLED4 Plots 2DFFT spectrum
%   Detailed explanation goes here
if nargin<=5
    dopplerplot='false';
    rangeplot = 'false';
end

    [L,M]=size(y1);
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    NFFT2 = 2^nextpow2(M);
    Y1 = fft2(y1,NFFT,NFFT2)./L./M;
    Y2 = fft2(y2,NFFT,NFFT2)./L./M;
    Y3 = fft2(y3,NFFT,NFFT2)./L./M;
    Y4 = fft2(y4,NFFT,NFFT2)./L./M;
    frange = Fs/2*linspace(0,1,NFFT/2+1);
    fdoppler=Fs/2*linspace(0,1,NFFT2/2+1);


% Plot single-sided amplitude spectrum.
    if strcmp(dopplerplot,'true')
        figure;
        hold all;
        plot(fdoppler,10*log10(2*abs(Y1(1,1:NFFT2/2+1))))
        plot(fdoppler,10*log10(2*abs(Y2(1,1:NFFT2/2+1)))) 
        plot(fdoppler,10*log10(2*abs(Y3(1,1:NFFT2/2+1)))) 
        plot(fdoppler,10*log10(2*abs(Y4(1,1:NFFT2/2+1)))) 
        title('Doppler FFT2 Amplitude Spectrum of y(t)')
        xlabel('Frequency (Hz)')
        ylabel('|Y(f)|[dB]')
        legend('Ch1','Ch2','Ch3','Ch4')
        hold off;
    end
    
    if  strcmp(rangeplot,'true')
        figure;
        hold all;
        plot(frange,10*log10(2*abs(Y1(1:NFFT/2+1,1))))
        plot(frange,10*log10(2*abs(Y2(1:NFFT/2+1,1)))) 
        plot(frange,10*log10(2*abs(Y3(1:NFFT/2+1,1)))) 
        plot(frange,10*log10(2*abs(Y4(1:NFFT/2+1,1)))) 
        title('2DFFT Range Plot Spectrum of y(t)')
        xlabel('Frequency (Hz)')
        ylabel('|Y(f)|[dB]')
        legend('Ch1','Ch2','Ch3','Ch4')
        hold off;
    end
end

