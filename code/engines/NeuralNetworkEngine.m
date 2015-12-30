classdef NeuralNetworkEngine < RecognitionEngine
    
    properties
        PS
    end
    
    methods
        
        % Constructor
        function NNE = NeuralNetworkEngine
        end
        
        % Función de aprendizaje
        % learningData.input - características de objetos
        % learningData.output - código correspondiente a objeto
        function learn(NNE,learningData)
            
            % Crea red neuronal
            % Define los tamaños de los datos de entrada y salida
            inputWidth = size(learningData.input,1);
            % Dado que los valores de salida corresponden con los id y
            % estos tomarán valores desde 1 hasta N entonces se puede
            % considerar el máximo como el ancho de la salida nueva que se
            % generará en forma de decodificador a partir de la salida
            % original que se introduzca. Esto es transparente a quien use
            % esta clase.
            outputWidth = max(learningData.output);
            
            % Determina una transformación para los datos de salida ya que
            % transformará un identificador id en un vector con todos los
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
            
            % Inicialización de parámetros
            % Tasa de aprendizaje
            nn.trainParam.lr = 1e-3;
            % Número máximo de iteraciones para obtener convergencia
            nn.trainParam.epochs = 500;
            % Error meta
            nn.trainParam.goal = 1e-5;
            % Intervalo de visualización de los resultados
            nn.trainParam.show = 100;
            nn.trainParam.showWindow = true;
            nn.trainParam.showCommandLine = false;
            
            NNE.Engine = train(nn,learningData.input, encodedOutput);
        end
        
        % Función de simulación
        function output = simulate(NNE,input)
            % aux contiene el valor máximo
            % output contiene la posición del máximo
            [ aux, output ] = max(sim(NNE.Engine,input));
        end
        
    end % methods
    
end % classdef
