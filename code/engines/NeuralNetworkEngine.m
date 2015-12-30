classdef NeuralNetworkEngine < RecognitionEngine
    
    properties
        PS
    end
    
    methods
        
        % Constructor
        function NNE = NeuralNetworkEngine
        end
        
        % Funci�n de aprendizaje
        % learningData.input - caracter�sticas de objetos
        % learningData.output - c�digo correspondiente a objeto
        function learn(NNE,learningData)
            
            % Crea red neuronal
            % Define los tama�os de los datos de entrada y salida
            inputWidth = size(learningData.input,1);
            % Dado que los valores de salida corresponden con los id y
            % estos tomar�n valores desde 1 hasta N entonces se puede
            % considerar el m�ximo como el ancho de la salida nueva que se
            % generar� en forma de decodificador a partir de la salida
            % original que se introduzca. Esto es transparente a quien use
            % esta clase.
            outputWidth = max(learningData.output);
            
            % Determina una transformaci�n para los datos de salida ya que
            % transformar� un identificador id en un vector con todos los
            % valores a 0 excepto uno a 1
            encodedOutput = zeros(outputWidth, size(learningData.output,2));
            for i=1:size(learningData.output,2)
                encodedOutput(learningData.output(i),i) = 1;
            end
            
            nn = newff( learningData.input, ...
                        encodedOutput, ...
                         [2*inputWidth outputWidth], ...
                         {'tansig','tansig'}, 'trainlm');
                     
%            nn = newff( learningData.input, ...
%                        encodedOutput, ...
%                        [2*inputWidth inputWidth outputWidth ], ...
%                        {'tansig','tansig','tansig'}, 'trainlm');
            
            % Inicializaci�n de par�metros
            % Tasa de aprendizaje
            nn.trainParam.lr = 1e-3;
            % N�mero m�ximo de iteraciones para obtener convergencia
            nn.trainParam.epochs = 500;
            % Error meta
            nn.trainParam.goal = 1e-5;
            % Intervalo de visualizaci�n de los resultados
            nn.trainParam.show = 100;
            nn.trainParam.showWindow = true;
            nn.trainParam.showCommandLine = false;
            
            NNE.Engine = train(nn,learningData.input, encodedOutput);
        end
        
        % Funci�n de simulaci�n
        function output = simulate(NNE,input)
            % aux contiene el valor m�ximo
            % output contiene la posici�n del m�ximo
            [ aux, output ] = max(sim(NNE.Engine,input));
        end
        
    end % methods
    
end % classdef
