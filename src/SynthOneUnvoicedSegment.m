function vSynSig = SynthOneUnvoicedSegment(sTarg, cBaseUnvData, nFrmsToAdd, crFadeLenMs, shiftMs, workFs, nCffsUnvSmth, bSpAdLinPhase)

%% CONSTANTS
bHPFforUnv  = false;

%% INPUT
mTargSpEnv = sTarg.mSpEnv;

%% CHOSSING THE BEST TEMPLATE FROM THE DATABASE
selUnvNx  = GetClosestAudioFile3(mTargSpEnv, cBaseUnvData);

%% ADDING FRAMES AT THE BOUNDARIES (PROTECTION)

mTargSpEnv = [ repmat(mTargSpEnv(:,1), 1, nFrmsToAdd) , mTargSpEnv , repmat(mTargSpEnv(:,end), 1, nFrmsToAdd) ];
nFrmsExt   = size(mTargSpEnv,2);

%% SPECTRAL DIFFERENCE

mTargSpEnvLog = log(mTargSpEnv);
mBaseSpEnvLog = log(cBaseUnvData{selUnvNx}.mSpEnv(:,1:nFrmsExt));

% TODO: Not efficient
if nCffsUnvSmth > 0
    mBaseSpEnvLog = SPTKMelCepstralSmoothing(mBaseSpEnvLog, nCffsUnvSmth, 0.77);
end

mSpEnvLogDiff = mTargSpEnvLog - mBaseSpEnvLog;

%% SPECTRAL ENVELOPE ADAPTATION

% Spectral Envelope Adaptation:
nSmpls   = (nFrmsExt - 1) * shiftMs * workFs / 1000;

vBaseSig = cBaseUnvData{selUnvNx}.vSig(1:nSmpls); 
vSynSig  = SpecEnvAdaptation3(vBaseSig, mSpEnvLogDiff, shiftMs, workFs, 'SPTK', bSpAdLinPhase); 


%% DEBUG HPF FILTER

HPFd = HPF_ButterDesign(100, 200, workFs);
vSynSig = filter(HPFd, vSynSig);

%% DC REMOVAL
vSynSig = vSynSig - mean(vSynSig);

%% CROSSFADE AND REMOVAL OF ADDED FRAMES 

crFadeLen_smpls = crFadeLenMs * workFs / 1000;

% Removing frames:
nAddedSmpls    = (nFrmsToAdd - 0.5) * shiftMs * workFs / 1000; % 0.5 because the bounds between voiced and unvoiced are in the middle of frames.
nSmplsToRemove = nAddedSmpls - crFadeLen_smpls/2;
vSynSig        = vSynSig((nSmplsToRemove+1):(end-nSmplsToRemove));

% Applying Crossfade:
vFade = hann(2*crFadeLen_smpls + 1);
vFade = vFade(1:crFadeLen_smpls);
vSynSig(1:crFadeLen_smpls) = vSynSig(1:crFadeLen_smpls) .* vFade;
vSynSig((end-crFadeLen_smpls+1):end) = vSynSig((end-crFadeLen_smpls+1):end) .* vFade(end:-1:1);

%% HPF FOR UNVOICED SEGMENTS (OPTIONAL)

if bHPFforUnv == true
    HPFobj     = HPF_FIR_design(70, 100, workFs);
    hpfIR      = tf(HPFobj);
    IRlen      = length(hpfIR);
    vSynSigExt = [ zeros(2*IRlen,1)  ; vSynSig; zeros(IRlen,1)];
    vSynSigExt = filtfilt(hpfIR,1,vSynSigExt);
    vSynSig    = vSynSigExt(((2*IRlen)+1):(end-IRlen));
end

end