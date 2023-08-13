% Load audio file
[y, Fs] = audioread('Baby.wav');
% Define filter parameters
win_size_w = 128;
overlap_w = win_size_w/2;
n_fft = 2^nextpow2(win_size_w / 2);

% Zero-padding for the original signal
pad_size = ceil(length(y) / win_size_w) * win_size_w - length(y);
y_padded = [y; zeros(pad_size, 1)];

% Initialize output signals with the same length as the padded input signal
y_wiener = zeros(size(y_padded));

% Overlap-add method for Wiener filter
win_func_w = hamming(win_size_w);
for i = 1:overlap_w:length(y_padded)-win_size_w
    % Extract window
    y_win = y_padded(i:i+win_size_w-1);
    
    % Apply window function
    y_win = y_win .* win_func_w;

    % Compute power spectrum
    Y = abs(fft(y_win, n_fft)).^2;

    % Estimate signal and noise power spectra using Wiener filter
    alpha = 0.4321; % regularization parameter
    beta=0.23;
    [S, N] = my_wiener_filter(Y, n_fft, Fs, alpha, beta);

    % Apply Wiener filter to power spectrum
    Y_filt = S ./ (S + N) .* Y;

    % Reconstruct window with modified power spectrum
    y_win_filt = real(ifft(sqrt(Y_filt) .* exp(1j * angle(fft(y_win, n_fft))), n_fft));

    % Apply window function to the reconstructed window
    y_win_filt = y_win_filt(1:win_size_w) .* win_func_w;

    % Update output signal with filtered window
    y_wiener(i:i+win_size_w-1) = y_wiener(i:i+win_size_w-1) + y_win_filt(1:win_size_w);
    
    % Commented out since it is causing the error and its function isn't clear
    % Y_custom_filt = y_wiener(Y, S, N);

end

% Plot original and filtered signals
soundsc(y_wiener, Fs);
figure;
hold on;
plot(y, 'b');
plot(y_wiener, 'r');
legend('Original Signal', 'Filtered Signal');
hold off;
