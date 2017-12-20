%From the data in chordTable and in Features I create 10 gaussian mixture,
%one for each set of notes

function gaussianMixture = trainGaussianMixture(chord, features)

    
    chordFeaturesTable = table(chord, features);
    
    %This cell array is empty at the beginning
    
    gaussianMixture = cell(10,1);
    
    %I get the 10 different notes
    
    chordlist = {'A';'Am';'Bm';'C';'D';'Dm';'E';'Em';'F';'G'};
    
    %I create a new gaussian for each new note and I save it the cell array
    %previously created
        
    for i=1:(length(chordlist))
        newnote = chordlist{i};
        
        cellnote = table2cell(chordFeaturesTable(chordFeaturesTable.chord==newnote,:));
        
        cellnote = cellnote(:,2);
        
        data = cell2mat(cellnote);
        
        newgaussian = fitgmdist(data,1);
        
        gaussianMixture{i}=newgaussian;
    end
    
end