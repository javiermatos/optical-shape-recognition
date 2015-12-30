function plotPCASpace(data)

% La entrada ha de contener los objetos por filas y las caracter�sticas por
% columnas, es la transpuesta a la forma en como se procesa en las redes
% neuronales, hay que tener cuidado con eso
coordinates = reduceDimension(data.input',3);

fig = figure('Name','An�lisis de componentes principales');
hold all;

% Fuerza un tama�o de figura de 600x600
set(fig, 'Position', [0 0 600 600]);

for i=1:unique(max(data.output))
    plot3(  coordinates(data.output == i,1), ...
            coordinates(data.output == i,2), ...
            coordinates(data.output == i,3), ...
            '.');
end

title('An�lisis de componentes principales (Reducido a 3 dimensiones)');
