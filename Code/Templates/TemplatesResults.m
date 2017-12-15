function  [A,B] = TemplatesResults(F,chordTable)



predChords1 = F; %Antes testIdx
predChords2 = F;
predChords3 = F;
predChords4 = F;
predChords5 = F;
predChords6 = F;

%Test:
% A = batchVec12{1,1}'; Este da....
% REssss = templateDecision(A,1)

batchVec12 = F;
for templateType = 1:2
    if templateType == 1
        for i = 1:length(predChords1)
            batchIntermediate = batchVec12{i,1}';
        [predChords1(i),predChords2(i),predChords3(i)] = templateDecision(batchIntermediate,templateType );
        % for each template type and feature type
        end
    else 
       for i = 1:length(predChords1)
            batchIntermediate = batchVec12{i,1}';
        [predChords4(i),predChords5(i),predChords6(i)] = templateDecision(batchIntermediate,templateType ); 
        end
    end
end
check1 = categorical(predChords1);
check2 = categorical(predChords2);
check3 = categorical(predChords3);
check4 = categorical(predChords4);
check5 = categorical(predChords5);
check6 = categorical(predChords6);


err1 = computeError(chordTable{:,2},check1);
A = computeError(chordTable{:,2},check2);
err3 = computeError(chordTable{:,2},check3);

err4 = computeError(chordTable{:,2},check4);
B = computeError(chordTable{:,2},check5);
err6 = computeError(chordTable{:,2},check6);




end


% for each predChords
