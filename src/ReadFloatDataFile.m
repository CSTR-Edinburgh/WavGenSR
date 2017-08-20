function vData = ReadFloatDataFile(fileName)

fID   = fopen(fileName);
vData = fread(fID, inf, 'float32');
fclose(fID);

end