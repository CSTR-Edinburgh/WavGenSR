function data = ReadOneVarMatFile(fileName)

data = load(fileName,'-mat');
data = data.data;

end