function [Engine]=performLearning(Data)

% Proceso de aprendizaje
% El proceso de aprendizaje utiliza los datos extraídos de las imágenes
% sobre el motor de reconocimiento

% Se crea la máquina para reconocimiento de objetos
Engine = NeuralNetworkEngine;

% Se entrena la máquina con los patrones entrada/salida
Engine.learn(Data);
