classdef WaveletBuilder
    
   properties
       
       
       
   end
   
   
   
   methods
       
       function [tArray, motherWavelet] = getWavelet(obj, waveletType, nPoints)
           if(waveletType == WaveletType.DAUBECHIES_1)
               coeffs = [1, 1];
               [tArray,~,motherWavelet] = obj.getDaubechiesWaveletWithCoeffs(coeffs, nPoints);
           elseif(waveletType == WaveletType.DAUBECHIES_4) 
               coeffs = [(1 + sqrt(3))/4, (3 + sqrt(3))/4,  (3 - sqrt(3))/4, (1 - sqrt(3))/4 ];
               [tArray,~,motherWavelet] = obj.getDaubechiesWaveletWithCoeffs(coeffs, nPoints);
           end
       end
       
       
       
       function [tArray, scalingSignal, wavelet] = getDaubechiesWaveletWithCoeffs(obj, coeffs, nPoints)
           exponent = floor(nPoints/(length(coeffs) - 1));
           power = floor(log2(exponent));
           zerosToAdd = nPoints - (length(coeffs) - 1)*2^(power);
           %Construimos la matriz M 
           M = zeros(length(coeffs));
           for i = 1:length(coeffs)
               for j = 1:length(coeffs)
                   index = 2*(i - 1) - j + 2;
                   if(index >= 1 && index <= length(coeffs))
                      M(i,j) = coeffs(index); 
                   end
                end
           end
           epsilon = 1*10^-(15);
           %Sacamos sus eigenvalores
           [V, D] = eigs(M);
           %Obtenemos el vector que corresponde al eigenvalor 1
           vector = zeros(length(coeffs), 1);
           for i = 1:size(D,1)
               disp(abs(D(i,i) - 1));
               if(abs(D(i,i) - 1) < epsilon)
                  vector = V(:,i);
                  break;
               end
           end
           vector = vector/sum(vector);
           %En este punto ya tenemos nuestro vector con el valor de la
           %función en enteros 
           
           tArray = 0:length(coeffs) - 1;
           array = vector;
           %Obtenemos los puntos intermedios de la función de escalamiento
           for i= 1:power
               newArray = [];
               newTArray = [];
               newArray = [newArray, array(1)];
               newTArray = [newTArray, tArray(1)];
               for j = 2:length(array)
                   middleValue = 0;
                   for s = 1:length(coeffs)
                       time = (tArray(j)+tArray(j - 1)) - s + 1;
                       for d = 1:length(tArray)
                          if(abs(time - tArray(d)) < epsilon)
                             %disp("time "+string(tArray(j)));
                             middleValue = middleValue + coeffs(s)*array(d);
                             %disp(coeffs(s));
                             %disp(array(d));
                             break;
                          end
                       end
                   end
                   newArray = [newArray, middleValue];
                   newArray = [newArray, array(j)];
                   newTArray = [newTArray, (tArray(j) +tArray(j-1))/2];
                   newTArray = [newTArray, tArray(j)];
               end
               array = newArray;
               tArray = newTArray;               
           end
           
           scalingSignal = array;
           %Rellenamos con ceros la función de escalamiento para tener el 
           %número de puntos que pidió
           deltaTime = tArray(2) - tArray(1);
           for i = 1:zerosToAdd - 1
              scalingSignal = [scalingSignal, 0];
              tArray = [tArray, tArray(end) + deltaTime];
           end
           
           %Armamos la wavelet
           wavelet = zeros(length(scalingSignal), 1);
           for i = 1:length(scalingSignal) - 1
              value = 0;
              for k = 1:length(coeffs)
                  index = length(coeffs) - k + 1;
                  if(index >= 1 && index <= length(coeffs))
                     coef = coeffs(index); 
                     time = 2*tArray(i) - k + 1;
                     for s = 1:length(tArray)
                         if(abs(tArray(s) - time)<epsilon)
                             value = value + ((-1)^(k-1))*coef*scalingSignal(s);
                             break;
                         end
                     end
                  end
              end
              wavelet(i) = value;
           end
       end
          
       function [lowPass, highPass] = getDecompositionFilterCoefficients(obj, waveletType)
           if(waveletType == WaveletType.DAUBECHIES_1)
               lowPass  = (1/sqrt(2))*[1, 1];
               highPass = (1/sqrt(2))*[-1, 1];
           elseif(waveletType == WaveletType.DAUBECHIES_4) 
               lowPass = (1/sqrt(2))*[(1 - sqrt(3))/4, (3 - sqrt(3))/4, (3 + sqrt(3))/4, (1 + sqrt(3))/4];
               highPass = (1/sqrt(2))*[-(1 + sqrt(3))/4, (3 + sqrt(3))/4,  -(3 - sqrt(3))/4, (1 - sqrt(3))/4];
           end
       end
       
       
       function [lowPass, highPass] = getReconstructionFilterCoefficients(obj, waveletType)
           if(waveletType == WaveletType.DAUBECHIES_1)
               lowPass = (1/sqrt(2))*[1, 1];
               highPass = (1/sqrt(2))*[1, -1];
           elseif(waveletType == WaveletType.DAUBECHIES_4)
               lowPass = (1/sqrt(2))*[(1 + sqrt(3))/4, (3 + sqrt(3))/4,  (3 - sqrt(3))/4, (1 - sqrt(3))/4];
               highPass = (1/sqrt(2))*[(1 - sqrt(3))/4, -(3 - sqrt(3))/4, (3 + sqrt(3))/4, -(1 + sqrt(3))/4];
           end
           
       end
       
       
       function [newTArray, y] = translateAndScale(obj, signal, u, s, tArray)
        newTArray = zeros(length(tArray), 1);
        y = zeros(length(tArray), 1);
        tMin  = min(tArray);
        tMax = max(tArray);
        for i = 1:length(tArray)
            %Tiempo transformado
            newTime = (tArray(i) - u)/s; 
            if(newTime < tMin)
                y(i) = 0;
            elseif(newTime >tMax)
                y(i) = 0;
            else
                %Buscamos dentro de que tiempos corresponde en el espacio
                %original y suponemos un valor constante ()
                for j = 1:length(tArray) - 1
                    if(newTime >= tArray(j) && newTime <= tArray(j+1))
                       y(i) = signal(j);
                       break;
                    end
                end
            end
            newTArray(i) = newTime;
        end        
    end
   end
       
   end
    
    
    
    
    