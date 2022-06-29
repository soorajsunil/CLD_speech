clc; clear; close all;

addpath('../speech data/')

% Sampling 
filepath       = 'PP001_Dual_0back.m4a';
Fs             = 48000; % sample rate in Hz
Td             = 2.5;   % duration of signal in seconds 
[signal, time] = sampling(filepath, Fs, Td); 

% Framing 
% Framing.frameLength           = 10/1000; % ms 
% Framing.overlapWindowSize     = 0; 
% Framing.frameHopping          = Framing.frameLength - Framing.overlapWindowSize; 
% Framing.frameLengthinSamples  = Samples.sampleRate*Framing.frameLength; 
% Framing.frameHoppinginSamples = Samples.sampleRate*Framing.frameHopping; 
% Framing.nFrames               = (Samples.nSamples-Framing.overlapWindowSize)/(Framing.frameLength-Framing.overlapWindowSize);
% 
% % Padding 
% Framing.restSamples = mod((Samples.nSamples-Framing.overlapWindowSize), (Framing.frameLength-Framing.overlapWindowSize));



function [signal, time] = sampling(filepath, samplingRate, timeDuration)

Nsamples    = timeDuration*samplingRate;       % number of samples 
sampleRange = [1, Nsamples];                   % [start, end] 
time        = (0:Nsamples-1)/samplingRate;     % time in seconds 
signal      = audioread(filepath, sampleRange);

end 





% 
function [paddedSignal, Nf] = framing(signal, Fs, windowLength, windowStep) 

    % Args: 
    %   signal       - discrete signal sampled at Fs frequency 
    %   Fs           - sampling frequency in Hertz 
    %   windowLength - window length in seconds 
    %   windowHop    - step between successive windows in seconds 

% compute frame length and frame step (from seconds to samples)
frameLength  = windowLength*Fs; 
frameStep    = windowStep*Fs; 
frameOverlap = frameLength-frameStep; 

% compute number of frames 
Ns = length(signal); % get signal length
Nf = floor((Ns-frameOverlap)/(frameLength-frameOverlap)); % number of frames 

% padding if required 
restSamples = mod((Ns-frameOverlap),(frameLength-frameOverlap)); 

if restSamples ~= 0 
    padLength    = frameStep - restSamples; 
    z            = zeros(padLength); 
    paddedSignal = [signal, z]; 
    Nf           = Nf + 1; 

else 
    paddedSignal = signal; 
end 





end 