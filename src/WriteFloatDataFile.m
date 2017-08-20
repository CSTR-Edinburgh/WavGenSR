% if mStream is a vector (no matter is column or row vector), it will be directly written to the file.
% if mStream is a matrix, it will write in column order. 
% e.g.: mStream = [0,0;1,1]; the sequence: 0,1,0,1 will be written
function WriteFloatDataFile(fileName, mStream)

fID   = fopen(fileName, 'w');
fwrite(fID, mStream, 'float32');
fclose(fID);

end