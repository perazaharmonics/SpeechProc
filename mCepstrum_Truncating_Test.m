[y, Fs] = audioread('Test_BB.wav'); % Read signal
x = y(:, 2); % Stereo projection into signal x, contains all samples left and right

framelength = 20;
nsample = round( framelength*Fs / 1000);
window = eval(sprintf('%s(nsample)', ' hamming '));
pos = 27343; 
frame = x(pos:pos+nsample-1);
time = (0:length(frame)-1)/Fs;
frameW = frame.*window;

Y = fft(frameW , nsample);
hz10000 = 10000*length(Y) / Fs;
f = (0:hz10000)*Fs / length(Y);
dbY10K = 20*log10(abs(Y(1:length(f)))+eps);
logY = log(abs(Y));
C = ifft(logY);
C10K = (C:1:length(f));

thisC = C; trunNo=10;
trunFn10 = zeros(length(f), 1); trunFn10(1:10) = 1;
thisC(trunNo:end-trunNo) = 0;
iC = exp(real(fft(thisC)));
dbiC10K10 = 20*log10(abs(iC(1:length(f)))+eps);

thisC = C; trunNo=30;
trunFn30 = zeros(length(f), 1); trunFn30(1:30) = 1;
thisC(trunNo:end-trunNo) = 0;
iC = exp(real(fft(thisC)));
dbiC10K30 = 20*log10(abs(iC(1:length(f)))+eps);

thisC = C; trunNo = 88;
trunFn80 = zeros(length(f), 1); trunFn80(1:80) = 1;
thisC(trunNo:end-trunNo) = 0;
iC = exp(real(fft(thisC)));
dbiC10K80 = 20*log10(abs(iC(1:length(f)))+eps);

subplot(6, 1 , 1);
plot(time , frame);
legend('Waveform'); xlabel('Time (s)'); ylabel('Amplitude'); 
subplot(6, 1 , 2);
plot(time, frameW);
legend('Windowed Waveform'); xlabel('Time (s)'); ylabel('Amplitude');
subplot(6 , 1 , 3);
plot(f, dbY10K);
legend('Spectrum'); xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
subplot(6 , 1 , 4);
plot(dbiC10K10(2:end));
legend('Cepstrum'); xlabel('Quefrequency (s)'); ylabel('Level');
subplot(6 , 1 , 5);
plot(dbiC10K30(2:end));
legend('Spectrum'); xlabel('Quefrequency (s)'); ylabel('Magnitude (dB)');
subplot(6 , 1 , 6);
plot(dbiC10K80(2:end));
legend('Spectrum'); xlabel('Quefrequency (s)'); ylabel('Magnitude (dB)');
% % Define different sets of Non-Local Means parameters
% params = [    5, 2, 0.4432;    10, 3, 0.5;    20, 5, 1.0;];
% 
% % Define plot colors for each set of parameters
% colors = ['r', 'g', 'm'];
% 
% % Apply Non-Local Means denoising with different parameters and plot results
% for i = 1:size(params, 1)
%     search_window = params(i, 1);
%     patch_size = params(i, 2);
%     h = params(i, 3);
% 
%     y_nlm = fNLM_denoise(y, search_window, patch_size, h);
% 
%     % Play the denoised signal at the original sampling rate
%     soundsc(y_nlm, Fs);
% 
%     % Pause to allow the playback to finish before moving to the next iteration
%     duration = length(y_nlm) / Fs;
%     pause(duration + 1); % Add a 1-second pause between playbacks
% 
%     % Compute the FFT of the original and denoised signals
%     Y = abs(fft(y));
%     Y_nlm = abs(fft(y_nlm));
% 
%     % Compute the frequency vector
%     f = (0:length(Y)-1) * Fs / length(Y);
% 
%     % Time-domain comparison plot
%     figure;
%     subplot(2, 1, 1);
%     plot(y, 'b');
%     hold on;
%     plot(y_nlm, colors(i));
%     hold off;
%     title(['Time-domain Comparison (search_window=', num2str(search_window), ', patch_size=', num2str(patch_size), ', h=', num2str(h), ')']);
%     xlabel('Time (samples)');
%     ylabel('Amplitude');
%     legend('Original Signal', 'Non-Local Means Denoised Signal');
% 
%     % Magnitude spectra comparison plot
%     subplot(2, 1, 2);
%     semilogx(f, mag2db(Y), 'b');
%     hold on;
%     semilogx(f, mag2db(Y_nlm), colors(i));
%     hold off;
%     title('Magnitude Spectra');
%     xlabel('Frequency (Hz)');
%     ylabel('Magnitude ( dB)');
%     legend('Original Signal', 'Non-Local Means Denoised Signal');
% end