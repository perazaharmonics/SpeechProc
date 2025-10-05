%ftestoverlap
function [sout] = ftestoverlap(y,poverl,Nframe,myWin,sampleRate)
y = y.'; %Hay que transponer para que el vector sea fila
Nnoise = length(y);

%Create window to be applyed to the noise, set the window length to the frame length
% wFrame= triang(Nframe);
%Options: rectwin triang barthannwin tukeywin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if myWin==1
    wFrame = rectwin(Nframe);
elseif  myWin==2
    %Tappered cosine window 
    %tk=1 poverl=0.5        50% works good
    %tk=0.5 poverl=0.25     25% works also good
    %tk=0.25 poverl=0.13    13% works less good but good enough.
    tk = 1;
    %poverl = tk/2;
    %poverl = 0.5; %Percentage of overlap
    wFrame = tukeywin(Nframe,tk);
end

noverlap = fix(Nframe*poverl);
koverlap = fix((Nnoise-noverlap)/(Nframe-noverlap));
disp(['length of the signal Nn: ',num2str(Nnoise),' or ',num2str(Nnoise/sampleRate),'sec.']);
disp(['length of the frame  Nf: ',num2str(Nframe)]);
%disp(['length of overlap    No: ',num2str(noverlap)]);
disp(['Overlapped samples       ',num2str(noverlap),' or ',num2str(100*poverl),'%']);
disp(['number of frames     k : ',num2str(koverlap)]);
if(koverlap>Nnoise)
    display('Error, overlap of less than one sample');
    return
end

sout = 0;
for i=1:koverlap %be careful here, these could be overlapped frames
    nstart = (i-1)*(Nframe-noverlap)+1;    %start point of the window
    nend = nstart+Nframe-1;                      %end point of the window
    
    %Segment the signal multiplied by the window
    segment = (y(nstart:nend).* wFrame).';
    seg(i,:) = segment;
    %reconstruct the signal from the overlapped windowed segments
    %Shift it to its absolute position in the overall signal
    segshifted(i,:) = [zeros(1,nstart-1),segment,zeros(1,(Nframe-noverlap)*(koverlap-i))];
    
    %Accumulate to the already windowed signal
    sout = sout + segshifted(i,:);
end

SEG = fftSegments(seg,sampleRate);

str311 = 'Drawing window';
figure
my311 = subplot(3,1,1);

stem(wFrame,'.','r.'),grid on
hold off

str312 = 'Input signal (green)';
my312 = subplot(3,1,2);
stem(y,'g.'),grid on
hold on

str313 = 'overlapped segments (red)';
my313 = subplot(3,1,3);
stem(y,'g'),grid on, hold on
stem(segshifted','r.'),grid on

str314 = 'Reconst. signal (blue)';
%disp(str314);
hold on
stem(sout,'b*'),grid on
hold off
title(my311,str311);
title(my312,str312);
title(my313,[str313,' ',str314]);


function [SEG] = fftSegments(seg,sampleRate)
[nWin,nPoints]= size(seg);
figure, mesh([0:nPoints-1]/sampleRate,1:nWin,seg)
xlabel('time, s')
ylabel('segment number')
%FFT done to each column, we need to transpose
SEG = fft(seg.');
%Half of it
SEG = SEG(1:end/2,:);
Fres = sampleRate/nPoints;
figure, mesh(1:nWin,[0:nPoints/2-1]*Fres,20*log10(abs(SEG)))
view(60,30)
%keyboard


