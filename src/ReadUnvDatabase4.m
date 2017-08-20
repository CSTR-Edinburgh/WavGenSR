% Reads unvoiced data from database.
function cUnvData = ReadUnvDatabase4

paths = GetPaths;

nFiles = length(paths.unvUnvWavs);
cUnvData = cell(nFiles,1);

for nxFl=1:nFiles
   
    % Reading files:
    [currSig, currFs] = audioread([paths.unvUnvWavs{nxFl} , '.wav']);
    
    % Saving into cell - structure:
    cUnvData{nxFl}.name     = paths.unvUnvWavs{nxFl}; 
    cUnvData{nxFl}.fs       = currFs; 
    cUnvData{nxFl}.vSig     = currSig;     
    cUnvData{nxFl}.mSpEnv   = ReadOneVarMatFile([paths.unvUnvWavs{nxFl} '.mat_sp'   ]);
    cUnvData{nxFl}.vSpEnvAv = ReadOneVarMatFile([paths.unvUnvWavs{nxFl} '.mat_sp_av']);     
end

end

%{
% Reads unvoiced data from database.
function cUnvData = ReadUnvDatabase4(unvListFile, expFs)

% Reading scp file:
paths.unvUnvWavs = ReadSCP(unvListFile);

nFiles = length(paths.unvUnvWavs);
cUnvData = cell(nFiles,1);

for nxFl=1:nFiles
   
    % Reading files:
    [currSig, currFs] = audioread([paths.unvUnvWavs{nxFl} , '.wav']);
    if (currFs ~= expFs); error('Unvoiced database: wrong sample rate, it must be equal to workFs.'); end

    % Saving into cell - strcuture:
    cUnvData{nxFl}.name     = paths.unvUnvWavs{nxFl}; 
    cUnvData{nxFl}.fs       = currFs; 
    cUnvData{nxFl}.vSig     = currSig;     
    cUnvData{nxFl}.mSpEnv   = ReadOneVarMatFile([ paths.unvUnvWavs{nxFl} '.mat_sp' ]);
    cUnvData{nxFl}.vSpEnvAv = ReadOneVarMatFile([ paths.unvUnvWavs{nxFl} '.mat_sp_av']);     
end

end
%}