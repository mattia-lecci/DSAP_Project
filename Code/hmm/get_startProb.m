function startProb = get_startProb(chords, songs, chordsList, songsList)

    startProb = ones(1,size((chords),1))*1e-4;


    for i = 1:size(songs)
        
        newsong = songs(i);
    
        indexSong = songsList == newsong; 
    
        newsong_chords = chordsList(indexSong);
    
        for k = 1:size(chords)
   
            if newsong_chords(1)==chords(k)
            
                startProb(1,k)=startProb(1,k)+1;
                
            end
            
        end    
    end

    %Normalize the probabilities

    S = sum(startProb(1,:));
    
    if S ~= 0
        startProb(1,1:size(startProb,2))=startProb(1,1:size(startProb,2))/S;
    end
    
end

