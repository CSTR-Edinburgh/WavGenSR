% This function is provided to to avoid confusion about how to compute the exact 
% number of samples given the number of frames, shiftMs and fs
function nSmpls = GetLenFromNFrames(nFrms, shiftMs, fs)

	shift = shiftMs * fs / 1000;
	nSmpls = (nFrms - 1) * shift + 1;
end