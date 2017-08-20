% Warps the spectra matching the underlying F0 (vInF0) with the target F0 (vOutF0).
% vInF0: Sometimes, for completeness, the algorithm adds a frame at the end, so, it updates de vInF0
function [ mOutSpLog, vInPosFrms ] = SpecWarpVoiced(vInF0, mInSpLog, vOutF0, interpType)
disp('Warping spectrum...');

vInF0  = vInF0(:);
vOutF0 = vOutF0(:);

vInPosFrms = GetStrecthPositions3(vInF0, vOutF0, 1, 1, interpType)';
vInPosFrms = 1 + vInPosFrms / 1000;

% Stretch Spectra in frequency domain:-------------------------------------
nFrms = length(vInPosFrms);
for t=1:nFrms 
    if (t == 1)         
        currFact = 1/( vInPosFrms(t+1) - vInPosFrms(t));
    
    elseif (t == nFrms)         
        currFact = 1/( vInPosFrms(t) - vInPosFrms(t-1));
        
    else % case all other frames
        currFact = 2/( vInPosFrms(t+1) - vInPosFrms(t-1));        
    end            
    
    mInSpLog(:,t) = StretchSpec(mInSpLog(:,t), currFact, interpType);
end

% Adding a last frame for completness of the output:
nFrmsNew = ceil(vInPosFrms(end));

% Final interpolation in Time domain:
mOutSpLog = InterpMatrix2(vInPosFrms, mInSpLog, 1:nFrmsNew, interpType, mInSpLog(:,end)); 

end

