function [songFeatures, songFrameLengths] = extractSongsFeatures(path,names)

    songFeatures = {size(names,2),2};
    songFrameLengths = zeros(size(names,2),1);

    for i=1:size(names,2)
        [song1, Fs] = audioread(fullfile(path,names{i}));
        audiowrite('wavsong.wav',song1,Fs);
        [f_audio,sideinfo] = wav_to_audio('', '', 'wavsong.wav');
        delete 'wavsong.wav';

        parameter = struct();
        
        [f_pitch,sideinfo] = audio_to_pitch_via_FB(f_audio,parameter,sideinfo);
        
        [f, ~] = pitch_to_chroma(f_pitch,parameter,sideinfo);
        
        songFeatures{i,1}=names{i};
        songFeatures{i,2}=f;
        songFrameLengths(i)=size(f,2);
        
    end
end