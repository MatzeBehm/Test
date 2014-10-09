close all;
chirppoints=2048;
c=physconst('Lightspeed');
fc=76.5e9;
lamda=c/fc;
fs=40e6;
bw=1e9;
tm=53.7e-6;
sweep_slope=bw/tm;
v_max = 50*1000/3600;
range_max = 120;

[Channel1,Channel2,Channel3,Channel4]=importfileCSVData_Messbox('Data\tst11.csv',chirppoints);
%RawData=[Channel1,Channel2,Channel3,Channel4];
figure;
hold all;
plot(Channel1(:,1));
plot(Channel2(:,1))
plot(Channel3(:,1))
plot(Channel4(:,1))

[FFT_Ch1,FFT_Ch2,FFT_Ch3,FFT_Ch4]=PlotFFT(fs,Channel1,Channel2,Channel3,Channel4);
[FFT_Ch1,FFT_Ch2,FFT_Ch3,FFT_Ch4]=PlotFFT2(fs,Channel1,Channel2,Channel3,Channel4,'true','true');
 

%Abstands /bzw. Doppler Karte
    hrdresp = phased.RangeDopplerResponse('PropagationSpeed',c,...
        'DopplerOutput','Speed','OperatingFrequency',fc,...
        'SampleRate',fs,'RangeMethod','Dechirp','SweepSlope',sweep_slope,...
        'RangeFFTLengthSource','Property','RangeFFTLength',2048,...
        'DopplerFFTLengthSource','Property','DopplerFFTLength',256);
    [ii,jj]=size(Channel1);
    xr=complex(zeros(ii,jj));
    
%     for m = 1:jj
%        x=step(hrdresp,Channel1(:,m));
%        xr(:,m) = x;
%     end
%     
    
    
    figure;
    plotResponse(hrdresp,Channel1);                     % Plot range Doppler map
    axis([-v_max v_max 0 range_max])

    %Zielcharakterisierung:
    %MUSIC Test
 
        P = pmusic(FFT_Ch3(:,1),100);
        % Create data object
        hps = dspdata.pseudospectrum(P,'Fs',fs); 
        % Plot the pseudospectrum
        plot(hps);
           
        %Abstand
            fb_rng = rootmusic(pulsint(sqrt(Channel1),'coherent'),3,fs)        %estimated target frequency
            rng_est = beat2range(fb_rng,sweep_slope,c)              %estimated target distance
                     
        %Geschwindigkeit
            %peak_loc = val2ind(rng_est,c/(fs*2));
            %fd = -rootmusic(xr(peak_loc,:),1,1/tm);
            %v_est = dop2speed(fd,lambda)/2

%Richtungsschätzung:
    test=PlotFFT2_angle( fs,Channel1(:,1),Channel2(:,1),Channel3(:,1),Channel4(:,1),'false','false');
x=[ifft(FFT_Ch1(:,1)), ifft(FFT_Ch2(:,1)),ifft(FFT_Ch3(:,1)),ifft(FFT_Ch4(:,1))];
    %MUSIC

        ha = phased.ULA('NumElements',4,'ElementSpacing',3*lamda/2);
        hdoa = phased.RootMUSICEstimator('SensorArray',ha,...
            'OperatingFrequency',fc,...
            'NumSignalsSource','Auto','NumSignalsMethod','AIC');
        doas = step(hdoa,x)
        az = broadside2az(sort(doas),0)
