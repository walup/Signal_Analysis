classdef FFTCalculator
    
    methods
        function [frequencies, transform] = FFT(obj, times, signal)
            transform = fft(signal);
            fs = 1/(times(2) - times(1));
            N = length(signal);
            frequencies = (0:N-1)*fs/N;
        end
        
        function [t,signal] = IFFT(obj, freqs, transform)
            signal = ifft(transform);
            N = length(freqs);
            fs = freqs(end);
            t = (0:N-1)*(1/fs);
        end
        
        
    end
    
    
    
end