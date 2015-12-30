classdef RecognitionEngine < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Engine
        % Esta variable contendrá la estructura de datos necesaria para
        % poder ejecutar la máquina de reconocimiento óptico de objetos.
    end
    methods (Abstract)
        learn(learningData);
        simulate(input);
    end
    
end
