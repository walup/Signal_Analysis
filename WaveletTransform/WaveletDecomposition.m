classdef WaveletDecomposition
   properties
       
       
       
   end
   
   
   methods
      
       function [levelSignals] = daubechies1Decompose(obj, signal, nLevels)
          levelSignals = {};
          [LoD,HiD,LoR,HiR] = wfilters('db1');
          filterer = Filterer();
          sig = signal;
          for i = 1:nLevels
              
              hiSignal = filterer.applyFIRFilter(sig, HiD);
              loSignal = filterer.applyFIRFilter(sig, LoD);
              
              
              levelSignals{i} = hiSignal(1:2:length(hiSignal));
              sig = loSignal(1:2:length(loSignal));
          end
          levelSignals{nLevels + 1} = sig; 
          
       end
       
       
       function signal = waveletRecomposition(obj, levelSignals)
           
           nSignals = length(levelSignals);
           N = 2*length(levelSignals{1});
           for i = 1:nSignals
               component = zeros(N,1);
               for j = 1:N
                  if(mod(j,2) ~= 0)
                      index1 = fix(j/2) + 1;
                      index2 = index1 + 1;
                      
                  else
                      component(j)
                  end
                   
               end
               
               
           end
           
           
       end
       
       
   end
    
    
    
    
end