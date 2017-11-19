function transProb = get_transProb(chords, songs, chordList, songsList )

    transProb = zeros(size((chords),1),size((chords),1));

    for i = 1:size(songs)
    
    newsong = songs(i);
    
    indexSong = songsList == newsong; 
    
    newsong_chords = chordList(indexSong);
    
    for k = 1:size(chords,1)
   
        [indexChordStart, ~] = find( newsong_chords == chords(k));
    
        for j = 1:size(indexChordStart)
            
            indexFrom = indexChordStart(j);
            
            indexTo = indexChordStart(j)+1;
            
            if (indexFrom<size(newsong_chords,1))
                
                y = find(chords==newsong_chords(indexTo));
                
                transProb(k,y) = transProb(k,y)+1;
            
            end
        end
    end    
end

%Normalize the probabilities

for i =1:size(transProb,1)
    
    S = sum(transProb(i,:));
    
    if S ~= 0
        transProb(i,1:size(transProb,1))=transProb(i,1:size(transProb,1))/S;
    end
end


end

