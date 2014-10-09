fs = 8000; t = (0:1/fs:1).';
x1 = cos(2*pi*t*300); x2 = cos(2*pi*t*400);
ha = phased.ULA('NumElements',10,'ElementSpacing',1);
ha.Element.FrequencyRange = [100e6 300e6];
fc = 150e6;
x = collectPlaneWave(ha,[x1 x2],[10 20;45 60]',fc);
rng default;
noise = 0.1/sqrt(2)*(randn(size(x))+1i*randn(size(x)));
hdoa = phased.RootMUSICEstimator('SensorArray',ha,...
    'OperatingFrequency',fc,...
    'NumSignalsSource','Property','NumSignals',2);
doas = step(hdoa,x+noise)
az = broadside2az(sort(doas),[20 60])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = 10;
d = 0.5;
elementPos = (0:N-1)*d;
angles = [0 -25 30];
Nsig = 3;
R = sensorcov(elementPos,angles,db2pow(-5));
doa = rootmusicdoa(R,Nsig)