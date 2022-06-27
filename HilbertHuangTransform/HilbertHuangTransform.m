classdef HilbertHuangTransform
   
    
    methods
        function [intrinsicModes, residue] = getIntrinsicModeFunctions(obj, signal, nLevels, S)
            sig = signal;
            tArray = 1:length(signal);
            intrinsicModes = {};
            for i = 1:nLevels
                iterations = 0;
                nCrossings = 10;
                nExtrema = 10;
                hSig = sig;
                while(iterations < S && ~abs(nExtrema - nCrossings) <= 1)
                %Obtenemos los mínimos locales de la señal
                localMinIndexes = islocalmin(hSig);
                localMaxIndexes = islocalmax(hSig);
                if(length(find(localMaxIndexes))<2)
                   disp("Broke");
                   break; 
                end
                upperSpline = spline(find(localMaxIndexes), hSig(localMaxIndexes), tArray);
                lowerSpline = spline(find(localMinIndexes), hSig(localMinIndexes), tArray);
                
                meanSpline = (upperSpline + lowerSpline)/2;
                
                hSig = hSig - meanSpline;
                %Calculamos el número de extremos locales 
                nExtrema = sum(islocalmin(hSig)) + sum(islocalmax(hSig));
                %Obtenemos el número de cruces en 0
                nCrossings = 0;
          
                for j = 1:length(hSig)-1
                    if(hSig(j)*hSig(j+1) < 0)
                        nCrossings = nCrossings + 1;
                    end
                end
                
                iterations = iterations + 1;
                end
                intrinsicModes{i} = hSig;
                sig = sig - hSig;
            end
            
            residue = sig;
        end
        
        function [intrinsicModes, residue] = getIntrinsicModeFunctionsWithPlots(obj, signal, nLevels, S)
            sig = signal;
            tArray = 1:length(signal);
            intrinsicModes = {};
            for i = 1:nLevels
                iterations = 0;
                nCrossings = 10;
                nExtrema = 10;
                hSig = sig;
                while(iterations < S && ~abs(nExtrema - nCrossings) <= 1)
                %Obtenemos los mínimos locales de la señal
                localMinIndexes = islocalmin(hSig);
                localMaxIndexes = islocalmax(hSig);
                if(length(find(localMaxIndexes))<2)
                   disp("Broke");
                   break; 
                end
                upperSpline = spline(find(localMaxIndexes), hSig(localMaxIndexes), tArray);
                lowerSpline = spline(find(localMinIndexes), hSig(localMinIndexes), tArray);
                
                meanSpline = (upperSpline + lowerSpline)/2;
                
                hSig = hSig - meanSpline;
                %Calculamos el número de extremos locales 
                nExtrema = sum(islocalmin(hSig)) + sum(islocalmax(hSig));
                %Obtenemos el número de cruces en 0
                nCrossings = 0;
                figure();
                hold on 
                plot(upperSpline, 'DisplayName', 'Upper Spline')
                plot(meanSpline, 'DisplayName', 'Mean Spline')
                plot(lowerSpline, 'DisplayName', 'Lower Spline')
                plot(hSig + meanSpline, 'DisplayName', 'Signal')
                title("Modo "+string(i) + " Iteración "+string(iterations + 1));
                hold off
                legend
                for j = 1:length(hSig)-1
                    if(hSig(j)*hSig(j+1) < 0)
                        nCrossings = nCrossings + 1;
                    end
                end
                
                iterations = iterations + 1;
                end
                intrinsicModes{i} = hSig;
                sig = sig - hSig;
            end
            
            residue = sig;
        end
        
        function signal = reconstructSignal(obj, residue, intrinsicModes)
              signal = residue;
              
              for i= 1:length(intrinsicModes)
                 signal = signal + intrinsicModes{i}; 
              end            
        end
        
        
        
        function [frequencies, times, hilbertSpectrum] = getHilbertSpectrum(obj, signal, nLevels, S, Fs, nFrequencies)
           [intrinsicModes,  residue] =  obj.getIntrinsicModeFunctions(signal, nLevels, S);
           mags = zeros(length(intrinsicModes), length(signal));
           freqs = zeros(length(intrinsicModes), length(signal));
           deltaT = 1/Fs;
           phaseTolerance = 0.1;
           %De una vez obtengamos aquí el arreglo de tiempos 
           times = (0:length(signal)-1)*deltaT;
           for i=1:length(intrinsicModes)
              intMode = intrinsicModes{i};
              hTransform = hilbert(intMode);
              %Creamos la versión compleja
              for j = 1:length(hTransform)
                  [mag, phase] = obj.getMagnitudeAndPhase(hTransform(j));
                  mags(i,j) = mag;
                  if(j ~= 1) 
                      [~,prevPhase] = obj.getMagnitudeAndPhase(hTransform(j-1));
                      frequency = (phase - prevPhase)/deltaT;
                      freqs(i,j) = frequency;
                  end
              end
           end
           
           for i = 1:size(freqs, 1)
              freqs(i,:) = filloutliers(freqs(i,:), 'nearest'); 
           end
           
           minFrequency = min(min(freqs));
           maxFrequency = max(max(freqs));
           disp("Min frequency "+string(minFrequency));
           disp("Max frequency "+string(maxFrequency));
           
           frequencyBinSize = (maxFrequency - minFrequency)/nFrequencies;
           frequencies = linspace(minFrequency, maxFrequency, nFrequencies);
           %Vamos a llenar el espectro de hilbert con la transformada de
           %hilbert que acabamos de calcular para cada uno de los modos  
           hilbertSpectrum = zeros(nFrequencies, length(times));
           for i= 1:length(intrinsicModes)
               spectrumOfComponent = zeros(nFrequencies, length(times));
               magnitudeArray = mags(i,:);
               frequencyArray = freqs(i,:);
               for j = 1:length(magnitudeArray)
                   timeIndex = j;
                   frequency = frequencyArray(j);
                   frequencyIndex = floor((frequency - minFrequency)/frequencyBinSize);
                   if(frequencyIndex == 0)
                      frequencyIndex = 1; 
                   end
                   %disp("Time "+string(times(timeIndex)));
                   %disp("Frequency "+string(frequencyArray(frequencyIndex)));
                   spectrumOfComponent(frequencyIndex, timeIndex) = magnitudeArray(j);                   
               end
               hilbertSpectrum = hilbertSpectrum + spectrumOfComponent;
           end
        end
        
        
        function [frequencies, times, hilbertSpectrum] = getHilbertSpectrumMaxMin(obj, signal, nLevels, S, Fs, nFrequencies, minFrequency, maxFrequency)
           [intrinsicModes,  residue] =  obj.getIntrinsicModeFunctions(signal, nLevels, S);
           mags = zeros(length(intrinsicModes), length(signal));
           freqs = zeros(length(intrinsicModes), length(signal));
           deltaT = 1/Fs;
           phaseTolerance = 0.1;
           %De una vez obtengamos aquí el arreglo de tiempos 
           times = (0:length(signal)-1)*deltaT;
           for i=1:length(intrinsicModes)
              intMode = intrinsicModes{i};
              hTransform = hilbert(intMode);
              %Creamos la versión compleja
              for j = 1:length(hTransform)
                  [mag, phase] = obj.getMagnitudeAndPhase(hTransform(j));
                  mags(i,j) = mag;
                  if(j ~= 1) 
                      [~,prevPhase] = obj.getMagnitudeAndPhase(hTransform(j-1));
                      frequency = (phase - prevPhase)/deltaT;
                      freqs(i,j) = frequency;
                  end
              end
           end
           
           for i = 1:size(freqs, 1)
              freqs(i,:) = filloutliers(freqs(i,:), 'nearest'); 
           end
           
           frequencyBinSize = (maxFrequency - minFrequency)/nFrequencies;
           frequencies = linspace(minFrequency, maxFrequency, nFrequencies);
           %Vamos a llenar el espectro de hilbert con la transformada de
           %hilbert que acabamos de calcular para cada uno de los modos  
           hilbertSpectrum = zeros(nFrequencies, length(times));
           for i= 1:length(intrinsicModes)
               spectrumOfComponent = zeros(nFrequencies, length(times));
               magnitudeArray = mags(i,:);
               frequencyArray = freqs(i,:);
               for j = 1:length(magnitudeArray)
                   timeIndex = j;
                   frequency = frequencyArray(j);
                   if(frequency >= minFrequency && frequency <= maxFrequency)
                        frequencyIndex = floor((frequency - minFrequency)/frequencyBinSize);
                        if(frequencyIndex == 0)
                            frequencyIndex = 1; 
                        end
                   spectrumOfComponent(frequencyIndex, timeIndex) = magnitudeArray(j);
                   end
               end
               hilbertSpectrum = hilbertSpectrum + spectrumOfComponent;
           end
        end
        
        
        
        
        
        
        
         function [mag, phase] = getMagnitudeAndPhase(obj, number)
           realPart = real(number);
           imaginaryPart = imag(number);
           
           mag = sqrt(realPart^2 + imaginaryPart^2);
           
           phase = 0;
           if(imaginaryPart >= 0 && realPart > 0)
               phase = atan(imaginaryPart/realPart);
           elseif(realPart <0 && imaginaryPart>= 0)
               phase = pi + atan(imaginaryPart/realPart);
           elseif(realPart <0 && imaginaryPart <= 0)
               phase = -pi + atan(imaginaryPart/realPart);
           elseif(realPart >0 && imaginaryPart >= 0)
               phase = atan(imaginaryPart/realPart);
           end
        end
        
       
        
        
    end
    
    
    
    
    
    
end