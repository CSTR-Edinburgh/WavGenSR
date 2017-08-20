function vSynSig = WavGenSR(vTargF0, mTargSpEnv, outFs, opts)
%% PARSING OPTIONS:

defaults.crFadeMs       = 2;      % Length of the crossfade between segments (in ms).
defaults.shiftMs        = 5;      % Frame shift (hopsize) in ms.
defaults.unvFact        = 0.7;    % Amplitude factor for unvoiced segments.
defaults.bMelSmoothing  = false;  % Spectral smoothing.
defaults.bSpAdLinPhase  = false;  % Applies linear phase filter.
defaults.baseGender     = 'male'; % Gender of the base signal: 'male' or 'female'
defaults.interpType     = 'linear'; % Function used in interpolation tasks: 'linear' or 'spline' (slower).

if exist('opts', 'var')
    opts = setstructfields(defaults,opts);
else
    opts = defaults;
end

%% READ DATABASE
disp('Reading database...');
paths = GetPaths;

% Voiced:------------------------------------------------------------------
% Gender of base signal:
baseVoiWavName = paths.bsVoiWavMale;
if strcmp(defaults.baseGender, 'female')
    baseVoiWavName = paths.bsVoiWavFem; 
end

% wav and feats:
[voiDir, voiToken] = fileparts(baseVoiWavName);
sVoiBase.vF0    = ReadOneVarMatFile([ voiDir '/' voiToken '.mat_f0' ]);
sVoiBase.mSpEnv = ReadOneVarMatFile([ voiDir '/' voiToken '.mat_sp']);

[sVoiBase.vSig, sVoiBase.fs] = audioread(baseVoiWavName);
workFs = sVoiBase.fs/2;

% Unvoiced:----------------------------------------------------------------
cBaseUnvData = ReadUnvDatabase4;

%% BANDWIDTH EXTENSION AND/OR SPECTRAL RESAMPLING (for fs != 48k and nfft != 4096)
inNbins = size(mTargSpEnv,1);
expNbins   = 1 + (size(sVoiBase.mSpEnv,1)-1) / 2; % expected number of bins.
if (workFs ~= outFs) || (inNbins ~= expNbins)
    expNyq  = workFs / 2;
    inNyq   = outFs/2;
    vInFreqs   = linspace(0,inNyq,inNbins);
    vExpFreqs  = linspace(0,expNyq,expNbins);
    mTargSpEnv = InterpMatrix2(vInFreqs, mTargSpEnv', vExpFreqs, opts.interpType, mTargSpEnv(end,:)')';
end

%% SEGMENTS SEPARATION
vTargF0    = vTargF0(:);
cSegs      = SeparateSegments2(vTargF0, mTargSpEnv);
synWinMs   = 40; % STRAIGHT uses this value, so it is a reasonable number to prevent problems in the beggining of the spectral extraction.
nFrmsToAdd = round(synWinMs / (2 * opts.shiftMs )); % TODO: Improve
nFrmsToAdd = nFrmsToAdd + 1; % Adding one frame more to include the middle point between voiced/unvoiced segments.

%% SYNTH SEGMENTS
nSegs = length(cSegs);
cSynSegs = cell(nSegs,1);

nCffsUnvSmth = 50; % Smoothing factor for the spectrum in unvoiced segments.
nCffsVoiSmth = 120; % Smoothing factor for the spectrum in voiced segments.
if ~opts.bMelSmoothing
    nCffsUnvSmth = 0;
    nCffsVoiSmth = 0;
end

for s=1:nSegs
    DispProgress(s, 1, 'Generating segment: ', nSegs);
    
    if cSegs{s}.bVoiced == 1 % case voiced        
        cSynSegs{s} = SynthOneVoicedSegment2(cSegs{s}, sVoiBase, nFrmsToAdd, opts.crFadeMs, opts.shiftMs, workFs, nCffsVoiSmth, opts.bSpAdLinPhase, opts.interpType);
        
    else % case unvoiced       
        cSynSegs{s} = opts.unvFact * SynthOneUnvoicedSegment(cSegs{s}, cBaseUnvData, nFrmsToAdd, opts.crFadeMs, opts.shiftMs, workFs, nCffsUnvSmth, opts.bSpAdLinPhase); 
    end    
end

%% ADDING SEGMENTS
vSynSig = AddSegments(cSynSegs, defaults.crFadeMs, workFs);

%% HPF (protection)
HPFd = HPF_ButterDesign(40, 70, workFs);
vSynSig = filter(HPFd, vSynSig);

%% DOWSAMPLING
if (workFs ~= outFs)
    vSynSig = resample(vSynSig, outFs, workFs);
end

%% FINAL - FADE IN and FADE OUT
crFadeLen_smpls = round(defaults.crFadeMs * outFs / 1000);
vFade = hann(2*crFadeLen_smpls + 1);
vFade = vFade(1:crFadeLen_smpls);
vSynSig(1:crFadeLen_smpls) = vSynSig(1:crFadeLen_smpls) .* vFade;
vSynSig((end-crFadeLen_smpls+1):end) = vSynSig((end-crFadeLen_smpls+1):end) .* vFade(end:-1:1);

disp('Done!');
end