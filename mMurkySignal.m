sampleRate=recObj.SampleRate;

% sampleRate =
% 
%         8000

sigtime=3; %Signal time length to record in seconds
recordblocking(recObj,sigtime); %Create recording object
y=getaudiodata(recObj).';
soundsc(y,sampleRate);
figure, plot(y)
noise=1/10*randn(1,length(y));
figure,plot(noise);
noise=1/30*randn(1,length(y));
figure,plot(noise);
soundsc(noise,sampleRate);
yout=y+noise;
soundsc(yout,sampleRate);
figure,subplot(3,1,1),plot(y);
subplot(3,1,2),plot(noise);
subplot(3,1,3),plot(yout);