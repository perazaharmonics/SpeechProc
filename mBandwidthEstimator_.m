%% Formant Frequencies BW Estimator %%

clear all
close all
clc


%F = [700,1220, 2600]; %Formant Frequencies (Hz)
%BW = [130, 70, 160]; %Formant bandwidths (Hz)

vowel = 'i';
if(vowel == 'A')
    F = [666, 1279, 2229, 3270]; %Formant Frequencies (Hz)
elseif(vowel == 'E')
    F=[557, 1630, 2570, 3186]; % Formant frequencies (Hz)

elseif(vowel == 'i')
    F=[258, 2210, 2875, 3126]; % Formant Frequencies
end
BW = 0.7*[50, 50, 20, 15]; %Formant Bandwidths (Hz)
fs = 8192; %Sampling rate (Hz)