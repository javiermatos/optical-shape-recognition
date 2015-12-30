function varargout = gui(varargin)
% GUI M-file for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 01-Nov-2009 20:53:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Archivo de caracter�sticas y del motor
handles.characteristicsFile = 'data.mat';
handles.engineFile = 'engine.mat';

% Directorio de fuentes predeterminado
handles.sourcePath = 'alfabeto/Arial Mayuscula';

% Archivo de manejo para abrir y guardar TODO, es decir, engine, data, map
% y objects.
handles.workspaceFile = [];

% Motor de reconocimiento
handles.Engine = [];

% Aplicaci�n de transformaci�n entre label <-> id
% Sirve para transformar las etiquetas asignadas a las formas a
% identificadores num�ricos y viceversa. Se utiliza para introducir en la
% Engine valores num�ricos y no etiquetas y luego hacer la reconversi�n a
% etiquetas.
handles.Map = [];

% Datos de entrada salida conseguidos de la ruta de aprendizaje
handles.Data = [];

% Objetos a reconocer de la imagen provista
handles.Shapes = [];

% Imagen de entrada
handles.image = imread('front.png');

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% Actualiza interfaz
actualizar_interfaz(handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MENU ARCHIVO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function archivo_Callback(hObject, eventdata, handles)
% hObject    handle to archivo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function nuevo_Callback(hObject, eventdata, handles)
% hObject    handle to nuevo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Inicializa la apliaci�n
handles.learningFile = [];
handles.sourcePath = [];
handles.workspaceFile = [];
handles.Engine = [];
handles.Map = [];
handles.Data = [];
handles.Shapes = [];
handles.image = [];

% Actualizaci�n de estructuras e interfaz
guidata(hObject,handles);
actualizar_interfaz(handles);


% --------------------------------------------------------------------
function abrir_Callback(hObject, eventdata, handles)
% hObject    handle to abrir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Carga un archivo de manejo de la aplicaci�n
[file, path] = uigetfile('*.osr');
if file
    % Inicializa la apliaci�n
    handles.workspaceFile = [];
    handles.Engine = [];
    handles.Map = [];
    handles.Data = [];
    handles.Shapes = [];
    handles.image = [];
    
    handles.workspaceFile = [ path, file ];
    
    load(handles.workspaceFile,'Engine','Map','Data','image','-mat');
    
    % Carga Engine si fue guardada
    if exist('Engine','var')
        handles.Engine = Engine;
    else
        handles.Engine = [];
    end
    
    % Carga Map si fue guardada
    if exist('Map','var')
        handles.Map = Map;
    else
        handles.Map = [];
    end
    
    % Carga Data si fue guardada
    if exist('Data','var')
        handles.Data = Data;
    else
        handles.Data = [];
    end
    
    % Carga imagen si fue guardada
    if exist('image','var')
        handles.image = image;
    else
        handles.image = [];
    end
end

% Actualizaci�n de estructuras e interfaz
guidata(hObject,handles);
actualizar_interfaz(handles);


% --------------------------------------------------------------------
function guardar_Callback(hObject, eventdata, handles)
% hObject    handle to guardar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.workspaceFile)
    
    [file, path] = uiputfile('*.osr');
    if file
        % Actualiza el archivo
        handles.workspaceFile = [ path, file ];
        
        save_file(handles, handles.workspaceFile);
    end
    
else
    save_file(handles, handles.workspaceFile);
end
    


% Actualizaci�n de estructuras e interfaz
guidata(hObject,handles);
actualizar_interfaz(handles);


% --------------------------------------------------------------------
function guardar_como_Callback(hObject, eventdata, handles)
% hObject    handle to guardar_como (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file, path] = uiputfile('*.osr');
if file
    % Actualiza el archivo
    handles.workspaceFile = [ path, file ];

    save_file(handles, handles.workspaceFile);
end

% Actualizaci�n de estructuras e interfaz
guidata(hObject,handles);
actualizar_interfaz(handles);


