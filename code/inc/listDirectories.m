function list=listDirectories(path)

list = dir([path]);

% Elimina los directorios . y ..
list([1 2]) = [];

% Elimina los archivos
list = list([list.isdir]);
