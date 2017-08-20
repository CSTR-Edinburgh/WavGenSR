% Get starting and ending points of segments of binary sequences (0 or 1)
% lookFor: 0 or 1. Look for segments containing 0 or 1
% vBin: array containing binary data (0 or 1)
% Note: can be used any positive number instead of 1.
function mPoints = GetSegmentsFromBinData(vBin,lookFor)


if lookFor == 1
    vBin(vBin > 0) = 1;
    vBin = 1 - vBin;
end

nFrms = length(vBin);
mPoints = [];
state = 1;
for FrNx=1:nFrms
    % start:
    if (vBin(FrNx) == 0) && (state == 1)
        mPoints = [ mPoints ; FrNx , -1 ];
        state = 0;
    end
    % end:
    if (vBin(FrNx) > 0) && (state == 0)
        mPoints(end,2) = FrNx - 1;
        state = 1;
    end
end

% Protection:
if ~isempty(mPoints) && (mPoints(end,2) == -1)
    mPoints(end,2) = nFrms;
end

end