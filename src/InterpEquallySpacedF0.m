% Wrapper to use InterpF0 easily
function vF0_smpl = InterpEquallySpacedF0(vF0, shiftMs, fs)

TsMs = 1000 / fs;
vPosCntrFrmsMs = (0:(length(vF0)-1)) * shiftMs;
vSmplsInMs     = 0:TsMs:vPosCntrFrmsMs(end);  

vF0_smpl = InterpF0_4(vPosCntrFrmsMs,vF0,vSmplsInMs);


end