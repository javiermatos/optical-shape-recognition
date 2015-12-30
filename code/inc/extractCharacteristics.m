function Shapes = extractCharacteristics(Image, exhaustive)

% Si no se indica se supone extracci�n no exhaustiva
if nargin==1, exhaustive = false; end

% Devuelve una estructura de formas con sus caracter�sticas:
% Shapes(i).Centroid      - centro de gravedad, dos componentes
% Shapes(i).EulerNumber   - n�mero de Euler de imagen
% Shapes(i).HuMomments    - vector con los siete momentos Hu

% Par�metros
BIN_THRESHOLD = 0.25;                           % Umbral para hacer imagen binaria
EROSION_STRUCTURAL_ELEMENT = strel('disk',1);   % Elemento estructural erosi�n
DILATION_STRUCTURAL_ELEMENT = strel('disk',1);  % Elemento estructural dilataci�n
CONNECTIVITY = 4;                               % Tipo de conectividad, 4 u 8

% % Par�metros para el detector de Harris
% HA_SIGMA = 3;           % Valor comprendido entre [1 3]
% HA_THRESHOLD = 1000;    % Valor ~1000
% HA_RADIUS = 3;          % Radio para descartar bordes no maximales [1 3]

% Par�metros para la extracci�n exhaustiva de caracter�sticas
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

% Dilata la imagen para evitar p�rdida por bordes d�biles
ImgBin = imerode(ImgBin, EROSION_STRUCTURAL_ELEMENT);
ImgBin = imdilate(ImgBin, DILATION_STRUCTURAL_ELEMENT);

% Rellena los agujeros
%ImgBin = imfill(ImgBin,'holes');

% Se segmenta la imagen resultante separando los objetos/caracteres
[ImgSeg, N] = bwlabel(ImgBin, CONNECTIVITY);
% ImgSeg ser� una imagen cuyas zonas de objetos ir�n numeradas de 1 a N
% para indicar los diferentes objetos de la imagen. N determina por ende el
% n�mero de objetos presentes en la imagen.

% Extracci�n de caracter�sticas de las regiones
%Shapes = regionprops(ImgSeg,'Centroid','Area','Perimeter','EulerNumber');
Shapes = regionprops(ImgSeg,'Centroid','EulerNumber');

% Por cada objeto calcula ciertas caracter�sticas aun no calculadas
for i=1:N
    
    % Aisla el objeto de la imagen segmentada
    Shape = ImgSeg==i;
    [row, column] = find(Shape);
    Shape = Shape(min(row):max(row),min(column):max(column));
    
    if exhaustive
        
        shapeCounter = 1;
        
        for s = SCALE_VECTOR
            
            for a = ROTATION_VECTOR
                
                % Forma procesada tras aplicar escalado y rotaci�n
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
    
    % N�mero de esquinas detectadas con el detector de Harris
    % Es necesario que la imagen de entrada de esta funci�n NO sea una
    % imagen binaria de manera que se seleccionar� aquella parte de la
    % imagen original tal que pertenezca a la regi�n del objeto
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
    
    % Momento Hu a partir de la regi�n
    % Shapes(i).HuMomments = humomments(Region);
    
    % Momento Hu a partir del per�metro (descartado por varianza)
    % Shapes(i).HuMomments = humomment(bwperim(Region,4));
    
end

if exhaustive
    Shapes = ExhaustiveShapes;
end
