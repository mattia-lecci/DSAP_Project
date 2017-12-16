function smooth = getSmooth(song)
    l = length(song);
    oldChord = song(1);
    smooth = 0;
    for i = 1:l
        newChord = song(i);
        if (newChord~=oldChord)
            oldChord = newChord;
            smooth = smooth+1;
        end
    end
end