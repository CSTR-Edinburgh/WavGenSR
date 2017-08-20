% Interpolates F0 contour keeping transitions between voiced and unvoiced one sample wide.
function F0SmplBased = InterpF0_4(vPosCentrFrmsMs,vF0,vSmplsInMs)

vF0 = vF0(:);

% First Raw interpolation:----------------------------------------------
F0SmplBased = interp1(vPosCentrFrmsMs, vF0, vSmplsInMs,'linear'); 
% Protection last segment (NaNs):
vbNans = isnan(F0SmplBased);
lastValidValue = F0SmplBased(find(vbNans, 1,'first')-1);
F0SmplBased(vbNans) = lastValidValue;


% Case if only voiced or unvoiced:--------------------------------------
nFrms = length(vPosCentrFrmsMs);
vF0Bool = vF0;
vF0Bool(vF0Bool > 0) = 1;
sumF0Bool = sum(vF0Bool);
if sumF0Bool == nFrms || sumF0Bool == 0
   return;    
end

% Case there are voiced and unvoiced segments. (Fixing transitions)------

% Looking for position of transitions:
vF0SqDiff      = abs(diff(vF0Bool));
mTransNxs      = find(vF0SqDiff); % start and end indexes of transitions
mTransNxs      = [ mTransNxs , mTransNxs + 1];
mPosTransMs    = vPosCentrFrmsMs(mTransNxs);
mF0TransValues = vF0(mTransNxs);
nTrans         = size(mF0TransValues,1);

for nxTr = 1:nTrans
    
    % Looking for the indexes of current transition
    vCurrReplaceNxs = find((vSmplsInMs >= mPosTransMs(nxTr,1)) & (vSmplsInMs <= mPosTransMs(nxTr,2)));
    
    % Length of current transition:
    nReplSmpls     = length(vCurrReplaceNxs);
    nReplSmplsHalf = round(nReplSmpls / 2);
    
    % Start and End F0 values:
    currStrtVal = mF0TransValues(nxTr,1);
    currEndVal  = mF0TransValues(nxTr,2);
    
    % Replacing smooth transition of sharp transition:
    vCurrReplaceValues = [ currStrtVal * ones(nReplSmplsHalf,1)  ; currEndVal * ones(nReplSmpls - nReplSmplsHalf,1) ];    
    F0SmplBased(vCurrReplaceNxs) = vCurrReplaceValues;          
end


end