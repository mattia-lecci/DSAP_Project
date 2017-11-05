function min = gaussianMin(obj, gaussMixture)

    %Check if the input parameters are correct
    
    p = inputParser;
    p.addRequired('gaussMixture',@(x)validateattributes(x,{'cell'},{'size',[10,1]}));
    p.addRequired('value',@(x) validateattributes(x,{'numeric'},{'size',[12,1]}));
    p.parse(gaussdistribution, value);
    
    d_min = gaussianDistance(obj,gaussMixture(1,1));
    
    min = 'A';
    
    chordlist = {'A';'Am';'Bm';'C';'D';'Dm';'E';'Em';'F';'G'};
    
    chordlist = categorical(chordlist);
    
    for i=2:10 
        d_new=gaussianDistance(obj,gaussMixture(i));
        if (d_new<d_min)
            d_min=d_new;
            min=chordlist(i);
        end
    end
end