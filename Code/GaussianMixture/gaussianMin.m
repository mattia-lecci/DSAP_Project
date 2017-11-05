function min = gaussianMin(gaussMixture, obj)
    
    d_min = gaussianDistance(gaussMixture{1}, obj);
    
    min = 'A';
    
    chordlist = {'A';'Am';'Bm';'C';'D';'Dm';'E';'Em';'F';'G'};
    
    chordlist = categorical(chordlist);
    
    for i=2:10 
        
        d_new=gaussianDistance(gaussMixture{i}, obj);
        
        if (d_new<d_min)
            
            d_min=d_new;
            min=chordlist(i);
        end
    end
end