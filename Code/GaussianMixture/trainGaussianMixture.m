%From the data in chordTable and in Features I create 10 gaussian mixture,
%one for each set of notes

function gaussianMixture = trainGaussianMixture(chord, features)

    %I create a table which contain both the name of the notes and the
    %features  
    chordFeaturesTable = table(chord,features);
    
    %This cell array is empty at the beginning
    
    gaussianMixture = cell(10,1);
    
    %I get the 10 different notes
    
    cat = categories(chordFeaturesTable.chord);
    
    %I create a new gaussina for each new note and I save it the cell array
    %previously created
        
    for i=1:(length(cat))
        newnote = cat{i};
        
        cellnote = table2cell(chordFeaturesTable(chordFeaturesTable.chord==newnote,:));
        cellnote = cellnote(:,2);
        
        matrixnote = cell2mat(cellnote);
        
        data = reshape(matrixnote,length(matrixnote)/12,12);
        
        newgaussian = fitgmdist(data,1);
        
        gaussianMixture{i}=newgaussian;
    end
    
end