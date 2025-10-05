%%%%% Start script %%%%%%%%%

clear all, close all, clc %Clear memory

disp('start of myrecordvoice.');
%% Choose and define your window %%
pNframe = 1/10; %frame length in percentage of time signal.
poverl = .0;    %Percentage of overlap
sigtime = 2; %Signal time length to record in seconds
myWin = 2; %1 rectangular, 2 Tukey
    %Tukey: Tappered cosine window 
    %tk=1 poverl=0.5        50% works good
    %tk=0.5 poverl=0.25     25% works also good
    %tk=0.25 poverl=0.13    13% works less good but good enough.

    %% Record a voice object %%
recObj = audiorecorder;
sampleRate = recObj.SampleRate; % Get the sound card's voice sample rate
disp('Start speaking.')
recordblocking(recObj, sigtime);
disp('End of Recording.');
%play(recObj);

%% Get the speaking voice's parameters %%
y = getaudiodata(recObj).';
ly = length(y);
soundsc(y,sampleRate)
Nframe = fix(pNframe*ly);

%% funcion para comprobar que ftestoverlap hace lo que debe hacer
%yTest = fTestSignal(y,sampleRate);
%Call function to test the signal
%sout = ftestoverlap(yTest,poverl,Nframe,myWin,sampleRate);

%% get windowed signal %%
sout = ftestoverlap(y,poverl,Nframe,myWin,sampleRate); 
soundsc(sout,sampleRate) %% Play recorded voice
disp('End of myrecordvoice');
%End Of Script


