%Create a filter with the following formants and bandwidth
clear all
close all
clc
%F =  [700, 1220, 2600]; % Formant frequencies (Hz)
%BW = [130,  70,  160];  % Formant bandwidths (Hz)
F =  [666, 1279, 2229 3270]; % Formant frequencies (Hz)
BW = [70,  70,  70,   70];  % Formant bandwidths (Hz)
fs = 8192;              % Sampling rate (Hz)

nsecs = length(F);
R = exp(-pi*BW/fs);     % Pole radii
theta = 2*pi*F/fs;      % Pole angles
poles = R .* exp(j*theta); % Complex poles 
B = 1;  A = real(poly([poles,conj(poles)]));
freqz(B,A); % View frequency response:
A