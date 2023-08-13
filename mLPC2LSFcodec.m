[x, fs] = audioread('Baby.wav', [24020 25930]);
x = x(:, 1);
x = resample(x, 10000, fs); fs = 10000;
t=(0:length(x)-1) / fs;
x1 = x.*hamming(length(x));
ncoeff=20;                  % rule of thumb for formant estimation

a = lpc(x1,ncoeff);
semilogy(t, x1); legend('Waveform'); xlabel('Time (s)'); ylabel('Amplitude');
zp = zplane([], a); hold on;

%% Convert to LSF Frequenues 
LSFcoef = poly2lsf( a );
LSFpt = [ exp(LSFcoef*1i); conj(exp(LSFcoef*1i) )];
figure, plot(LSFpt, 'g*');