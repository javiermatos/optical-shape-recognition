function [output]=reduceDimension(input,ndim)

% Los datos de input han de venir en forma de vectores columna

[coeff, score] = princomp(input);
%[coeff, score] = princomp(zscore(data.input));

output = score(:,1:ndim);
