% The output vf0 is formatted to have absolute Hertz values.
function vf0 = ReadLf0File(lf0File)

% Read lfo file:
fileIDLf0 = fopen(lf0File);
vLf0 = fread(fileIDLf0, inf, 'float32');
fclose(fileIDLf0);

vf0 = exp(vLf0);

end