% --------------------------------------------------------------------
function salir_Callback(hObject, eventdata, handles)
% hObject    handle to salir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Cierra la aplicaci�n
close;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MENU ACCIONES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function acciones_Callback(hObject, eventdata, handles)
% hObject    handle to acciones (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function cambiar_directorio_aprendizaje_Callback(hObject, eventdata, handles)
% hObject    handle to cambiar_directorio_aprendizaje (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Cambia el directorio de imagenes de aprendizaje
path = uigetdir(handles.sourcePath);
if path
    % Actualiza el directorio
    handles.sourcePath = path;
    
    % Una vez cambiado el directorio se inicializan algunas cosas para
    % contemplar la modificaci�n en los datos del programa
    handles.Engine = [];
    handles.Map = [];
    handles.Data = [];
end

% Actualizaci�n de estructuras e interfaz
guidata(hObject,handles);
actualizar_interfaz(handles);


% --------------------------------------------------------------------
function realizar_extraccion_Callback(hObject, eventdata, handles)
% hObject    handle to realizar_extraccion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exhaustive = false;

% Realiza la extracci�n de caracter�sticas de las im�genes que hay en el
% directorio de aprendizaje
characteristicsFile = [handles.sourcePath,'/',handles.characteristicsFile];
option = 'No';
if exist(characteristicsFile,'file');
    text = 'Existe un archivo de datos generado para este directorio de aprendizaje, �Desea utilizarlo y evitar la computaci�n de la fase de extracci�n de caracter�sticas?';
    option = questdlg(text,'Advertencia','Si','No','Si');
end
% Dependiendo de la situaci�n realiza o no la extracci�n de caracter�sticas
switch option
    case 'No'
        % Si no existe el archivo de caracter�sticas de las im�genes se
        % genera y se almacena para posteriores lecturas y ahorro en el
        % c�lculo
        [handles.Map, handles.Data] = performCharacteristicsExtraction(handles.sourcePath, exhaustive);
        
        % Se guardan las caracter�sticas extra�das
        Map = handles.Map;
        Data = handles.Data;
        save(characteristicsFile, 'Map', 'Data','-mat');
        
    case 'Si'
        % Si existe el archivo de datos de caracter�sticas generado por
        % alguna computaci�n anterior se aprovecha para reducir el tiempo
        % de generaci�n de dichos datos
        
        load(characteristicsFile,'Map','Data','-mat');
        
        if exist('Map','var') && exist('Data','var')
            handles.Map = Map;
            handles.Data = Data;
        else
            errordlg(['�El archivo ', handles.characteristicsFile, ' es incorrecto!'],'Error');
        end
end

% Actualizaci�n de estructuras e interfaz
guidata(hObject,handles);
actualizar_interfaz(handles);

% --------------------------------------------------------------------
function realizar_extraccion_exhaustiva_Callback(hObject, eventdata, handles)
% hObject    handle to realizar_extraccion_exhaustiva (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exhaustive = true;

% Realiza la extracci�n de caracter�sticas de las im�genes que hay en el
% directorio de aprendizaje
characteristicsFile = [handles.sourcePath,'/',handles.characteristicsFile];
option = 'No';
if exist(characteristicsFile,'file');
    text = 'Existe un archivo de datos generado para este directorio de aprendizaje, �Desea utilizarlo y evitar la computaci�n de la fase de extracci�n de caracter�sticas?';
    option = questdlg(text,'Advertencia','Si','No','Si');
end
% Dependiendo de la situaci�n realiza o no la extracci�n de caracter�sticas
switch option
    case 'No'
        % Si no existe el archivo de caracter�sticas de las im�genes se
        % genera y se almacena para posteriores lecturas y ahorro en el
        % c�lculo
        [handles.Map, handles.Data] = performCharacteristicsExtraction(handles.sourcePath, exhaustive);
        
        % Se guardan las caracter�sticas extra�das
        Map = handles.Map;
        Data = handles.Data;
        save(characteristicsFile, 'Map', 'Data','-mat');
        
    case 'Si'
        % Si existe el archivo de datos de caracter�sticas generado por
        % alguna computaci�n anterior se aprovecha para reducir el tiempo
        % de generaci�n de dichos datos
        
        load(characteristicsFile,'Map','Data','-mat');
        
        if exist('Map','var') && exist('Data','var')
            handles.Map = Map;
            handles.Data = Data;
        else
            errordlg(['�El archivo ', handles.characteristicsFile, ' es incorrecto!'],'Error');
        end
end

% Actualizaci�n de estructuras e interfaz
guidata(hObject,handles);
actualizar_interfaz(handles);

% --------------------------------------------------------------------
function realizar_aprendizaje_Callback(hObject, eventdata, handles)
% hObject    handle to realizar_aprendizaje (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Realiza el aprendizaje sobre a partir de las caracter�sticas extra�das de
% las formas en los archivos de im�genes en handles.Data y genera un motor
% para reconocer las formas
engineFile = [handles.sourcePath,'/',handles.engineFile];
option = 'No';
if exist(engineFile,'file');
    text = 'Existe un archivo de la m�quina de reconocimiento generado para este directorio de aprendizaje, �Desea utilizarlo y evitar la computaci�n de la fase de aprendizaje?';
    option = questdlg(text,'Advertencia','Si','No','Si');
end
% Dependiendo de la situaci�n realiza o no la fase de aprendizaje
switch option
    case 'No'
        % Si no existe el archivo de la m�quina de reconocimiento se genera
        % y se almacena para posteriores lecturas y ahorros en c�lculo
        
        handles.Engine = performLearning(handles.Data);
        
        % Si no se ha creado la variable Engine entonces es que el
        % directorio no conten�a imagenes v�lidas.
        
        % Se crea el archivo de aprendizaje.
        if isempty(handles.Engine)
            errordlg('�El directorio de aprendizaje no contiene im�genes v�lidas!','Error');
        else
            Engine = handles.Engine;
            save(engineFile,'Engine','-mat');
        end
        
    case 'Si'
        % Si existe el archivo de datos de aprendizaje generado por alguna
        % computaci�n anterior se aprovecha para reducir el tiempo de
        % generaci�n de dichos datos
        
        load(engineFile,'Engine','-mat');
        
        if exist('Engine','var')
            handles.Engine = Engine;
        else
            errordlg(['�El archivo ', handles.engineFile, ' es incorrecto!'],'Error');
        end
        
end

% Actualizaci�n de estructuras e interfaz
guidata(hObject,handles);
actualizar_interfaz(handles);


% --------------------------------------------------------------------
function cargar_imagen_Callback(hObject, eventdata, handles)
% hObject    handle to cargar_imagen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Lee imagen de entrada
[file, path] = uigetfile('alfabeto/*.png;*.tif;*.bmp');
if file
    handles.image = imread([path, file]);
    
    % Una vez cambiado el directorio se inicializan algunas cosas para
    % contemplar la modificaci�n en los datos del programa
    handles.Shapes = [];
    
end

% Actualizaci�n de estructuras e interfaz
guidata(hObject,handles);
actualizar_interfaz(handles);


% --------------------------------------------------------------------
function realizar_reconocimiento_Callback(hObject, eventdata, handles)
% hObject    handle to realizar_reconocimiento (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Se examina la imagen que se pretende reconocer y se advierte de los
% posibles problemas de realizar esta operaci�n sobre una imagen en color
if size(handles.image,3) > 1
    texto = '�El programa opera con im�genes en escala de grises!, no se garantiza el correcto funcionamiento con im�genes a color.';
    opcion = questdlg(texto,'Advertencia','Continuar','Cancelar','Cancelar');
    if strcmp('Cancelar',opcion)
        return
    end
end

% Obtener caracter�sticas de los objetos de la imagen de entrada
handles.Shapes = performRecognition(handles.Engine, handles.Map, handles.image);

% Actualizaci�n de estructuras e interfaz
guidata(hObject,handles);
actualizar_interfaz(handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MENU INFORMACION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function informacion_Callback(hObject, eventdata, handles)
% hObject    handle to informacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function analisis_componentes_principales_Callback(hObject, eventdata, handles)
% hObject    handle to analisis_componentes_principales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Muestra una figura realizando el an�lisis de componentes principales
plotPCASpace(handles.Data);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MENU AYUDA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function ayuda_Callback(hObject, eventdata, handles)
% hObject    handle to ayuda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function guia_rapida_Callback(hObject, eventdata, handles)
% hObject    handle to guia_rapida (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Muestra un peque�o cr�dito
texto = [ ...
    'Gu�a r�pida de utilizaci�n:                          ';
    '                                                     ';
    '1. Seleccionar directorio de imagenes de aprendizaje ';
    '   - Acciones -> Cambiar directorio aprendizaje      ';
    '   - Predeterminada Arial Mayuscula                  ';
    '                                                     ';
    '2. Realizar proceso de extracci�n de caracter�sticas ';
    '   - Acciones -> Realizar extracci�n                 ';
    '                                                     ';
	'3. Realizar aprendizaje                              ';
	'   - Acciones -> Realizar aprendizaje                ';
	'                                                     ';
    '4. Seleccionar imagen de entrada                     ';
    '   - Acciones -> Cargar imagen                       ';
    '                                                     ';
    '5. Realizar proceso de reconocimiento de objetos     ';
    '   - Acciones -> Realizar reconocimiento             ';
    ];
helpdlg(texto, 'Gu�a r�pida');


% --------------------------------------------------------------------
function acerca_de_Callback(hObject, eventdata, handles)
% hObject    handle to acerca_de (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Muestra un peque�o cr�dito
texto = [ ...
    'Reconocedor �ptico de Formas  ';
    'Versi�n 2009.11.01            ';
    '                              ';
    'Javier Matos Odut             ';
    'http://github.com/javiermatos ';
    ];
helpdlg(texto, 'Acerca de');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCIONES AUXILIARES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function save_file(handles, path)

Engine = handles.Engine;
Map = handles.Map;
Data = handles.Data;
image = handles.image;

save(path,'Engine','Map','Data','image');

function actualizar_interfaz(handles)

% Dependencias directorio aprendizaje
if isempty(handles.sourcePath)
    set(handles.realizar_extraccion,'Enable','off');
    set(handles.realizar_extraccion_exhaustiva,'Enable','off');
else
    set(handles.realizar_extraccion,'Enable','on');
    set(handles.realizar_extraccion_exhaustiva,'Enable','on');
end

% Dependencias caracter�sticas de im�genes
if isempty(handles.Data)
    set(handles.realizar_aprendizaje,'Enable','off');
else
    set(handles.realizar_aprendizaje,'Enable','on');
end

% Dependencias de Engine e image
if isempty(handles.Engine) || isempty(handles.image)
    set(handles.realizar_reconocimiento,'Enable','off');
else
    set(handles.realizar_reconocimiento,'Enable','on');
end

% Dependencias de Data
if isempty(handles.Data)
    set(handles.analisis_componentes_principales,'Enable','off');
else
    set(handles.analisis_componentes_principales,'Enable','on');
end

imshow(handles.image);
if ~isempty(handles.image) && ~isempty(handles.Shapes)
    mostrar_resultado_reconocimiento(handles);
end

if isempty(handles.workspaceFile)
    set(handles.figure,'Name','Reconocedor �ptico de Formas');
else
    [ aux, file, ext ] = fileparts(handles.workspaceFile);
    set(handles.figure,'Name',[ 'Reconocedor �ptico de Formas - ', file, ext ]);
end


function mostrar_resultado_reconocimiento(handles)

% Base de color para el text
colorBase = [ 'b' ; 'g' ; 'r' ; 'c' ; 'm' ; 'y' ];

% Para cada objeto (reconocido o no) se muestra el caracter en la caja de
% text y se superpone una plantilla con las etiquetas
%string = [];
for i=1:length(handles.Shapes)
    %string = [ string , handles.Shapes(i).Label , ' ' ];
    text(handles.Shapes(i).Centroid(1),handles.Shapes(i).Centroid(2),[' \leftarrow ',handles.Shapes(i).Label],'FontSize',18,'Color',colorBase(mod(i-1,length(colorBase))+1));
end
