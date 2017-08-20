% mSp: Linear Spectral envelope extracted from Mgc coeffs. matrix: [ Nfft half x nFrames ]
function mSp = ReadMgcFile(mgcFile, nMgcCoeffs, nFFT)

paths = GetPaths;

% Mgc to Sp:
cmd = sprintf('%s/mgc2sp -a %1.2f -g 0 -m %d -l %d -o 2 %s > temp.spbin', paths.sptkbin, 0.77, nMgcCoeffs - 1, nFFT, mgcFile );
[status, out] = system(cmd);

% Bin to Float:
vSp = ReadFloatDataFile('temp.spbin');

% Making the Sp matrix:
vSpLen   = length(vSp);
nFFTHalf = (nFFT / 2 + 1); 

mSp = reshape(vSp, nFFTHalf, vSpLen / nFFTHalf);

% Delete temp file:
delete('temp.spbin');

end