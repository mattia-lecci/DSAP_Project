function emProb = get_emProb(chords, trueChordsList, predChordList)
    
    emProb = ones(size((chords),1),size((chords),1))*1e-4;

    for i = 1:size(chords)
   
        [trueChordIndex, ~] = find( trueChordsList == chords(i));
    
        for j = 1:size(trueChordIndex)
            
            index = trueChordIndex(j);
        
            y = find(chords==predChordList(index));
    
            emProb(i,y) = emProb(i,y)+1;
        end
    end
    
    for i =1:size(emProb,1)
    
        S = sum(emProb(i,:));
    
        if S ~= 0
            emProb(i,1:size(emProb,1))=emProb(i,1:size(emProb,1))/S;
        end
    end

end

