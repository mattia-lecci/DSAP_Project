function emProb = get_emProb(chords, trueChordsList, predChordList)
    
    emProb = zeros(size((chords),1),size((chords),1));

    for i = 1:size(chords)
   
        [trueChordIndex, ~] = find( trueChordsList == chords(i));
    
        for j = 1:size(chords)
        
            [predChordIndex, ~] = find(predChordList(trueChordIndex)==chords(j));
    
            emProb(i,j) = size(predChordIndex)/size(trueChordIndex);
        end
    end

end

