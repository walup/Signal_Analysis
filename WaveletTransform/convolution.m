function conv = convolution(signal1, signal2, deltaTime)

M = floor(length(signal1)/2);
conv = zeros(1,2*M);
for n = -M:M-1
    convResult = 0;
    for m = -M:M-1
        index1 = n-m + M + 1;
        index2 = m + M + 1;
        if(index1 > 1 && index1 < length(signal1))
            convResult = convResult + signal1(index1)*signal2(index2)*deltaTime;
        end    
    end
    conv(n + M +1) = convResult;
end

end