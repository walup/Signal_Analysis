classdef SpectrumPlotter
    
    properties
        
        
    end
    
    
    methods
        %El primer método es para obtener la magnitud y fase 
        %La fase está entre -pi y pi 
        
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
        
        
        function [halfFrequencies, spectrum, phases] = spectrumNormalScale(obj, time, signal)
            spectrumCalculator = FFTCalculator();
            [frequencies, transform] = spectrumCalculator.FFT(time, signal);
            halfIndex = floor(length(time)/2);
            %Nos quedamos con la mitad del espectro
            halfFrequencies = frequencies(1:halfIndex);
            halfTransform = transform(1:halfIndex);
            %Para cada uno de los elementos de la transformada vamos a
            %obtener la magnitud y la fase
            spectrum = zeros(length(halfTransform),1);
            phases = zeros(length(halfTransform), 1);
            
            for i = 1:length(halfFrequencies)
                [mag, phase] = obj.getMagnitudeAndPhase(transform(i));
                %Como estamos tomando la mitad del espectro multiplicamos
                %por 2 la magnitud, de modo que se conserve la energía.
                spectrum(i) = 2*mag;
                %Convertimos a grados de -180 a 180
                phases(i) = phase*(180/pi);
            end
            
            figure()
            subplot(2,1,1)
            plot(halfFrequencies, spectrum, "Color", "#29cdff")
            xlabel("Frecuencia [Hz]")
            ylabel("Magnitud")
            
            subplot(2,1,2)
            plot(halfFrequencies, phases, "Color", "#29cdff")
            xlabel("Frecuencia [Hz]")
            ylabel("Fase [grados]")
            
        end
        
        
        
        function [halfFrequencies, spectrum, phases] = spectrumWithLogarithmicScale(obj, time, signal)
            spectrumCalculator = FFTCalculator();
            [frequencies, transform] = spectrumCalculator.FFT(time, signal);
            halfIndex = floor(length(time)/2);
            %Nos quedamos con la mitad del espectro
            halfFrequencies = frequencies(1:halfIndex);
            halfTransform = transform(1:halfIndex);
            %Para cada uno de los elementos de la transformada vamos a
            %obtener la magnitud y la fase
            spectrum = zeros(length(halfTransform),1);
            phases = zeros(length(halfTransform), 1);
            
            for i = 1:length(halfFrequencies)
                [mag, phase] = obj.getMagnitudeAndPhase(transform(i));
                %Como estamos tomando la mitad del espectro multiplicamos
                %por 2 la magnitud, de modo que se conserve la energía. 
                spectrum(i) = 2*mag;
                %Convertimos a grados de -180 a 180
                phases(i) = phase*(180/pi);               
            end
 
            %Graficamos la magnitud y la fase
            figure()
            subplot(2,1,1)
            semilogx(halfFrequencies, spectrum, "Color", "#29cdff")
            xlabel("Frecuencia [Hz]")
            ylabel("Magnitud")
            
            subplot(2,1,2)
            semilogx(halfFrequencies, phases, "Color", "#29cdff")
            xlabel("Frecuencia [Hz]")
            ylabel("Fase [grados]")
        end
       
        
        
         function [halfFrequencies, spectrum, phases] = spectrumNormalScaleDB(obj, time, signal)
            spectrumCalculator = FFTCalculator();
            [frequencies, transform] = spectrumCalculator.FFT(time, signal);
            halfIndex = floor(length(time)/2);
            %Nos quedamos con la mitad del espectro
            halfFrequencies = frequencies(1:halfIndex);
            halfTransform = transform(1:halfIndex);
            %Para cada uno de los elementos de la transformada vamos a
            %obtener la magnitud y la fase
            spectrum = zeros(length(halfTransform),1);
            phases = zeros(length(halfTransform), 1);
            
            for i = 1:length(halfFrequencies)
                [mag, phase] = obj.getMagnitudeAndPhase(transform(i));
                %Como estamos tomando la mitad del espectro multiplicamos
                %por 2 la magnitud, de modo que se conserve la energía.
                spectrum(i) = 20*log10(2*mag);
                %Convertimos a grados de -180 a 180
                phases(i) = phase*(180/pi);
            end
            
            figure()
            subplot(2,1,1)
            plot(halfFrequencies, spectrum, "Color", "#29cdff")
            xlabel("Frecuencia [Hz]")
            ylabel("Magnitud [dB]")
            
            subplot(2,1,2)
            plot(halfFrequencies, phases, "Color", "#29cdff")
            xlabel("Frecuencia [Hz]")
            ylabel("Fase [grados]")
            
         end
        
         
          function [halfFrequencies, spectrum, phases] = spectrumWithLogarithmicScaleDB(obj, time, signal)
            spectrumCalculator = FFTCalculator();
            [frequencies, transform] = spectrumCalculator.FFT(time, signal);
            halfIndex = floor(length(time)/2);
            %Nos quedamos con la mitad del espectro
            halfFrequencies = frequencies(1:halfIndex);
            halfTransform = transform(1:halfIndex);
            %Para cada uno de los elementos de la transformada vamos a
            %obtener la magnitud y la fase
            spectrum = zeros(length(halfTransform),1);
            phases = zeros(length(halfTransform), 1);
            
            for i = 1:length(halfFrequencies)
                [mag, phase] = obj.getMagnitudeAndPhase(transform(i));
                %Como estamos tomando la mitad del espectro multiplicamos
                %por 2 la magnitud, de modo que se conserve la energía. 
                spectrum(i) = 20*log10(2*mag);
                %Convertimos a grados de -180 a 180
                phases(i) = phase*(180/pi);               
            end
 
            %Graficamos la magnitud y la fase
            figure()
            subplot(2,1,1)
            semilogx(halfFrequencies, spectrum, "Color", "#29cdff")
            xlabel("Frecuencia [Hz]")
            ylabel("Magnitud [dB]")
            
            subplot(2,1,2)
            semilogx(halfFrequencies, phases, "Color", "#29cdff")
            xlabel("Frecuencia [Hz]")
            ylabel("Fase [grados]")
        end
        
        
    end
    
    
    
    
end