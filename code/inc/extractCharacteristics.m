function Shapes = extractCharacteristics(Image, exhaustive)

% Si no se indica se supone extracción no exhaustiva
if nargin==1, exhaustive = false; end

% Devuelve una estructura de formas con sus características:
% Shapes(i).Centroid      - centro de gravedad, dos componentes
% Shapes(i).EulerNumber   - número de Euler de imagen
% Shapes(i).HuMomments    - vector con los siete momentos Hu

% Parámetros
BIN_THRESHOLD = 0.25;                           % Umbral para hacer imagen binaria
EROSION_STRUCTURAL_ELEMENT = strel('disk',1);   % Elemento estructural erosión
DILATION_STRUCTURAL_ELEMENT = strel('disk',1);  % Elemento estructural dilatación
CONNECTIVITY = 4;                               % Tipo de conectividad, 4 u 8

% % Parámetros para el detector de Harris
% HA_SIGMA = 3;           % Valor comprendido entre [1 3]
% HA_THRESHOLD = 1000;    % Valor ~1000
% HA_RADIUS = 3;          % Radio para descartar bordes no maximales [1 3]

% Parámetros para la extracción exhaustiva de características
SCALE_STEPS = 3;
MIN_SCALE = 0.2;
MAX_SCALE = 1.0;
SCALE_VECTOR = linspace(MIN_SCALE, MAX_SCALE, SCALE_STEPS);

ROTATION_STEPS = 18;
MIN_ROTATION = 0;
MAX_ROTATION = 360*(ROTATION_STEPS-1)/ROTATION_STEPS;
ROTATION_VECTOR = linspace(MIN_ROTATION, MAX_ROTATION, ROTATION_STEPS);


% Lee la imagen
ImgBin = im2bw(Image, BIN_THRESHOLD);

% Dilata la imagen para evitar pérdida por bordes débiles
ImgBin = imerode(ImgBin, EROSION_STRUCTURAL_ELEMENT);
ImgBin = imdilate(ImgBin, DILATION_STRUCTURAL_ELEMENT);

% Rellena los agujeros
%ImgBin = imfill(ImgBin,'holes');

% Se segmenta la imagen resultante separando los objetos/caracteres
[ImgSeg, N] = bwlabel(ImgBin, CONNECTIVITY);
% ImgSeg será una imagen cuyas zonas de objetos irán numeradas de 1 a N
% para indicar los diferentes objetos de la imagen. N determina por ende el
% número de objetos presentes en la imagen.

% Extracción de características de las regiones
%Shapes = regionprops(ImgSeg,'Centroid','Area','Perimeter','EulerNumber');
Shapes = regionprops(ImgSeg,'Centroid','EulerNumber');

% Por cada objeto calcula ciertas características aun no calculadas
for i=1:N
    
    % Aisla el objeto de la imagen segmentada
    Shape = ImgSeg==i;
    [row, column] = find(Shape);
    Shape = Shape(min(row):max(row),min(column):max(column));
    
    if exhaustive
        
        shapeCounter = 1;
        
        for s = SCALE_VECTOR
            
            for a = ROTATION_VECTOR
                
                % Forma procesada tras aplicar escalado y rotación
                processedShape = imrotate(imresize(Shape,s),a);
                
                ExhaustiveShapes(((i-1)*SCALE_STEPS*ROTATION_STEPS)+shapeCounter,1).Centroid = Shapes(i).Centroid;
                ExhaustiveShapes(((i-1)*SCALE_STEPS*ROTATION_STEPS)+shapeCounter,1).EulerNumber = Shapes(i).EulerNumber;
                
                % Momento Hu a partir de la forma
                ExhaustiveShapes(((i-1)*SCALE_STEPS*ROTATION_STEPS)+shapeCounter,1).HuMomments = humomments(processedShape);
                
                shapeCounter = shapeCounter + 1;
                
            end
            
        end
        
    else
        % Momento Hu a partir de la forma
        Shapes(i).HuMomments = humomments(Shape);
    end
    
    
    % Circularidad de la region
    % Shapes(i).Circularity = 4*pi*Shapes(i).Area/Shapes(i).Perimeter^2;
    
    % Número de esquinas detectadas con el detector de Harris
    % Es necesario que la imagen de entrada de esta función NO sea una
    % imagen binaria de manera que se seleccionará aquella parte de la
    % imagen original tal que pertenezca a la región del objeto
    % identificado.
%     Region = imdilate(Region, DILATION_STRUCTURAL_ELEMENT);
%     RegionImage = im2uint8(im2double(Image).*im2double(Region));
%     [ImgAux, r, c] = harris(RegionImage, HA_SIGMA, HA_THRESHOLD, HA_RADIUS, 0);
%     Shapes(i).Corners = length(r);
    
%     % Muestreo por pantalla de las regiones junto con las esquinas
%     esquinas = length(r)
%     figure;
%     subplot(1,2,1);
%     imshow(Region);
%     subplot(1,2,2);
%     imshow(RegionImagen);
%     hold on;
%     plot(c(:),r(:),'.r');
    
    % Momento Hu a partir de la región
    % Shapes(i).HuMomments = humomments(Region);
    
    % Momento Hu a partir del perímetro (descartado por varianza)
    % Shapes(i).HuMomments = humomment(bwperim(Region,4));
    
end

if exhaustive
    Shapes = ExhaustiveShapes;
end
