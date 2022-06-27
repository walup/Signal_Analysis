classdef DiscreteWaveletTransform
    
   
    methods
        
        function [details, base] = computeDWT(obj, waveletType, signal, levels)
            nearestPower = floor(log2(length(signal))) + 1;
            if(2^(nearestPower)  - length(signal)>0 && 2^(nearestPower - 1)~= length(signal))
                zerosToAdd = 2^(nearestPower) - length(signal);
                for i = 1:zerosToAdd
                   signal = [signal; 0]; 
                end
            end
          
            details = {};
            wb = WaveletBuilder();
            [filterLowPass, filterHighPass] = wb.getDecompositionFilterCoefficients(waveletType);
            filterer = Filterer();
            sig = signal;
            for i = 1:levels
                hiSignal = filterer.applyFIRFilter(sig, filterHighPass);
                loSignal = filterer.applyFIRFilter(sig, filterLowPass);
                
                details{i} = hiSignal(2:2:length(hiSignal));
                sig = loSignal(2:2:length(loSignal));
            end
            
            base = sig;
        end
        
        
         function [details, base] = computeDWTNoSampling(obj, waveletType, signal, levels)
            nearestPower = floor(log2(length(signal))) + 1;
            if(2^(nearestPower)  - length(signal)>0 && 2^(nearestPower - 1)~= length(signal))
                zerosToAdd = 2^(nearestPower) - length(signal);
                for i = 1:zerosToAdd
                   signal = [signal; 0]; 
                end
            end
          
            details = {};
            wb = WaveletBuilder();
            [filterLowPass, filterHighPass] = wb.getDecompositionFilterCoefficients(waveletType);
            filterer = Filterer();
            sig = signal;
            for i = 1:levels
                hiSignal = filterer.applyFIRFilter(sig, filterHighPass);
                loSignal = filterer.applyFIRFilter(sig, filterLowPass);
                
                details{i} = hiSignal;
                sig = loSignal;
            end
            
            base = sig;
        end
        
        function signal = reconstructDWT(obj, waveletType, details, base)
            
            levels = length(details);
            signal = base;
            filterer = Filterer();
            wb = WaveletBuilder();
            [filterLowPass, filterHighPass] = wb.getReconstructionFilterCoefficients(waveletType);
            
            for i = 1:levels
                index = levels - i + 1;
                detail = details{index};
                %Llenamos de 0s el detalle 
                newDetail = zeros(2*length(detail), 1);
                newDetail(1:2:length(newDetail)) = detail;
                %Filtramos el detalle con el pasa altas
                %newDetail = filter(filterHighPass, [1,0,0,0], newDetail);
                newDetail = filterer.applyFIRFilter(newDetail, filterHighPass);
                %Llenamos de 0s la señal 
                %disp("Detalle");
                %disp(newDetail);
                newSignal = zeros(2*length(signal), 1);
                newSignal(1:2:length(newSignal)) = signal;
                %Filtramos la señal con el pasa bajas
                %newSignal = filter(filterLowPass, [1,0,0,0], newSignal);
                newSignal = filterer.applyFIRFilter(newSignal, filterLowPass);
                %disp("Señal");
                %disp(newSignal);
                signal = newSignal + newDetail;
            end
        end
    end
    
    
    
    
end