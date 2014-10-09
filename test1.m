rng default;
n = (0:99)';
freqs = [pi/4 pi/4+0.06];
s = 2*exp(1j*freqs(1)*n)+1.5*exp(1j*freqs(2)*n)+...
    0.5*randn(100,1)+1j*0.5*randn(100,1);
[~,R] = corrmtx(s,12,'mod');
[W,P] = rootmusic(R,2,'corr')