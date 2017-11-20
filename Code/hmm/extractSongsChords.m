function songLabels = extractSongsChords(path, names, numberFrame)

    songLabels = {size(names,2),2};
    
    j=1;
    
    for i=1:size(names,2)
        
        table = readtable(fullfile(path,names{i}), 'Delimiter', ' ','ReadVariableNames',false);
        songDuration = table{size(table,1),2};
        frameDuration = songDuration/numberFrame(i); 
        
        time = 0.000001;
        k=1;
        w=1;
        
        labels = categorical(1,numberFrame(i));
        
        while time<songDuration
            while time <table{k,2}
                s = table{k,3};
                s =strsplit(s{1},{':','/'});
                
                ls = size(s,2);
                
                if strcmp(s(1),'Ab')
                    if ls<2
                        labels(w) = categorical(cellstr('G#'));
                    else
                        if strcmp(s(2),'min')
                            labels(w) = categorical(strcat('G#',':','min'));
                        else
                            labels(w) = categorical(cellstr('G#'));
                        end
                    end
                else
                
                    if ls<2
                        labels(w) = categorical(s(1));
                    else
                        if strcmp(s(2),'min')
                            labels(w) = categorical(strcat(s(1),':','min'));
                        else
                            labels(w) = categorical(s(1));
                        end
                    end
                end
                
                % Comment the following row to reduce chord type
                
                % labels(w) = categorical(table{k,3});
                
                time = time + frameDuration;
                w=w+1;
            end
            k=k+1;
        end
        
        l = size(labels,2);
        
        for k=j:(j+l-1)
        
            songLabels(k,1) = names(i);
            songLabels(k,2) = {labels(k-j+1)};
            
        end
        
        j=j+l;
    
    end    
end