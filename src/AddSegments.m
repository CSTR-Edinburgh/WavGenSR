% Concatenates the generated signal segments.
% All the segments should contain the crossfade range in both sides, since
% this funcion wil cut the beggining and end of the signal
% taking this into account.
function vSynSig = AddSegments(cSynSegs, crFadeLenMs, fs)

lenExt = sum(cellfun(@length, cSynSegs));

crFadeLen = crFadeLenMs * fs / 1000;

vSynSig = zeros(lenExt, 1);
nSegs = length(cSynSegs);
currStrt = 1; % init
for s=1:nSegs
    currLen  = length(cSynSegs{s});    
    vSynSig(currStrt:currStrt+currLen-1) = vSynSig(currStrt:currStrt+currLen-1) + cSynSegs{s};    
    currStrt = currStrt + currLen - 1 - crFadeLen;    
end

% Cutting remaining/crossfade at the beginning and end:
vSynSig = vSynSig((crFadeLen+1):(currStrt-1));

end