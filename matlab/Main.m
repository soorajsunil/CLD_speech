clc; clear; close all;

% Goal:

% >> convert signal to indvidual words
% >> check existing codes!! change the dictionary to {0,1,2...9}
% 
% >> cognitive features
% 1) extract response time {start, end}
% 2) accuracy to check right answer

addpath('../data/')

% Sampling ................................................................
fileName = 'PP001_Dual_0back.m4a';
Fs       = 48000; % sample rate in Hertz
T        = 1;     % duration of signal in seconds

[audioSamples, time] = sampling(fileName, Fs, T);
% plot_audio_samples(time, audioSamples)

% Framing .................................................................
frameDuration = 0.1;   % in seconds
hopDuration   = 0.020; % in secconds
[framedSamples, framedTime] = framing(audioSamples, time, Fs, frameDuration, hopDuration);

[nFrames, nFrameSamples] = size(framedSamples);  


% %% determine the Short-time energy
% STE = sum(framedSamples.^2);
%
% %% determine the Short-time zero-crossing rate
% STZCR = sum(abs(diff(framedSamples > 0)))/size(framedSamples, 1);


% plot(framedTime, STE)
% grid on
% % xlim([0 max(tfrm)])
% % ylim([0 1.1*max(STE)])
% set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
% xlabel('Time, s')
% ylabel('Energy')
% title('Short-time Energy')

function [audioSamples, time] = sampling(fileName, Fs, sampleDuration)
% Args:
    % fileName       - audio file name
    % Fs             - sample rate in Hertz
    % sampleDuration - sample time duration in seconds

% ** Note : In the given audio experiment data there are two channels,
% but only one of them is being used here **

Nsamples     = sampleDuration*Fs;                        % number of samples in Hertz
sampleRange  = [1, Nsamples];                            % sample range in Hertz
audioSamples = audioread(fileName, sampleRange);         % read audio file
audioSamples = audioSamples(:,1)/max(audioSamples(:,1)); % normalized sample vector
time         = ((0:Nsamples-1)/Fs)';                     % time vector in seconds

end

function [framedSamples, framedTime] = framing(audioSamples, time, Fs, frameDuration, hopDuration)
% Args:
    % signal        - discrete signal sampled at Fs frequency
    % Fs            - sampling frequency in Hertz
    % frameDuration - window duration in seconds
    % hopDuration   - step size between successive windows in seconds

% ** Note: 
% case (1):: no overlapping frames -> frameDuration = hopDuration 
% case (2):: overlapping frames    -> frameDuration > hopDuration 
% case (3):: skip (frameDuration-hopDuration) samples of duration  -> frameDuration < hopDuration 

% compute number of frames
Nsamples     = numel(audioSamples);     % number of samples
frameLength  = frameDuration*Fs;        % in Hertz
frameHop     = hopDuration*Fs;          % in Hertz
frameOverlap = frameLength-frameHop;    % in Hertz
Nframes      = floor((Nsamples-frameOverlap)/(frameLength-frameOverlap)); % number of frames

% zero padding
extraSamples = mod((Nsamples-frameOverlap),(frameLength-frameOverlap));
if extraSamples ~= 0
    padLength     = frameHop - extraSamples;
    z             = zeros(padLength, 1);
    paddedSamples = [audioSamples; z];
    paddedTime    = [time; z];
    Nframes       = Nframes + 1;
else
    paddedSamples = audioSamples;
    paddedTime    = time;
end

% generate frame indices
idx      = zeros(Nframes,frameLength);
idx(1,:) = 1:frameLength;
for k = 2:Nframes
    idx(k,:) = frameHop + idx(k-1,:);
end

framedSamples  = paddedSamples(idx); % frame of samples
framedTime     = paddedTime(idx);    % respective time of frames

% PENDING! :: Check the framedTime .... 

end

function plot_audio_samples(time, audioSamples)
figure(Name='Samples')
plot(time, audioSamples, 'r-');
title('Normalized samples'); 
xlabel('Seconds') ; ylabel('Amplitude')
axis('tight')
end 






