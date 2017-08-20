function synSig = SptkMcepFilter(inSig, mDiffSpLog, frmShiftMs, fs, nCoeffs)

paths = GetPaths;

% Protection:
mDiffSpLog = [ mDiffSpLog , mDiffSpLog(:,end) ];

% Input parameters:
ord   = nCoeffs-1;
shift = round(frmShiftMs * fs / 1000);
nFFT = 2*(size(mDiffSpLog,1)-1);

% Saving temp data:
WriteFloatDataFile('temp.insig', inSig);
WriteFloatDataFile('temp.sp', mDiffSpLog);

% Spectrum to MCEP:
cmd1 = sprintf('%s/mcep -m %d -a 0.77 -l %d -j 0 -f 0.0 -q 2 temp.sp | ', paths.sptkbin, ord, nFFT);

% Check filter coefficients:
cmd2 = sprintf('%s/mlsacheck -m %d -a 0.77 -l %d -c 2 -r 1 > temp.mgc_check', paths.sptkbin, ord, nFFT);

cmd12 = [cmd1 , cmd2];
[status,cmdout] = system(cmd12);

% Filter signal:
%cmd3 = sprintf('./SPTK-3.7/bin/mlsadf_fixed -P 5 -m %d -a 0.77 -p %d temp.mgc_check temp.insig > temp.outsig', ord, shift);
cmd3 = sprintf('%s/mlsadf -P 5 -m %d -a 0.77 -p %d temp.mgc_check temp.insig > temp.outsig', paths.sptkbin, ord, shift);
[status,cmdout] = system(cmd3);

% Reading output:
synSig = ReadFloatDataFile('./temp.outsig');

% Deleting temp data:
delete('temp.insig');
delete('temp.sp');
delete('temp.mgc_check');
delete('temp.outsig');


end