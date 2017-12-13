%% HIDDEN MARKOV MODEL

close all
clear all

trainPerc = .9;

addpath('init','Utilities','SVM','GaussianMixture')
addpath('hmm', 'beatles_dataset');
albums = {'Sgt Peppers Lonety Hearts' 'Rubber Soul' 'Revolver' 'Magical Mistery Tour' 'Let It Be' 'Please please me' 'Help' 'With The Beatles' 'A Hard Days Night' 'Abbey Road' 'Beatles For Sale'};

%% init

performFeatureExtractionHMM = false;

if performFeatureExtractionHMM
    
    j1=0;

    j2=0;

    for i=1:size(albums,2)
        audioList =  dir(fullfile('beatles_dataset\',albums{i},'\*.mp3'));
        audioSongNames = {audioList.name};
    
        %I obtain a cell contained name of the song + features per song + number of frame per song
    
        [albumFeatures, songLengths] = extractSongsFeatures_CRP(fullfile('beatles_dataset\',albums{i},'\'),audioSongNames);
        disp('Album features extraction finished!');
    
        %Extraction of the chord features of the songs of this album. We
        %notic ethat we focus on the CENS paramters, since we conclude that
        %it was the best one
    
        labelList =  dir(fullfile('beatles_dataset\',albums{i},'\*.txt'));
        labelSongNames = {labelList.name};
    
        %Extraction of the chord label of the songs of this album
    
        albumLabels = extractSongsChords(fullfile('beatles_dataset\',albums{i},'\'),labelSongNames, songLengths);
        disp('Album label extraction finished!');
    
        % I obtain a cell array in which in the first column I have the name of
        % the song, in the secon the features per frame, in the third the chord
        % label as the database said.
    
        allDiscographyFeatures((j1+1):(j1+size(albumFeatures,1)),1:2)=albumFeatures;
        allDiscographyChords((j1+1):(j1+size(albumLabels,1)),1:2)=albumLabels;
    
        j1=j1+size(albumLabels,1);
    
    end
    
    allDiscographyFeatures = allDiscographyFeatures(:,2);
    allDiscographyChords = cell2table(allDiscographyChords);
    
    [rightIndex, ~] = find(allDiscographyChords.allDiscographyChords2 ~= 'N');

    allDiscographyFeatures = allDiscographyFeatures(rightIndex);
    allDiscographyChords = allDiscographyChords(rightIndex,:);
    
    allDiscographyChords.allDiscographyChords2 = removecats(allDiscographyChords.allDiscographyChords2);
        
    true_allChordsList = allDiscographyChords.allDiscographyChords2;
    
    allSongsList = categorical(allDiscographyChords.allDiscographyChords1);
    
   	allSongs = categories(allSongsList);
    
    chords = categories(true_allChordsList);
    
    disp 'Saving data...';
    
    save('Save/HMM_CRP/initHMM','allDiscographyFeatures','allDiscographyChords', 'true_allChordsList', 'allSongs', 'allSongsList', 'chords');
    
end

%% Split train and test data

performSplitDataHMM = true;
    
if performSplitDataHMM  
    
    disp 'Loading data...';
    
    load 'Save/HMM_CRP/initHMM';    
    
    Ntot = length(allSongs);
    
    [trainSongsIdx,~,testSongsIdx] = dividerand(Ntot,trainPerc,0,1-trainPerc);
    
    trainSongs = allSongs(trainSongsIdx);
    testSongs = allSongs(testSongsIdx);
    
    trainIdx = find(ismember(allSongsList,trainSongs));
    testIdx = find(ismember(allSongsList,testSongs));
    
    trainSongsList = allSongsList(trainIdx);
    testSongsList = allSongsList(testIdx);
    
    trainDiscographyFeatures = allDiscographyFeatures(trainIdx);
    testDiscographyFeatures = allDiscographyFeatures(testIdx);
    
    trainDiscographyChords = allDiscographyChords(trainIdx,:);
    testDiscographyChords = allDiscographyChords(testIdx,:);
    
    true_trainChordsList = true_allChordsList(trainIdx);
    true_testChordsList = true_allChordsList(testIdx);
    
    disp 'Saving train data...'
    
    disp 'Saving test data...'
    
    save('Save/HMM_CRP/initTrainHMM','trainDiscographyFeatures','trainDiscographyChords', 'true_trainChordsList', 'trainSongs', 'trainSongsList', 'chords');
    
    save('Save/HMM_CRP/initTestHMM','testDiscographyFeatures','testDiscographyChords','true_testChordsList', 'testSongs', 'testSongsList');
    
else
    
    disp 'Loading train data...'
    
    disp 'Loading test data...'
    
    load 'Save/HMM_CRP/initTrainHMM';
    
    load 'Save/HMM_CRP/initTestHMM';
end


%% Training with SVM

kernel = 'polynomial';

disp 'Training SVM with extracted features...'
mdlSvmCens = trainSVM( createDataMatrix(trainDiscographyFeatures),...
    true_trainChordsList, 'KernelFunction',kernel );


%% Predict with SVM

disp 'Testing SVM with extracted features...'

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

w = 1;

states = rot90(chords);

for i=1:1
    
    song = testSongs(i);
    
    indexSong = find(testSongsList == song);
    
    obs = mdlSvmCens.predict( createDataMatrix(testDiscographyFeatures(indexSong)));
    
    numeric_obs = zeros(1,size(obs,1));
    
    for j=1:size(chords)
    
        [indexChords, ~] = find(obs==chords(j));
    
        numeric_obs(indexChords)=j;
    
    end    

    [total, argmax, valmax] = forward_viterbi(numeric_obs,states,startProb,transProb,emProb);
    
    if valmax~=0
        argmax = argmax(1:(size(argmax,2)-1));
        
        numeric_argmax = zeros(1,size(argmax,2));
    
        for j=1:size(chords)
            
            a = categorical(argmax);
            
            a = a';
    
            [indexChords, ~] = find(a==chords(j));
    
            numeric_argmax(indexChords)=j;
    
        end   
    
        errors(1,w) = computeError(true_testChordsList(indexSong),categorical(argmax));
    
        errors(2,w) = computeError(true_testChordsList(indexSong),obs);
        
        smoothing(1,w)=getSmooth(categorical(argmax));
        
        smoothing(2,w)=getSmooth(obs);
        
        w=w+1;
        
    end
    
end

hmm_error = mean(errors(1,:));
basic_error = mean(errors(2,:));

disp 'Error without HMM: '; disp(basic_error);
disp 'Error with HMM: '; disp(hmm_error);