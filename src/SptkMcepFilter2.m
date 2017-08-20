% v2: Phase selector (linear phase or "normal")
% For linear phase filtering, the filter is applied twice (once in reverse).
% TODO: LINEAR PHASE NOT WORKING PROPERLY YET!!
function vSynSig = SptkMcepFilter2(vInSig, mDiffSpLog, frmShiftMs, fs, nCoeffs, bLinPhase)

if bLinPhase == true %% Linear phase case:
    
    mDiffSpLogHalf = mDiffSpLog ./ 2;   

    vSynSig1  = SptkMcepFilter(vInSig, mDiffSpLogHalf, frmShiftMs, fs, nCoeffs); 
    vSynSig   = SptkMcepFilter(flipud(vSynSig1), fliplr(mDiffSpLogHalf), frmShiftMs, fs, nCoeffs);    
    vSynSig   = flipud(vSynSig); 
    
else %% Normal Case:
    vSynSig = SptkMcepFilter(vInSig, mDiffSpLog, frmShiftMs, fs, nCoeffs);    
end


end