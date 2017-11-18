clear variables
close all
clc

%% init
% paths
addpath('init','Utilities','SVM','GaussianMixture')

% parameters
trainPerc = .7;
mat2vecFunc = @(x)max(x,[],2);
kernel = 'polynomial';

% flags
performFeatureExtraction = false;

% feature extraction
if performFeatureExtraction
    % extract names and chords labels
    
    chordTable = getNameChordTable('wavs');
    CLP_features = extractBatchFeatures(chordTable.Path,'CLP',mat2vecFunc);
    CENS_features = extractBatchFeatures(chordTable.Path,'CENS',mat2vecFunc);
    CRP_features = extractBatchFeatures(chordTable.Path,'CRP',mat2vecFunc);
    
    save('Save/init','chordTable','CLP_features','CENS_features','CRP_features')
else
    load 'Save/init';
end

% train/test separation
Ntot = size(chordTable,1);

[trainIdx,~,testIdx] = dividerand(Ntot,trainPerc,0,1-trainPerc);
trainIdx = trainIdx(randperm(length(trainIdx)));
testIdx = testIdx(randperm(length(testIdx)));

trueTestLabels = chordTable.Chord(testIdx);
%% training GAUSS

disp 'Generating CENS gaussian mixtures...'
gaussianMixtureCENS = trainGaussianMixture(chordTable.Chord(trainIdx),createDataMatrix(CENS_features(trainIdx)));
disp 'Generating CLP gaussian mixtures...'
gaussianMixtureCLP = trainGaussianMixture(chordTable.Chord(trainIdx),createDataMatrix(CLP_features(trainIdx)));
disp 'Generating CRP gaussian mixtures...'
gaussianMixtureCRP = trainGaussianMixture(chordTable.Chord(trainIdx),createDataMatrix(CRP_features(trainIdx)));


%% training SVM

disp 'Training SVM with CENS features...'
mdlSvmCens = trainSVM( createDataMatrix(CENS_features(trainIdx)),...
    chordTable.Chord(trainIdx), 'KernelFunction',kernel );
disp 'Training SVM with CLP features...'
mdlSvmClp = trainSVM( createDataMatrix(CLP_features(trainIdx)),...
    chordTable.Chord(trainIdx), 'KernelFunction',kernel );
disp 'Training SVM with CRP features...'
mdlSvmCrp = trainSVM( createDataMatrix(CRP_features(trainIdx)),...
    chordTable.Chord(trainIdx), 'KernelFunction',kernel );

%% template
predChords = zero(length(testIdx),1);

for i = 1:length(predChords)
    predChords(i) = templateDecision( batchVec12{i},templateType );
    % for each template type and feature type
end

err = computeError(real,predicted);
% for each predChords

%% statistical methods (already trained)

% fit gaussian

predGaussCENS = gaussianPrediction(gaussianMixtureCENS,createDataMatrix(CENS_features(testIdx)));
predGaussCLP = gaussianPrediction(gaussianMixtureCLP,createDataMatrix(CLP_features(testIdx)));
predGaussCRP = gaussianPrediction(gaussianMixtureCRP,createDataMatrix(CRP_features(testIdx)));

% compute errors
errorGaussCens = computeError(trueTestLabels,predGaussCENS);
errorGaussClp = computeError(trueTestLabels,predGaussCLP);
errorGaussCrp = computeError(trueTestLabels,predGaussCRP);

%%

% fit models
predSvmCens = mdlSvmCens.predict( createDataMatrix(CENS_features(testIdx)) );
predSvmClp = mdlSvmClp.predict( createDataMatrix(CLP_features(testIdx)) );
predSvmCrp = mdlSvmCrp.predict( createDataMatrix(CRP_features(testIdx)) );
% compute errors
errorSvmCens = computeError(trueTestLabels,predSvmCens);
errorSvmClp = computeError(trueTestLabels,predSvmClp);
errorSvmCrp = computeError(trueTestLabels,predSvmCrp);

%% display/plot

disp 'Error evaluation with gaussian mixture:'
fprintf('Gaussian with CENS features error: %.2f%%\n',errorGaussCens*100);
fprintf('Gaussian with CLP features error: %.2f%%\n',errorGaussClp*100);
fprintf('Gaussina with CRP features error: %.2f%%\n',errorGaussCrp*100);

disp 'Error evaluation with SVM:'
fprintf('SVM with CENS features error: %.2f%%\n',errorSvmCens*100);
fprintf('SVM with CLP features error: %.2f%%\n',errorSvmClp*100);
fprintf('SVM with CRP features error: %.2f%%\n',errorSvmCrp*100);
% grid on


%% HIDDEN MARKOV MODEL

