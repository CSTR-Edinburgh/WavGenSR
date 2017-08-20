% Interpolates each row separately.
% vExtrapVal: Vector with the values used for extrapolation. For some
% reason, it does not work directly in interp1.
function mInterpData = InterpMatrix2(vOrigPos, mOrigData, vNewPos, method, vExtrapVal)

mInterpData = interp1(vOrigPos, mOrigData', vNewPos, method)';

% Protection against Nans:
vNanNxs = find(isnan(mInterpData(1,:)));
if ~isempty(vNanNxs)
    for i=vNanNxs(1):vNanNxs(end)
        mInterpData(:,i) = vExtrapVal;
    end
end

end