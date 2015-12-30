function [Engine]=performLearning(Data)

% Proceso de aprendizaje
% El proceso de aprendizaje utiliza los datos extra�dos de las im�genes
% sobre el motor de reconocimiento

% Se crea la m�quina para reconocimiento de objetos
Engine = NeuralNetworkEngine;

% Se entrena la m�quina con los patrones entrada/salida
Engine.learn(Data);
