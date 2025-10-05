%% Create a filter with the following formants and bandwidth
%This section is really all we needed to represent the three formants, the
%second section shows how we can recreate this filter using three 2-pole
%single filters in parallel
clear all %Clean all variables
close all
clc
F = [432, 1210, 2440, 3100, 4225]; %Formant frequencies (Hz) vector
BW = [130, 70, 160, 160, 70]; %Formant bandwidths (Hz)
fs=44100; %Sampling rate (Hz)
j=sqrt(-1);

nsecs=length(F); % number of sections
R = exp(-pi*BW/fs); % Pole radii
theta = 2*pi*F/fs; % Pole angles
poles = R.*exp(j*theta); % Complex poles
B = 1; %Filter numerator 
A=real(poly([poles,conj(poles)])); % Filter Denominator.. make sure poles are conj so coeffs of A are real
hold on;
figure;
freqz(B,A); %View frequency response:

%% Convert to parallel complex one-poles (PFE):
%Divides the filter of the three formant filter into three single formant.
%This 6 pole filter (with 3 positive, 3 negative, we show only the positive
%side) can be recreated as a parallel configuration of 3 second order
%section filters (three 2-pole single filter)
%filters:
[r,p,f] = residuez(B,A); 
As = zeros(nsecs,3); %denominator of these filters
Bs= zeros(nsecs,3); %numerators of these filters

% complex-conjugate pairs are adjacent in r and p:

for i=1:2:2*nsecs
    k = 1 + (i-1)/2;
    Bs(k,:) = [r(i)+r(i+1), -(r(i)*p(i+1)+r(i+1)*p(i)), 0];
    As(k,:) = [1, -(p(i)+p(i+1)), p(i)*p(i+1)];
end

sos = [Bs,As]; %standard second-order-section form
iperr = norm(imag(sos))/norm(sos); %make sure sos is ~real
disp(sprintf('||imag(sos)||/||sos|| = %g',iperr)); % 1.6e-16
sos=real(sos); %and make it exactly real

%% Reconstruct original numerator and denominator as a check:
[Bh,Ah] = sos2tf(sos); %parallel sos to transfer function
%psos2tf appears in the matlab-utilities appendix
disp(sprintf('||A-Ah|| = %g', norm(A-Ah))); %5.77423e-15

%Bh has a trailing epsilons, so we'll zero-pad B:
disp(sprintf('||B-Bh|| = %g',norm([B,zeros(1,length(Bh)-length(B))] -Bh))); %1.25116e-15

%% Plot overlay and sum of all three resonator amplitude responses:
nfft=512;
H = zeros(nsecs+1,nfft);

% Usando Bs y As calcula el freq y guardalo en una matriz [Hiw,w] creando los filtros
for i=1:nsecs
    [Hiw,w] = freqz(Bs(i,:), As(i, :)); 
    H(1+i,:)=Hiw(:).'; 
end

H(1,:)=sum(H(2:nsecs+1,:)); 
ttl= 'Amplitude Response';
xlab='Frequency (Hz)';
ylab='Magnitude (dB)';
sym = '';
lgnd={'sum','sec 1', 'sec 2','sec 3'};
np=nfft/2; % only plot for positive frequencies
wp=w(1:np); 
Hp=H(:,1:np);
HpdB=20*log10(abs(Hp));
%figure(1); clf;
plot(wp,HpdB); %sym, ttl, xlab,ylab,1,lgnd);
disp('PAUSING'); pause(1);
%saveplot('../eps/1pcexovl.eps');

%% Now synthesize the vowel [a]:
nsamps = 256*16;
f0=150; % Pitch in Hz
T0=1/f0; %Period of impulse signal
w0T = 2*pi*f0/fs; %radians per sample

nharm=floor((fs/2)/f0); %number of harmonics
sig=zeros(1,nsamps);
n=0:(nsamps-1);

%% Synthesize bandlimited impulse train

for i=1:nharm
    sig = sig + cos(i*w0T*n);
end

sig=sig/max(sig); %Vocal Chords Impulse Signal
speech = filter(1,A,sig); %Signal after being filtered by the vocal tract
soundsc([sig,speech]); %hear impulse buzz, then vocal tract forming 'ah'
