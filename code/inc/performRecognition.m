function Shapes = performRecognition(Engine,Map,image)

Shapes = extractCharacteristics(image);

% Devuelve una estructura de objetos con sus características:
% Shapes(i).Centroid      - centro de gravedad, dos componentes
% Shapes(i).EulerNumber   - número de Euler de imagen (evitar usar)
% Shapes(i).HuMomments    - vector con los siete momentos Hu
% Shapes(i).Id            - identificador de la forma
% Shapes(i).Label         - etiqueta de la forma

for i=1:length(Shapes)
    Shapes(i).Id = Engine.simulate([ Shapes(i).EulerNumber Shapes(i).HuMomments ]');
    Shapes(i).Label = Map.id2label(Shapes(i).Id);
end
