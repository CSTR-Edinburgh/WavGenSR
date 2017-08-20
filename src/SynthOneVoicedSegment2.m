function vSynSig = SynthOneVoicedSegment2(sTarg, sVoiBase, nFrmsToAdd, crFadeLenMs, shiftMs, workFs, nCffsVoiSmth, bSpAdLinPhase, interpType)

%% INPUT
vTargF0    = sTarg.vF0(:);
mTargSpEnv = sTarg.mSpEnv;
mBaseSpEnv = sVoiBase.mSpEnv;  
vBaseSig   = sVoiBase.vSig;
baseFs     = sVoiBase.fs;
vBaseF0    = sVoiBase.vF0;

%% ADDING FRAMES AT THE BOUNDARIES (protection)
vTargF0    = [ vTargF0(1) + zeros(nFrmsToAdd,1) ; vTargF0 ; vTargF0(end) + zeros(nFrmsToAdd,1) ];
mTargSpEnv = [ repmat(mTargSpEnv(:,1), 1, nFrmsToAdd) , mTargSpEnv , repmat(mTargSpEnv(:,end), 1, nFrmsToAdd) ];

%% TARGET SPECTRAL ENVELOPE WARPING

% Warping:----------------------------------------------------------------------------------------------
mTargSpEnvLogWarp = log(mTargSpEnv);
[mTargSpEnvLogWarp, vInPosFrms] = SpecWarpVoiced(vTargF0, mTargSpEnvLogWarp, vBaseF0, interpType);

nFrmsWarp = size(mTargSpEnvLogWarp,2);
nSmpls    = GetLenFromNFrames(nFrmsWarp, shiftMs, baseFs);

%% SPECTRAL ENHANCEMENT

% Norm by total energy:
mTargSpEnvWarpBefore = exp(mTargSpEnvLogWarp);
vEnerBeforePerFrame  = sqrt(sum([ mTargSpEnvWarpBefore ; mTargSpEnvWarpBefore(2:(end-1),:) ].^2));
enerAvBefore = min(vEnerBeforePerFrame);

mTargSpEnvLogWarp   = mTargSpEnvLogWarp * 1.1;

mTargSpEnvWarpAfter = exp(mTargSpEnvLogWarp);
vEnerAfterPerFrame  = sqrt(sum([ mTargSpEnvWarpAfter ; mTargSpEnvWarpAfter(2:(end-1),:) ].^2));
enerAvAfter = min(vEnerAfterPerFrame);

enerFact = enerAvBefore / enerAvAfter;

%% SPECTRAL DIFFERENCE

% Extend spectral bins to the doubled sample rate:------------------------------------------------------
nFFTHalfTarg = size(mTargSpEnv,1);
nFFTHalfBase = size(mBaseSpEnv,1);
nMoreBins    = nFFTHalfBase - nFFTHalfTarg;
mTargSpEnvLogWarp = [ mTargSpEnvLogWarp ; repmat(mTargSpEnvLogWarp(end,:), nMoreBins , 1) ];

mBaseSpEnvLog = log(mBaseSpEnv(:,1:nFrmsWarp));

% TODO: Improve efficiency
if nCffsVoiSmth > 0
    mBaseSpEnvLog = SPTKMelCepstralSmoothing(mBaseSpEnvLog, nCffsVoiSmth, 0.77);
end
mSpEnvLogDiff = mTargSpEnvLogWarp - mBaseSpEnvLog;

%% SPECTRAL ENVELOPE ADAPTATION
vSynSigWarp = SpecEnvAdaptation3(vBaseSig(1:nSmpls), mSpEnvLogDiff, shiftMs, baseFs, 'SPTK', bSpAdLinPhase);

%% PITCH SHIFTING

% Fo in frames to samples:
vBaseF0_smpls = InterpEquallySpacedF0(vBaseF0(1:nFrmsWarp), shiftMs, baseFs);
vTargF0_smpls = InterpEquallySpacedF0(             vTargF0, shiftMs, baseFs);

% Pitch Shifting:---------------------------------------------------------------------------------
% TODO: See if the downsampling can be included here (efficiency)
[vSynSigUp, baseStretcPosMs] = DoPitchShift3(vSynSigWarp, vBaseF0_smpls, vTargF0_smpls, baseFs, baseFs, interpType);

%% DOWNSAMPLING
vSynSig = decimate(vSynSigUp,baseFs/workFs, 11);

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

% Out:
vSynSig = vSynSig * enerFact;

end