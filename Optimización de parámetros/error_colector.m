%% 1 Evaluación del error

function [medidasErrorValidacion] = error_colector(tipoVCOption, strAlgoritmo,strScore,strDataWeb, hLayers, method)
%ERROR_EVAL Entrega las medidas de error de BP
%   Ejecuta el BP para recibir las estadísticas del error



%[matrixCompletaTMP0] = mainBase(tipoVCOption,strAlgoritmo,strScore,strDataWeb,hLayers);

vectorCompletoRN = [];
%[TrainingAccuracy, TestingAccuracy,rOut]
for i =  1:10
    [valores_error] = evaluacionPredictor(tipoVCOption,strAlgoritmo,strScore,strDataWeb,hLayers, method);
    valores_error(3) = 1 - valores_error(3);
    valores_error
    vectorCompletoRN = [vectorCompletoRN norm(valores_error)];
end

medidasErrorValidacion = mean(vectorCompletoRN)/norm([1 1 1]);
end
 


% error_colector(2, 'BMW', 'BM25', 'Gov2', 5, 'bp')