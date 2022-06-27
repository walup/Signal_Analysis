classdef MotherWavelet
    
methods
    function [tArray,y] = getHaarMotherWavelet(obj, n, tMin, tMax)
        tArray = linspace(tMin,tMax,n);
        y = zeros(n,1);
        tMid = (tMin + tMax)/2;
        for i = 1:n
           if(tArray(i) <=tMid)
              y(i) = 1;
           else if(tArray(i) >= tMid)
               y(i) = -1;
           end
        end
    end        
    end
    
    function [newTArray, y] = translateAndScale(obj, signal, u, s, tArray)
        newTArray = zeros(length(tArray));
        y = zeros(length(tArray));
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