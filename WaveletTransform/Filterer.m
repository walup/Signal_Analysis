classdef Filterer
    
    methods
        
        function y = applyIIRFilter(obj,x,aCoeffs, bCoeffs) 
            M = length(bCoeffs);
            N = length(aCoeffs);
            y = zeros(length(x), 1);
            extendedX = [zeros(max(M,N)-1, 1); x];
            extendedY = [zeros(max(M,N), 1); y];
            for i = max(M,N):length(extendedX)
               yValue = 0;
               for j = 1:M
                  yValue = yValue + bCoeffs(j)*extendedX(i-j+1); 
               end
               
               for j = 1:N
                  if(i - j >= 1)
                    yValue = yValue - aCoeffs(j)*extendedY(i-j); 
                  end
               end
               
               extendedY(i+1) = yValue;
            end
            y = extendedY(max(M,N) + 1: end);
        end
        
        %Para los filtros FIR podemos usar 
        function y = applyFIRFilter(obj, x, bCoeffs)
            y = obj.applyIIRFilter(x, [], bCoeffs);
        end
        
    end
    
    
    
    
    
end