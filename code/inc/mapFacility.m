classdef mapFacility < handle
    %mapFacility Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        labels
    end
    
    methods
        
        % Crea la facilidad para hacer una correspondencia entre etiquetas
        % e identificadores
        function MF = mapFacility(labels)
            MF.labels = unique(labels);
        end
        
        % Devuelve el identificador asignado a la etiqueta
        function id = label2id(MF,label)
            id = find(ismember(MF.labels, label));
        end
        
        % Devuelve la etiqueta asignada al identificador
        function label = id2label(MF,id)
            label = MF.labels{id};
        end
        
    end
    
end

