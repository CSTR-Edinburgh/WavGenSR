% Filters the signal to match the target spectral envelope.
% Support for linear phase filter. Only for SPTK case. TODO: Implement for other filters
function synSig = SpecEnvAdaptation3(inSig, mDiffSpLog, frmShiftMs, fs, dynFiltMeth, bLinPhase)
% Constants (they could be modified in a future implementation):
bDiffSpSmth = false;

% Smoothing of Diff Spec Log:--------------------------------------
if bDiffSpSmth == true
    mDiffSpLog = SmoothSpec(mDiffSpLog);
end

% Filtering:
targLen = ( size(mDiffSpLog,2) * frmShiftMs) * fs / 1000;
switch dynFiltMeth
    case 'SBS'
        disp('Sample-by-sample filter coeffs update.');
        vEpochs    = ones(targLen,1);
        filterType = 'zero-phase-fft';
        synSig     = SpecInterpAndFilterDynamicEpochByEpoch( mDiffSpLog, frmShiftMs, fs, inSig, filterType, -1, vEpochs);
        
    case 'SIN'
        synSig  = SinusoidalFilter2( mDiffSpLog, frmShiftMs, fs, inSig);
        
    case 'SPTK'
        nCoeffs = 180;
        synSig  = SptkMcepFilter2(inSig, mDiffSpLog, frmShiftMs, fs, nCoeffs, bLinPhase); 
        
    case 'ALLPOLE'
        nCoeffs = 40;
        synSig  = SptkAllPoleFilter(inSig, mDiffSpLog, frmShiftMs, fs, nCoeffs); 
        
end

end