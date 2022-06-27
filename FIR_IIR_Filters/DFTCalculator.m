classdef DFTCalculator
    
    
    properties
        
        
        
    end
    
    
    methods
        function [freqs, dft] = DFT(obj, times, signal)
            N = length(signal);
            dft = [];
            for k = 0:N-1
                ak = 0;
                for n = 0:N-1
                    ak = ak + signal(n+1)*exp(-1j*k*(2*pi/N)*n);
                end
                dft = [dft, ak];
            end
            fs = 1/(times(2) - times(1));
            freqs = (0:N-1)*fs/N;
        end
        
        function [t, signal] = IDFT(obj, freqs, transform)
            N = length(freqs);
            fs = freqs(end);
            t = (0:N-1)*(1/fs);
            
            signal = [];
            for n = 0:N-1
                xn = 0;
                for k = 0:N-1
                    xn = xn + (1/N)*transform(k+1)*exp(1j*(2*pi/N)*k*n);
                end
                signal = [signal, xn];
            end
        end
    end
    
    
    
end