%% HIDDEN MARKOV MODEL

clear all

%% init

addpath('init','Utilities','SVM','GaussianMixture')
addpath('hmm', 'beatles_dataset', 'MATLAB-Chroma-Toolbox_2.0');
addpath('C:\Users\Federico\OneDrive - Università degli Studi di Padova\Ingegneria delle telecomunicazioni\UPC\Digital Speech & Audio Processing\Project\MATLAB-Chroma-Toolbox_2.0');

trainingAlbums = {'Please please me' 'With The Beatles'};
testingAlbums = { 'Help' };

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





