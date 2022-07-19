% The present example is a Matlab code that performs voice activity
% detection and consonant marking of a human speach sample using signal
% framing and short-time energy and zero-crossing rate determination.
% The code is inspired by the theory described in:
% R. Bachu, S. Kopparthi, B. Adapa, B. Barkana. Voiced/Unvoiced Decision
% for Speech Signals Based on Zero-Crossing Rate and Energy. Advanced
% Techniques in Computing Sciences and Software Engineering, pp. 279-282.
% Dordrecht, Springer, 2010.

clear, clc, close all

%% get a section of the sound file
% fs = 48000;
% range = [1 10*fs];

[x, fs] = audioread('DR2_MJAR0_SI2247.WAV');    % load an audio file
x       = x(:, 1);                                    % get the first channel
x        = x/max(abs(x));                              % normalize the signal
N = length(x);                                  % signal length
t = (0:N-1)/fs;                                 % time vector

%% signal framing
frlen = round(20e-3*fs);                        % frame length
hop = round(frlen/2);                           % hop size
[FRM, tfrm] = framing(x, frlen, hop, fs);       % signal framing

%% determine the Short-time energy
STE = sum(FRM.^2);

%% determine the Short-time zero-crossing rate
STZCR = sum(abs(diff(FRM > 0)))/size(FRM, 1);

%% plot the results
% plot the signal waveform
figure(1)
subplot(3, 1, 1)
plot(t, x)
grid on
xlim([0 max(t)])
ylim([-1.1*max(abs(x)) 1.1*max(abs(x))])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Time, s')
ylabel('Amplitude')
title('The signal in the time domain')

% plot the STE
subplot(3, 1, 2)
plot(tfrm, STE)
grid on
xlim([0 max(tfrm)])
ylim([0 1.1*max(STE)])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Time, s')
ylabel('Energy')
title('Short-time Energy')

% plot the STZCR
subplot(3, 1, 3)
plot(tfrm, STZCR)
grid on
xlim([0 max(tfrm)])
ylim([0 1.1*max(STZCR)])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Time, s')
ylabel('ZCR')
title('Short-time ZCR')

%% mark the signal
% Note: (i) the activity flag is rised when there is high energy frame
% in the signal stream; (ii) the consonant flag is rised when there are
% high ZCR activity and high energy in the signal stream.
AF = STE > 0.1*median(STE);
CF = AF & STZCR>2*median(STZCR);

subplot(3, 1, 1)
hold on
plot(tfrm, AF, 'r', 'LineWidth', 1.5)
plot(tfrm, CF, 'g', 'LineWidth', 1.5)
legend('signal', 'activity flag', 'consonant flag', ...
       'Location', 'southeast')