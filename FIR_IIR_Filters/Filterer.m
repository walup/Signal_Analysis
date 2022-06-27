classdef Filterer
    
    methods
        
        function y = applyIIRFilter(obj,x,aCoeffs, bCoeffs) 
            M = length(bCoeffs);
            N = length(aCoeffs);
            y = zeros(length(x), 1);
            for i = max(M,N)+1:length(x)
               yValue = 0;
               for j = 1:M
                  yValue = yValue + bCoeffs(j)*x(i-j+1); 
               end
               
               for j = 1:N
                  yValue = yValue - aCoeffs(j)*y(i-j); 
               end
               
               y(i) = yValue;
            end
           
        end
        
        %Para los filtros FIR podemos usar IIR sin los coeficientes
        %que se aplican a puntos pasados de la señal filtrada
        function y = applyFIRFilter(obj, x, bCoeffs)
            y = obj.applyIIRFilter(x, [], bCoeffs);
        end
        
    end
    
    
    
    
    
end