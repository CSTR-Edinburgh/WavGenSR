% Smooths spectra using ceptral liftering.
% mSpLog: Could be spectra, spectral envelope matrix, or aperiodicity matrix, etc. in natural log domain.
function mSpLogSmooth = SPTKMelCepstralSmoothing(mSpLog, nCoeffs, alpha)

paths = GetPaths;

nFFTHalf = size(mSpLog, 1);
nFFT     = (nFFTHalf - 1) * 2;

% Write spectrum:
WriteFloatDataFile('temp.sp', mSpLog);

% SpecLog (Ln) to MGC: 
cmd1 = sprintf('%s/mcep -a %2.3f -m %d -l %d -e 1.0E-8 -j 0 -f 0.0 -q 2 temp.sp | ', paths.sptkbin, alpha , nCoeffs-1, nFFT);
%[status,cmdout] = system(cmd1);

% MGC to SpecLog (Ln):
cmd2 = sprintf('%s/mgc2sp -a %2.3f -g 0 -m %d -l %d -o 1 > temp_out.sp', paths.sptkbin, alpha , nCoeffs-1, nFFT);
cmd = [ cmd1 , cmd2];
[status,cmdout] = system(cmd);

% Read spectrum:
mSpLogSmooth = ReadFloatDataFileMatrix('temp_out.sp', nFFTHalf);

% Delete temp data:
delete('temp.sp');
%delete('temp.mgc');
delete('temp_out.sp');


%{
nFFTHalf = size(mSpLog, 1);
nFFT     = (nFFTHalf - 1) * 2;

% Write spectrum:
WriteFloatDataFile('temp.sp', mSpLog);

% SpecLog (Ln) to MGC: 
cmd = sprintf('./SPTK-3.7/bin/mcep -a %2.3f -m %d -l %d -e 1.0E-8 -j 0 -f 0.0 -q 2 temp.sp > temp.mgc', alpha , nCoeffs-1, nFFT);
[status,cmdout] = system(cmd);

% MGC to SpecLog (Ln):
cmd = sprintf('./SPTK-3.7/bin/mgc2sp -a %2.3f -g 0 -m %d -l %d -o 1 temp.mgc > temp_out.sp', alpha , nCoeffs-1, nFFT);
[status,cmdout] = system(cmd);

% Read spectrum:
mSpLogSmooth = ReadFloatDataFileMatrix('temp_out.sp', nFFTHalf);

% Delete temp data:
delete('temp.sp');
delete('temp.mgc');
delete('temp_out.sp');

%}


end