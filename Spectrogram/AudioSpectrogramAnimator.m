classdef AudioSpectrogramAnimator
   properties
       windowType;
       windowSize;
       overlap;
   end
   
   methods
       function obj = AudioSpectrogramAnimator(windowType, windowSize, overlap)
           obj.windowType = windowType;
           obj.windowSize = windowSize;
           obj.overlap = overlap;
       end
       
       function y = animateAudioSpectrogram(obj, fsAudio, audioSignal, audioSignalInt, fps, fileName, fMin, fMax)
           tArray = (0:length(audioSignal)-1)*(1/fsAudio);
           audioStep = fsAudio/fps;
           disp(audioStep);
           videoWriter = vision.VideoFileWriter('Filename',fileName,'FileFormat','avi', 'FrameRate', fps, 'AudioInputPort', true, 'AudioDataType', 'int16');
           %videoWriter.VideoCompressor = 'MJPEG Compressor';
           sdftCalculator = SDFTCalculator();
           [times, freqs, sdft] = sdftCalculator.computeSDFT(audioSignal, tArray, obj.windowType, obj.windowSize, obj.overlap);
           barWidth = 0.1;
           barHeight = (fMax - fMin + 20);
           b = waitbar(0,'Renderizando');
           l = floor((fps*length(audioSignal)/fsAudio));
           figure()
           for i = 1:(fps*length(audioSignal)/fsAudio)
               waitbar(i/l,b,"Renderizando")
               audioIndexBeginning = floor((i - 1)*audioStep) + 1;
               audioIndexEnding = ceil(audioIndexBeginning + audioStep - 1);
               audioSegment = audioSignalInt(audioIndexBeginning:audioIndexEnding);
               currentTime = (tArray(audioIndexBeginning) + tArray(audioIndexEnding))/2;
               clf();
               hold on 
               imagesc(times, freqs, abs(sdft))
               rectangle('Position', [currentTime, 0, barWidth, barHeight], 'FaceColor', [36/255, 186/255, 255/255, 0.5],'EdgeColor', 'none')
               ylim([fMin, fMax]);
               xlim([times(1), times(end)])
               hold off
               frame = getframe(gcf);
               step(videoWriter, frame.cdata, audioSegment);
           end
           release(videoWriter)
           close(b);
       end
   end
   
   
   
    
    
    
    
    
    
end