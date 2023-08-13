function [S, N] = my_wiener_filter(Y, n_fft, Fs, alpha, beta)
% Computes the signal and noise power spectra using a custom Wiener filter
%
% Y: input power spectrum
% n_fft: number of FFT points
% Fs: sampling frequency
% alpha: regularization parameter
% beta: noise reduction parameter
%
% S: estimated signal power spectrum
% N: estimated noise power spectrum

% Compute the noise power spectrum
N = beta * mean(Y);

% Compute the signal power spectrum
S = max(Y - N, 0);

% Add regularization
S_reg = S + alpha * N;

% Compute Wiener filter coefficients
W = S_reg ./ Y;

% Apply Wiener filter to input power spectrum
Y_filt = W .* Y;

% Compute signal and noise power spectra
S = max(Y_filt - N, 0);
N = max(Y_filt - S, 0);
end
