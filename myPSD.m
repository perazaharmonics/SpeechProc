function [S, N] = myPSD(Y_power, n_fft, Fs)
    % Define the number of frequency bands for noise estimation
    n_bands = 10;

    % Estimate the noise power spectrum in each band
    N = zeros(size(Y_power));
    band_size = round(n_fft / n_bands);
    for i = 1:n_bands
        band_range = (i-1)*band_size + 1 : min(i*band_size, n_fft);
        N(band_range) = mean(Y_power(band_range));
    end

    % Smooth the noise power spectrum
    N = smooth(N, 0.1, 'moving');  % adjust smoothing parameters as needed

    % Avoid negative values
    N = N + eps;

    % Estimate the signal power spectrum as the input power spectrum
    S = Y_power;

    % Ensure that the signal power spectrum is always positive
    S = max(S, N + eps);
end
