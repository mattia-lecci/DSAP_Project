function songLabels = extractSongsLabels(path, names, numberFrame)

    songLabels = {size(names,2),2};
    
    for i=1:size(names,2)
        
        table = readtable(fullfile(path,names{i}), 'Delimiter', ' ','ReadVariableNames',false);
        songDuration = table{size(table,1),2};
        frameDuration = songDuration/numberFrame(i); 
        
        time = 0.000001;
        k=1;
        
        labels = categorical(1,numberFrame(i));
        
        while time<songDuration
            while time <table{k,2}
                labels(k) = categorical(table{k,3});
                time = time + frameDuration;
            end
            k=k+1;
        end
        
        songLabels{i,1} = names{i};
        songLabels{i,2} = labels;
        
        disp(songLabels);
    
    end    
end