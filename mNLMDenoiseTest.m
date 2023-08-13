% Load audio file
[y, Fs] = audioread('Baby.wav');

% Define different sets of Non-Local Means parameters
params = [    5, 2, 0.4432;    10, 3, 0.5;    20, 5, 1.0;];

% Define plot colors for each set of parameters
colors = ['r', 'g', 'm'];

% Apply Non-Local Means denoising with different parameters and plot results
for i = 1:size(params, 1)
    search_window = params(i, 1);
    patch_size = params(i, 2);
    h = params(i, 3);

    y_nlm = fNLM_denoise(y, search_window, patch_size, h);

    % Play the denoised signal at the original sampling rate
    soundsc(y_nlm, Fs);

    % Pause to allow the playback to finish before moving to the next iteration
    duration = length(y_nlm) / Fs;
    pause(duration + 1); % Add a 1-second pause between playbacks

    % Compute the FFT of the original and denoised signals
    Y = abs(fft(y));
    Y_nlm = abs(fft(y_nlm));

    % Compute the frequency vector
    f = (0:length(Y)-1) * Fs / length(Y);

    % Time-domain comparison plot
    figure;
    subplot(2, 1, 1);
    plot(y, 'b');
    hold on;
    plot(y_nlm, colors(i));
    hold off;
    title(['Time-domain Comparison (search_window=', num2str(search_window), ', patch_size=', num2str(patch_size), ', h=', num2str(h), ')']);
    xlabel('Time (samples)');
    ylabel('Amplitude');
    legend('Original Signal', 'Non-Local Means Denoised Signal');

    % Magnitude spectra comparison plot
    subplot(2, 1, 2);
    semilogx(f, mag2db(Y), 'b');
    hold on;
    semilogx(f, mag2db(Y_nlm), colors(i));
    hold off;
    title('Magnitude Spectra');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude ( dB)');
    legend('Original Signal', 'Non-Local Means Denoised Signal');
end