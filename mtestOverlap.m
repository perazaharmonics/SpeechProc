%mtestoverlap
clear all, close all, clc

%y = [1:3*160]; %ramp signal with 3*160 = 480 samples %testing with another
%signal already created myMurkySignal.m

Nframe = 160; % Each frame has 160 samples
%noverlap = 0;
Nnoise = length(y);

%Create window to be applied to the noise, set the window length to the
%frame length
%wFrame = triang(Nframe);
%Options: rectwin triang, barthannwin tukeywin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Tapered cosine window
%tk=1 poverl=0.5       50% works good
%tk=0.5 poverl=0.25    25% works also well
%tk=0.25 poverl=0.13   13% works less well but it's good enough.
tk = 1;
poverlap = 0.5; %Percentage of overlap poverlap = tk/2
wFrame = tukeywin(Nframe, tk);
%wFrame = rectwin(Nframe);

%overlapped samples
noverlap = fix(Nframe*poverlap);
disp(['Overlapped samples', num2str(noverlap), ' or ', num2str(100*poverlap), '%']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

koverlap = fix((Nnoise-noverlap)/(Nframe-noverlap)); 
disp(['length of the signal Nn:', num2str(Nnoise)]);
disp(['length of the frame Nf:', num2str(Nframe)]);
disp(['length of the overlap No:', num2str(noverlap)]);
disp(['length of the frames k:', num2str(koverlap)]);

if (koverlap>Nnoise)
    display('Error, overlap of less than one sample');
    return
end

sout=0;
for i=1:koverlap %be careful here, these could be overlapped frames
    nstart = (i-1)*(Nframe-noverlap)+1; %starting point of the window
    nend=nstart+Nframe-1; %end point of the window

    % Segment the signal multiplied by the window
    segment = y(nstart:nend).*wFrame';
    seg(i,:) = segment;

    %reconstruct the signal from the overlapped windowed segments
    %shift it to its absolute position in the overall signal
    segshifted(i,:) = [zeros(1,nstart-1),segment,zeros(1, (Nframe-noverlap)*(koverlap-i))];

    %Accumulate to the already windowed signal
    sout=sout+segshifted(i,:);
end

subplot(2,1,1)
plot(0*y, '.')
hold on
stem(wFrame, '.', 'r.'), grid on
hold off
subplot(2,1,2)
plot(y,'g.')
hold on
stem(segshifted','r.'), grid on
hold on
plot(sout, 'b.')
hold off

% Conclusions: to recreate a signal we need an overlap, we are using a ramp
% given we know the expected outcome, later we try this algorithm with a
% real signal. Using a poverlap too low would have the signal y follow the
% envelope of the windows