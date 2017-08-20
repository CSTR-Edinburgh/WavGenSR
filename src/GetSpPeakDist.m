% TODO: weight distance according to Mel-scale.
% ojo que esta version es nueva, la salida es de estructura, no hice v2,
% para mantener el nombre
function [ dist, outStr ] = GetSpPeakDist(mTargSp,vInSpAv)

% Averaging:
vTargSpLogAv = mean(20*log10(mTargSp),2);

% Maximum:
[~, targMaxBin] = max(vTargSpLogAv);
[~, inMaxBin]   = max(vInSpAv);

% disance:
dist = abs(targMaxBin - inMaxBin);

outStr.inMaxBin   = inMaxBin;
outStr.targMaxBin = targMaxBin;

end