%% init
addpath('hmm', 'beatles_dataset', 'MATLAB-Chroma-Toolbox_2.0');

trainingAlbums = {'Please please me' 'With The Beatles'};
testAlbum = {};

j=0;

performFeatureExtractionHMM = true;

if performFeatureExtractionHMM

    for i=1:size(trainingAlbums,2)
        audioList =  dir(fullfile('beatles_dataset\',trainingAlbums{i},'\*.mp3'));
        audioSongNames = {audioList.name};
    
        %I obtain a cell contained name of the song + features per song + number of frame per song
    
        [albumFeatures, songLengths] = extractSongsFeatures(fullfile('beatles_dataset\',trainingAlbums{i},'\'),audioSongNames);
        disp('Album features extraction finished!');
    
        %Extraction of the chord features of the songs of this album. We
        %notic ethat we focus on the CENS paramters, since we conclude that
        %it was the best one
    
        labelList =  dir(fullfile('beatles_dataset\',trainingAlbums{i},'\*.txt'));
        labelSongNames = {labelList.name};
    
        %Extraction of the chord label of the songs of this album
    
        albumLabels = extractSongsLabels(fullfile('beatles_dataset\',trainingAlbums{i},'\'),labelSongNames, songLengths);
        disp('Album label extraction finished!');
    
        % I obtain a cell array in which in the first column I have the name of
        % the song, in the secon the features per frame, in the third the chord
        % label as the database said.
    
        trainDiscographyFeatures((j+1):(j+size(albumFeatures,1)),1:2)=albumFeatures;
        trainDiscographyChords((j+1):(j+size(albumLabels,1)),1:2)=albumLabels;
    
        j=j+size(albumLabels,1);
        
        save('Save/initHMM','trainDiscographyFeatures','trainDiscographyChords');
    
    end
    
else
    load 'Save/initHMM';
end

%% Training with SVM

kernel = 'polynomial';

trainDiscographyFeatures = trainDiscographyFeatures(:,2);
trainDiscographyChordsTable = cell2table(trainDiscographyChords);

[rightIndex, ~] = find(trainDiscographyChordsTable.trainDiscographyChords2 ~= 'N');

trainDiscographyFeatures = trainDiscographyFeatures(rightIndex);
trainDiscographyChordsTable = cell2table(trainDiscographyChords(rightIndex,:));


disp 'Training SVM with CENS features...'
mdlSvmCens = trainSVM( createDataMatrix(trainDiscographyFeatures),...
    trainDiscographyChordsTable.Var2, 'KernelFunction',kernel );


%% Computing emission probabiities

trueTestLabels = removecats( trainDiscographyChordsTable.Var2);

predSvmCens = mdlSvmCens.predict( createDataMatrix(trainDiscographyFeatures));

listTrueChords = categories(trueTestLabels);

% Matrix numChord x numChord
% p(i,j) = Prob(J|I)

emissionProb = zeros(size((listTrueChords),1),size((listTrueChords),1));

disp 'Computing emission probability...'

for i = 1:size(listTrueChords)
   
    [trueChordIndex, ~] = find( trueTestLabels == listTrueChords(i));
    
    for j = 1:size(listTrueChords)
        
        [predChordIndex, ~] = find(predSvmCens(trueChordIndex)==listTrueChords(j));
    
        emissionProb(i,j) = size(predChordIndex)/size(trueChordIndex);
    end
end


%% Computing transition probabilities

trainDiscographyAlbum = categorical(trainDiscographyChordsTable.Var1);

listSong = categories(trainDiscographyAlbum);

transProb = zeros(size((listTrueChords),1),size((listTrueChords),1));

disp 'Computing transition probabilities';

for i = 1:size(listSong)
    
    newsong = listSong(i);
    
    indexSong = find(trainDiscographyAlbum == newsong); 
    
    songLabel = trueTestLabels(indexSong);
    
    for k = 1:size(listTrueChords)
   
        [indexChordStart, ~] = find( songLabel == listTrueChords(k));
    
        for j = 1:size(indexChordStart)
            
            indexFrom = indexChordStart(j);
            
            indexTo = indexChordStart(j)+1;
            
            if (indexTo<size(songLabel,1)) & (songLabel(indexFrom)~=songLabel(indexTo))
                
                y = find(listTrueChords==songLabel(indexTo));
                
                transProb(k,y) = transProb(k,y)+1;
            
            end
        end
    end    
end

%Normalize the probabilities

for i =1:size(transProb,1)
    
    S = sum(transProb(i,:));
    
    if S ~= 0
        transProb(i,1:size(transProb,1))=transProb(i,1:size(transProb,1))/S;
    end
end



