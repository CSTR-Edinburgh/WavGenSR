% Display progress when running a loop.
function DispProgress(i, EveryN, msge, total)

if rem(i,EveryN) == 0
    fprintf('%s%d/%d\n', msge,i,total);
end

end