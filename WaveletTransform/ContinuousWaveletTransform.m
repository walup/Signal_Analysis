classdef ContinuousWaveletTransform
   
   %Obtiene la transformada continua wavelet
   methods
      
       function [sArray, tArray, correlationMatrix] = computeContinuousTransform(obj,signal,tArray,minScale,maxScale,nPoints, waveletType)
           minT = min(tArray);
           maxT = max(tArray);
           n = length(signal);
           %Escalas a obtener
           sArray = linspace(minScale, maxScale, nPoints);
           %Reflexión de la señal para convertir convolución en correlación
           reflectedSignal = flip(signal);
           %Matriz que iremos usando
           correlationMatrix = zeros(length(sArray), length(tArray));
           deltaTime = tArray(2) - tArray(1);
           %Wavelet madre
           wb = WaveletBuilder();
           [~,motherSignal] = wb.getWavelet(waveletType, n);
           h = waitbar(0, "Obteniendo CWT");
           for i = 1:size(correlationMatrix, 1)
               waitbar(i/size(correlationMatrix,1),h,"ObteniendoCWT")
               %Obtenemos la escala
               s = sArray(i);
               %Escalamos la señal madre manteniendola centrada
               [~,translatedMotherSignal] = wb.translateAndScale(motherSignal,  -(minT + maxT)*(s-1)/2, s, tArray);
               %Dividimos entre la raiz de la escala
               translatedMotherSignal = 1/(sqrt(abs(s)))*translatedMotherSignal;
               %Hacemos la convolución
               convResult = convolution(reflectedSignal', translatedMotherSignal,deltaTime);
               correlationMatrix(i,:) = convResult;   
           end
           correlationMatrix = (correlationMatrix.^2)/sum(signal.^2);
           close(h)
       end
           
    end
       
    
    
    
    
end