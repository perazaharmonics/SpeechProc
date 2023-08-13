[x, fs] = audioread('Baby.wav', [24020 25930]);
x = x(:, 1);
x = resample(x, 10000, fs); fs = 10000;
t = (0:length(x)-1) / fs;
subplot(4, 1 , 1);
plot(t, x);
legend('Waveform'); xlabel('Time (s)'); ylabel('amplitude');
x1 = x.*hamming(length(x));
subplot(4, 1 ,2);
plot(t, x1);
legend('Waveform'); xlabel('Time (s)'); ylabel('amplitude');
ncoeff = 20; %rule of thumb for formant estimation
preemph = [1 -0.53]; 
x1 = filter(1, preemph, x1);
a = lpc(x1, ncoeff);
[h, f] = freqz(1, a, 512, fs);
subplot(4, 1 ,4);
plot(f, 20 * log10(abs(h) + eps));
legend(' LPC Filter');  xlabel('Frequency (Hz)'); ylabel('Gain (dB)'); 

subplot(4, 1, 3);
outfft = fft(x, 1024);
plot(f, 20 * log10(abs(outfft(1:512)) + eps));
legend(' Frequency Response');  xlabel('Frequency (Hz)'); ylabel('Gain (dB)'); 