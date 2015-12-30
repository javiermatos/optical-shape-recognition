function [Map,Data]=performCharacteristicsExtraction(imagesPath, exhaustive, progressBar, verbose)

% Para mostrar informaci�n del proceso
if nargin<3, progressBar = true; verbose = false; end
% Si no se indica se supone extracci�n no exhaustiva
if nargin==1, exhaustive = false; end

% Proceso de extracci�n de caracter�sticas
% El proceso de extracci�n supondr� la extracci�n de caracter�sticas de
% los diferentes caracteres para una fuente seleccionada y la
% especificaci�n de una aplicaci�n de correspondencia para relacionar las
% formas de los archivos de entrada con el nombre de dicho archivo.

% Obtiene la lista de imagenes de la ruta correspondiente.
ImagesList = listImageFiles(imagesPath);

if ~isempty(ImagesList)
    
    % Extrae en Labels el nombre de los archivo tras suprimir la extensi�n
    % que tienen de la forma '.***' (presupone 4 caracteres)
    
    Labels = cell(length(ImagesList),1);
    for i=1:length(ImagesList)
        % Extrae el directorio y el nombre de archivo de la ruta
        [aux, file] = fileparts(ImagesList(i).name);
        Labels{i} = file;
    end

    % Facilidad de mapeado label <-> id
    Map = mapFacility(Labels);

    % Extrae caracter�sticas de los objetos presentes en las imagenes
    % destinadas al aprendizaje. Cabe mencionar que las imagenes con este
    % prop�sito han de presentar varias instancias de un �nico caracter.
    
    if progressBar
        % Barra de progreso
        w = waitbar(0,'Analizando imagenes','Name','Analizando imagenes');
    end
    if verbose
        % Mensaje por consola
        disp('Analizando imagenes');
    end
    
    % Estructura de datos a usar con la Engine
    Data.input = [];
    Data.output = [];
    
    for i=1:length(ImagesList)
        
        if progressBar
            % Actualiza barra de progreso
            waitbar(i/length(ImagesList),w,['Analizando imagen ',ImagesList(i).name]);
        end
        if verbose
            % Mensaje por consola
            disp(['Analizando imagen ',ImagesList(i).name]);
        end
        
        % Extracci�n de caracter�sticas.
        Shapes = extractCharacteristics(imread([imagesPath,'/',ImagesList(i).name]), exhaustive);
        
        % Devuelve una estructura de objetos con sus caracter�sticas:
        % Shapes(i).Centroid      - centro de gravedad, dos componentes
        % Shapes(i).EulerNumber   - n�mero de Euler de imagen (evitar usar)
        % Shapes(i).HuMomments    - vector con los siete momentos Hu
        
        %for j=1:length(Shapes)
        %    Data.input = [ Data.input [ Shapes(j).EulerNumber Shapes(j).HuMomments ]'];
        %end
        % Equivalencia m�s r�pida
        Data.input = [ Data.input [ reshape([Shapes.EulerNumber], length(Shapes(1).EulerNumber), []) ; reshape([Shapes.HuMomments], length(Shapes(1).HuMomments), []) ] ];
        
        % Extrae el directorio y el nombre de archivo de la ruta
        [aux, file] = fileparts(ImagesList(i).name);
        
        % Genera la salida para aplicar posteriormente la Engine
        Data.output = [ Data.output ones(1,length(Shapes))*Map.label2id(file)];
        
        % El identificador de la letra ser� el nombre del archivo sin
        % extensi�n. De esta manera se tiene que el nombre del archivo
        % menos la extensi�n nombrar� al tipo de caracter que se supone
        % contiene la imagen de aprendizaje para el reconocimiento.
        
    end

    if progressBar
        % Cierra barra de progreso
        close(w);
    end
    
else
    % Si no hay im�genes no se hace computaci�n alguna
    Map = [];
    Data = [];
end
