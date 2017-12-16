function [songFeatures, songFrameLengths] = extractSongsFeatures_CLP(path,names)

    songFeatures = {size(names,2),2};
    songFrameLengths = zeros(size(names,2),1);
    
    j=1;

    for i=1:size(names,2)
        [song1, Fs] = audioread(fullfile(path,names{i}));
        audiowrite('wavsong.wav',song1,Fs);
        [f_audio,sideinfo] = wav_to_audio('', '', 'wavsong.wav');
        delete 'wavsong.wav';
        
        shiftFB = estimateTuning(f_audio);
    
        paramPitch = struct();
        paramPitch.winLenSTMSP = 44100;
        paramPitch.shiftFB = shiftFB;

        paramCLP = getCLPParam();
        
        [f_pitch,sideinfo] = audio_to_pitch_via_FB(f_audio,paramPitch,sideinfo);
        
        [f, ~] = pitch_to_chroma(f_pitch,paramCLP,sideinfo);
        
        l = size(f,2);
        
        for k=j:(j+l-1)
        
            songFeatures(k,1)=names(i);
        
            songFeatures(k,2)={f(:,k-j+1)};
        
        end
            
        songFrameLengths(i)=size(f,2);
        
        j=j+l;
        
    end
end

%% utility functions

function param = getCENSParam()
param.winLenSmooth = 21;
param.downsampSmooth = 5;
end


function param = getCRPParam()
param.coeffsToKeep = [55:120];
end

function param = getCLPParam()
param.applyLogCompr = 1;
param.factorLogCompr = 100;
end