
% Directorios a incluir en el path
base = [pwd,'\code'];
subdir = {
    'inc'
    'engines'
    };

path(path,base);
for i=1:length(subdir)
    path(path, [base,'\',subdir{i}]);
end

gui;
