function [yTest] = fTestSignal(y,sampleRate);
%Create test signal
[nWin,nPoints]= size(y);
f1=666;
f2=1279;
f3=2229;
f4=3270;
t=[0:nPoints-1]/sampleRate;
yTest = sin(2*pi*f1*t)+sin(2*pi*f2*t)+sin(2*pi*f3*t)+sin(2*pi*f4*t);
%keyboard