% No protection for aliasing. It has to be addressed previously by using for example a higher baseFs.
% v3: meth: 'spline' or 'sinc'
% TODO: Sinc-based inyterpolation not implemented yet.
function [basePitchShifted, baseStretcPosMs] = DoPitchShift3(baseSig, baseF0SmplBased, targF0SmplBased, baseFs, targFs, interpType)
   
    % Get stretch positions:
    baseStretcPosMs = GetStrecthPositions3(baseF0SmplBased, targF0SmplBased, baseFs, targFs, interpType);
    
    nBaseSmpls = length(baseStretcPosMs);
    baseTsMs   = 1000 / baseFs; 
    vOutPosMs  = baseTsMs * (0:(length(targF0SmplBased) * baseFs / targFs -1));    
    
    basePitchShifted = interp1(baseStretcPosMs, baseSig(1:nBaseSmpls), vOutPosMs ,interpType)';    
    
end