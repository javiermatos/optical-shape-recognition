classdef RecognitionEngine < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Engine
        % Esta variable contendr� la estructura de datos necesaria para
        % poder ejecutar la m�quina de reconocimiento �ptico de objetos.
    end
    methods (Abstract)
        learn(learningData);
        simulate(input);
    end
    
end
