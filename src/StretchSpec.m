% stretching factor
function vOutSp = StretchSpec(vInSp,fact, interpType)


nBins = length(vInSp);
vOrigNx = (0:(nBins-1))';
vStrecthNx = vOrigNx * fact;
lastVal = vInSp(end);
vOutSp = interp1(vStrecthNx,vInSp,vOrigNx, interpType,lastVal);

% Debug:
%{
figure(16);
plot(vOrigNx,vInSp, vOrigNx, vOutSp);
legend('vInSp','vOutSp');
%}
end