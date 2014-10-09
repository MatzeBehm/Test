function [Y1,Y2,Y3,Y4 ] = PlotFFT( Fs,y1,y2,y3,y4)
%UNTITLED4 Plots FFT spectrum
%   Detailed explanation goes here

L=length(y1);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y1 = fft(y1,NFFT)/L;
Y2 = fft(y2,NFFT)/L;
Y3 = fft(y3,NFFT)/L;
Y4 = fft(y4,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided Doppler spectrum.
    figure;
    hold all;
    plot(f,10*log10(2*abs(Y1(1:NFFT/2+1))))
    plot(f,10*log10(2*abs(Y2(1:NFFT/2+1)))) 
    plot(f,10*log10(2*abs(Y3(1:NFFT/2+1)))) 
    plot(f,10*log10(2*abs(Y4(1:NFFT/2+1)))) 
    title('Single-Sided Amplitude Spectrum of y(t)')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|[dB]')
    legend('Ch1','Ch2','Ch3','Ch4')
    hold off;
end

