classdef SpectrogramPlotter
  properties
     windowType;
     windowPoints;
     overlap;
     description;
  end
  
   methods
       function obj = SpectrogramPlotter(windowType, windowPoints, overlap)
           obj.windowType = windowType;
           obj.windowPoints = windowPoints;
           obj.overlap = overlap;
           
           obj.description = "Descripción "+newline + "-----------------"+newline;
           obj.description = obj.description + "Tipo de ventana: "+string(obj.windowType) + newline;
           obj.description = obj.description + "Puntos en la ventana: "+ string(obj.windowPoints) + newline;
           obj.description = obj.description + "Porcentaje de traslape: " + string(obj.overlap) + newline;
       end
       
       function y = plotMagnitudeSpectrogram(obj, signal, tArray)
           disp(obj.description);
           sdftCalculator = SDFTCalculator();
           [times, freqs, sdft] = sdftCalculator.computeSDFT(signal, tArray, obj.windowType, obj.windowPoints, obj.overlap);
           halfIndex = floor(size(freqs, 2)/2);
           freqs = freqs(1:halfIndex);
           sdft = sdft(1:halfIndex, :);
           y = figure();
           imagesc(times, freqs, 2*abs(sdft))
           title("Espectrograma magnitud")
           xlabel("Tiempo")
           ylabel("Frequencia [Hz]")
           set(gca,'YDir','normal')
           colorbar
       end
       
       
       function y = plotDecibelSpectrogram(obj, signal, tArray)
           disp(obj.description);
           sdftCalculator = SDFTCalculator();
           [times, freqs, sdft] = sdftCalculator.computeSDFT(signal, tArray, obj.windowType, obj.windowPoints, obj.overlap);
           halfIndex = floor(size(freqs, 2)/2);
           freqs = freqs(1:halfIndex);
           sdft = sdft(1:halfIndex, :);
           sdftDecibels = 20*log10(2*abs(sdft));
           y = figure();
           imagesc(times, freqs, sdftDecibels);
           title("Espectrograma Decibeles")
           xlabel("Tiempo")
           ylabel("Frecuencia [Hz]")
           set(gca,'YDir','normal')
           colorbar
       end
       
   end
    
    
    
end