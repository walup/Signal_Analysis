classdef SDFTCalculator
    
    methods
        
        function [times, freqs, sdft] = computeSDFT(obj, signal,timeArray,windowType,windowPoints,overlapPercentage)
            N = length(signal);
            %Número de puntos de traslape
            nOverlap = overlapPercentage*windowPoints;
            startPoints = 1:windowPoints - nOverlap:N;
            %Cortamos el exceso
            finalIndex = 1;
            
            for i = 1:length(startPoints)
                if(startPoints(i) + windowPoints < N)
                   finalIndex = i;
                end
            end
            
            startPoints = startPoints(1:finalIndex);
            sdft = zeros(windowPoints,length(startPoints));
            fftCalculator = FFTCalculator();
            %Obtenemos nuestra ventana
            windowCalculator = WindowCalculator();
            window = windowCalculator.getWindow(windowType, windowPoints);
            %Ahora calculamos la transformada de fourier de tiempo corto 
            times = zeros(1,length(startPoints));
            for i = 1:length(startPoints)
                startPoint = startPoints(i);
                %disp(length(signal(startPoint:startPoint + windowPoints-1)));
                %disp(length(window));
                signalWindow = signal(startPoint:startPoint + windowPoints-1).*window;
                [~,sdft(:,i)] = fftCalculator.FFT(1:windowPoints, signalWindow);
                times(i) = timeArray(startPoint);
            end
            fs = 1/(timeArray(2) - timeArray(1));
            frequencies = (0:N-1)*fs/N;
            
            deltaF = floor(N/windowPoints);
            freqs = frequencies(1:deltaF:N);
            freqs = freqs(1:windowPoints);
        end
    end
end