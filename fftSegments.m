function [SEG] = fftSegments(seg, sampleRate)
[nWin,nPoints]=size(seg); %Cuantos puntos y windows hay en el segmento
figure,mesh([0:nPoints-1]/sampleRate,1:nWin,seg) %Convirtiendo el numero de puntos a tiempo y y luego el numero de ventanas en segmentos dentro del argumento de la funcion mesh
xlabel('time, s') % x es tiempo
ylabel('segment number') % nuemero de segmentos
% FFT done to each column, we need to transpose
SEG = fft(seg.'); % Lo convertimos en columna porque el FFT opera en columnos, entonces me hace un FFT de todos los segmentos sobre todas las ventanas 
%Half of it
SEG=SEG(1:end/2,:); % Solamente agarramos la mitad, pues solo necesitamos las positivas pues lo restante es un 'aliasing' de las secuencias negativas
Fres=sampleRate/nPoints; %Frecuencia de resolucion
figure, mesh(1:nWin, [1:nPoints/2-1]*Fres,20*log10(abs(SEG))) % (decibels) ploteamos el valor abs de seg, la mitad del numero de puntos por Fres lo plotea en Freq
view(60,30)
%keyboard