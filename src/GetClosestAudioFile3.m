% Selects the closest audio file to the target spectra.
% Supoort for out structures of distance functions.
function [ selNx, distOutStr ] = GetClosestAudioFile3(mTargSp, cUnvData)


nFiles      = length(cUnvData);
dists       = zeros(nFiles,1);
distFuncStr = cell(nFiles,1);

for nxFl=1:nFiles       
    [dists(nxFl), distFuncStr{nxFl,1}] = GetSpPeakDist(mTargSp,cUnvData{nxFl, 1}.vSpEnvAv);       
end

[~,selNx]  = min(dists);
distOutStr = distFuncStr{selNx,1};

end