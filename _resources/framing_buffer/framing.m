% +------------------------------------------------------+
% |             Signal framing (segmentation)            |
% |              with MATLAB Implementation              | 
% |                                                      |
% | Author: Ph.D. Eng. Hristo Zhivomirov        04/29/19 | 
% +------------------------------------------------------+
% 
% function: [FRMS, t] = framing(x, frlen, hop, fs)
%
% Input:
% x - whole signal in the time domain
% frlength - signal frame length
% hop - hop size
% fs - sampling frequency, Hz
%
% Output:
% FRMS - frame-matrix (time across columns, 
%                      indexes across rows)

function [FRMS, t] = framing(x, frlen, hop, fs)

% signal segmentation
[FRMS, ~] = buffer(x, frlen, frlen-hop, 'nodelay');

% calculation of the time vector
t = (frlen/2:hop:frlen/2+(size(FRMS, 2)-1)*hop)/fs;

end