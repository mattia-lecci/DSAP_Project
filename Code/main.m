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

clear all

addpath('init','Utilities','SVM','GaussianMixture')
addpath('hmm', 'beatles_dataset', 'MATLAB-Chroma-Toolbox_2.0');

trainingAlbums = {'Please please me' 'With The Beatles'};
testingAlbums = { 'Test' };

j1=0;

j2=0;

performTrainFeatureExtractionHMM = false;

if performTrainFeatureExtractionHMM

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
    
        albumLabels = extractSongsChords(fullfile('beatles_dataset\',trainingAlbums{i},'\'),labelSongNames, songLengths);
        disp('Album label extraction finished!');
    
        % I obtain a cell array in which in the first column I have the name of
        % the song, in the secon the features per frame, in the third the chord
        % label as the database said.
    
        trainDiscographyFeatures((j1+1):(j1+size(albumFeatures,1)),1:2)=albumFeatures;
        trainDiscographyChords((j1+1):(j1+size(albumLabels,1)),1:2)=albumLabels;
    
        j1=j1+size(albumLabels,1);
    
    end
    
    disp 'Saving train data...'
    
    trainDiscographyFeatures = trainDiscographyFeatures(:,2);
    trainDiscographyChords = cell2table(trainDiscographyChords);
    
    [rightIndex, ~] = find(trainDiscographyChords.trainDiscographyChords2 ~= 'N');

    trainDiscographyFeatures = trainDiscographyFeatures(rightIndex);
    trainDiscographyChords = trainDiscographyChords(rightIndex,:);
    
    trainDiscographyChords.trainDiscographyChords2 = removecats(trainDiscographyChords.trainDiscographyChords2);
        
    true_trainChordsList = trainDiscographyChords.trainDiscographyChords2;
    
    trainSongsList = categorical(trainDiscographyChords.trainDiscographyChords1);
    
   	trainSongs = categories(trainSongsList);
    
    chords = categories(true_trainChordsList);
    
    save('Save/initTrainHMM','trainDiscographyFeatures','trainDiscographyChords', 'chords', 'true_trainChordsList', 'trainSongs', 'trainSongsList');
    
else
    
    disp 'Loading train data...'
    
    load 'Save/initTrainHMM';
end

performTestFeatureExtractionHMM = true;

if performTestFeatureExtractionHMM

    for i=1:size(testingAlbums,2)
        audioList =  dir(fullfile('beatles_dataset\',testingAlbums{i},'\*.mp3'));
        audioSongNames = {audioList.name};
    
        %I obtain a cell contained name of the song + features per song + number of frame per song
    
        [albumFeatures, songLengths] = extractSongsFeatures(fullfile('beatles_dataset\',testingAlbums{i},'\'),audioSongNames);
        disp('Album features extraction finished!');
    
        %Extraction of the chord features of the songs of this album. We
        %notic ethat we focus on the CENS paramters, since we conclude that
        %it was the best one
    
        labelList =  dir(fullfile('beatles_dataset\',testingAlbums{i},'\*.txt'));
        labelSongNames = {labelList.name};
    
        %Extraction of the chord label of the songs of this album
    
        albumLabels = extractSongsChords(fullfile('beatles_dataset\',testingAlbums{i},'\'),labelSongNames, songLengths);
        disp('Album label extraction finished!');
    
        % I obtain a cell array in which in the first column I have the name of
        % the song, in the secon the features per frame, in the third the chord
        % label as the database said.
    
        testDiscographyFeatures((j2+1):(j2+size(albumFeatures,1)),1:2)=albumFeatures;
        testDiscographyChords((j2+1):(j2+size(albumLabels,1)),1:2)=albumLabels;
    
        j2=j2+size(albumLabels,1);
    
    end
    
    disp 'Saving test data...'

    testDiscographyFeatures = testDiscographyFeatures(:,2);
    testDiscographyChords = cell2table(testDiscographyChords);

    [rightIndex, ~] = find(testDiscographyChords.testDiscographyChords2 ~= 'N');

    testDiscographyFeatures = testDiscographyFeatures(rightIndex);
    testDiscographyChords = testDiscographyChords(rightIndex,:);
    
    testDiscographyChords.testDiscographyChords2 = removecats(testDiscographyChords.testDiscographyChords2);
        
    true_testChordsList = testDiscographyChords.testDiscographyChords2;
    
    testSongsList = categorical(testDiscographyChords.testDiscographyChords1);
    
   	testSongs = categories(testSongsList);
    
    save('Save/initTestHMM','testDiscographyFeatures','testDiscographyChords','true_testChordsList', 'testSongs', 'testSongsList');
    
else
    
    disp 'Loading test data..'
    
    load 'Save/initTestHMM';
end


%% Training with SVM

kernel = 'polynomial';

disp 'Training SVM with CENS features...'
mdlSvmCens = trainSVM( createDataMatrix(trainDiscographyFeatures),...
    true_trainChordsList, 'KernelFunction',kernel );


%% Predict with SVM

disp 'Testing SVM with CENS features...'

pred_trainChordList = mdlSvmCens.predict( createDataMatrix(trainDiscographyFeatures));

%% Computation emission probabilities

disp 'Computing emission probabilities...'

% Matrix numChord*numChord

emProb = get_emProb(chords, true_trainChordsList, pred_trainChordList);


%% Computing transition probabilities

disp 'Computing transition probabilities...';

% Matrix numChord*numChord

transProb = get_transProb(chords, trainSongs, true_trainChordsList, trainSongsList );


%% Computing start probabilities


disp 'Computing starting probabilities....';

% Row with lenght equal to the chord number

startProb = get_startProb(chords, trainSongs, true_trainChordsList, trainSongsList );

    

%% TESTING

disp 'Computing performance...'

%The first row of the vector shows error with HMM system, the second row
%without HMM system

error_HMM = zeros(2,size(testSongs,2));

for i=1:size(testSongs)
    
    song = testSongs(i);
    
    indexSong = find(testSongsList == song);
    
    obs = mdlSvmCens.predict( createDataMatrix(testDiscographyFeatures(indexSong)));
    
    numeric_obs = zeros(1,size(obs,1));
    
    for j=1:size(chords)
    
        [indexChords, ~] = find(obs==chords(j));
    
        numeric_obs(indexChords)=j;
    
    end    

    states = rot90(chords);

    [total, argmax, valmax] = forward_viterbi(numeric_obs,states,startProb,transProb,emProb);
    
    argmax = argmax(1:(size(argmax,2)-1));
    

    error_HMM(1,i) = computeError(true_testChordsList(indexSong),categorical(argmax));
    error_HMM(2,i) = computeError(true_testChordsList(indexSong),obs);
    
end





