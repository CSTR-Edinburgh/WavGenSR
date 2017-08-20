% Frequencies in Hz.
function Hd = HPF_ButterDesign(Fstop, Fpass, Fs)
Astop = 80;          % Stopband Attenuation (dB)
Apass = 0.1;         % Passband Ripple (dB)
match = 'stopband';  % Band to match exactly

h  = fdesign.highpass(Fstop, Fpass, Astop, Apass, Fs);
Hd = design(h, 'butter', 'MatchExactly', match);


