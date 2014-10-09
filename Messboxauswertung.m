close all;

chirppoints=2048;
c=physconst('Lightspeed');
fc=76.5e9;
lambda=c/fc;
fs=40e6;
bw=1e9;
tm=53.7e-6;
sweep_slope=bw/tm;
v_max = 50*1000/3600;
range_max = 120;
[filename, pathname] = ...
     uigetfile({'*.m';'*.slx';'*.mat';'*.dat';'*.*'},'File Selector');

%filename='T:\Agethen Roman\Vermessung RFE´s 27.05.2014\binary_test.dat';
%filename='T:\Agethen Roman\Vermessung RFE´s 27.05.2014\BU77_2.0_Alte_Software_Systemdiagramm_Data.dat';
%filename='T:\Agethen Roman\Matlab\BU77_2.1_Minus_5_bis_plus_5_systemdiagram_data.dat';
%filename='T:\Agethen Roman\Matlab\BU77_2.1_Var.A_18_Minus_5_bis_plus_5_systemdiagram_data.dat'
%filename='T:\Agethen Roman\Matlab\BU77_2.0_Minus_5_bis_plus_5_systemdiagram_data.dat';
%filename='T:\Agethen Roman\Vermessung 02.06.2014\BU77_2.1_RFE_Romans_RFE_Agethen_Test\BU77_2.1_RFE_Agethen_Test_Systemdiagram_Data.dat'
%filename='T:\Agethen Roman\Matlab\BU77_2.1_RFE_Agethen_Test_Systemdiagram_Data.dat';
%filename='T:\Agethen Roman\Matlab\BU77_2.1_RFE_Agethen_Test2_Systemdiagram_Data.dat';

numberOfChirps=128;
numberOfSamples =2048;

data=BinaryRead( filename );


motorwinkel=0;

%importiert die Datenarrays der 4 Kanäle für einen Motorwinkel
[Channel1,Channel2,Channel3,Channel4]=GetData4Winkel(data,motorwinkel,numberOfChirps,numberOfSamples);

%Messauswertung aus einem CSV File
%[Channel1,Channel2,Channel3,Channel4]=importfileCSVData_Messbox('Data\tst11.csv',chirppoints);


%View Data
[FFT_Ch1,FFT_Ch2,FFT_Ch3,FFT_Ch4]=PlotFFT(fs,Channel1,Channel2,Channel3,Channel4);


% Plot single-sided Doppler spectrum.
    figure;
    hold all;
    L=length(Channel1);
    NFFT = 2^nextpow2(L);
    freqs = fs/2*linspace(0,1,NFFT/2+1);
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    plot(beat2range(freqs',bw/tm),10*log10(2*abs(FFT_Ch1(1:NFFT/2+1))))
    plot(beat2range(freqs',bw/tm),10*log10(2*abs(FFT_Ch2(1:NFFT/2+1)))) 
    plot(beat2range(freqs',bw/tm),10*log10(2*abs(FFT_Ch3(1:NFFT/2+1)))) 
    plot(beat2range(freqs',bw/tm),10*log10(2*abs(FFT_Ch4(1:NFFT/2+1)))) 
    title('1D FFT Amplitude Spectrum of y(t)')
    xlabel('distance [m]')
    ylabel('|Y(f)|[dB]')
    legend('Ch1','Ch2','Ch3','Ch4')
    hold off;

[FFT_Ch1,FFT_Ch2,FFT_Ch3,FFT_Ch4]=PlotFFT2(fs,Channel1,Channel2,Channel3,Channel4,'true','true');
 
 figure;
 x=[ifft(FFT_Ch1(:,1)), ifft(FFT_Ch2(:,1)),ifft(FFT_Ch3(:,1)),ifft(FFT_Ch4(:,1))];
 plot(x);
 legend('Ch1','Ch2','Ch3','Ch4');

%Abstands /bzw. Doppler Karte
    hrdresp = phased.RangeDopplerResponse('PropagationSpeed',c,...
        'DopplerOutput','Speed','OperatingFrequency',fc,...
        'SampleRate',fs,'RangeMethod','Dechirp','SweepSlope',sweep_slope,...
        'RangeFFTLengthSource','Property','RangeFFTLength',2048,...
        'DopplerFFTLengthSource','Property','DopplerFFTLength',256);
    [ii,jj]=size(Channel1);
    xr=complex(zeros(ii,jj));
       
    
    figure;
    plotResponse(hrdresp,Channel1);                     % Plot range Doppler map
    axis([-v_max v_max 0 range_max])

    %Zielcharakterisierung:
               
        %Abstand
            %[~,R] = corrmtx(x(:,1),2000,'mod');
            fb_rng = rootmusic(x',4,fs)        %estimated target frequency
            rng_est = beat2range(fb_rng,sweep_slope,c)  %estimated target distance
                     
        %Geschwindigkeit
            peak_loc = val2ind(rng_est(1),c/(fs*2))
            fd = -rootmusic(Channel1(peak_loc,:),2,1/tm);
            v_est = dop2speed(fd,lambda)/2
        
        %Winkel
        x=[ifft(FFT_Ch3(:,1)),ifft(FFT_Ch2(:,1)),ifft(FFT_Ch1(:,1)), ifft(FFT_Ch4(:,1))];
        R=cov(x');    
        fb_degree = rootmusicdoa(R,2)
        fb_degree2 = espritdoa(R,2)
        
        %MUSIC Test
        
        [S,w] = pmusic(x(:,1),1000);
        % Create data object
        hps = dspdata.pseudospectrum(S,'Fs',fs); 
        % Plot the pseudospectrum
        figure;
        plot(hps);

%Richtungsschätzung:
    test=PlotFFT2_angle( fs,Channel1x(:,1),Channel2(:,1),Channel3(:,1),Channel4(:,1),'false','false');

    %MUSIC

        ha = phased.ULA('NumElements',4,'ElementSpacing',lambda/2);
        hdoa = phased.RootMUSICEstimator('SensorArray',ha,...
            'OperatingFrequency',fc,...
            'NumSignalsSource','Auto','NumSignalsMethod','AIC');
        doas = step(hdoa,x')
        az = broadside2az(sort(doas),0)
        
     %ESPRIT
        
        ha = phased.ULA('NumElements',4,'ElementSpacing',lambda/2);
        hdoa = phased.ESPRITEstimator('SensorArray',ha,...
            'OperatingFrequency',fc);
        doas = step(hdoa,x');
        az = broadside2az(sort(doas),0)
