% Separates the spectra in voiced and unvoiced segments according to F0 data.
function cSegs = SeparateSegments2(vF0, mSpEnv)

% Voiced bounds:
vF0bin = (vF0 > 1);
mVoiBounds = GetSegmentsFromBinData(vF0bin,1);
mUnvBounds = GetSegmentsFromBinData(vF0bin,0);

nVoiSegs = size(mVoiBounds,1);
nUnvSegs = size(mUnvBounds,1);

mVoiBounds = [ ones(nVoiSegs,1)  , mVoiBounds ];
mUnvBounds = [ zeros(nUnvSegs,1) , mUnvBounds ];

% Sorting by order:
mBounds = [ mVoiBounds ; mUnvBounds];
[ ~, vNewOrd ] = sort(mBounds(:,2));
mBounds = mBounds(vNewOrd,:);

nSegs = size(mBounds,1);
cSegs = cell(nSegs,1);

% Voiced segments:
for s=1:nSegs
    cSegs{s}.bVoiced = mBounds(s,1);
    cSegs{s}.mSpEnv  = mSpEnv(:,mBounds(s,2):mBounds(s,3));
    cSegs{s}.vF0     = vF0(mBounds(s,2):mBounds(s,3));    
end


end