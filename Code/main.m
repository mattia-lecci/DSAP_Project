clear variables
close all
clc

%% init
% paths
addpath('init')

% parameters
trainPerc = .7;
mat2vecFunc = @(x)max(x,[],2);

% flags
performFeatureExtraction = true;

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

%% training
% train GMM and SVM once and save their objects containing settings
trainedObj = trainModel(modelType,trainChords,trainVec12,name-value_pairs);
% one per each model (gmm, svm), different features, different settings
% save objects or load from previously trained

%% template
predChords = zero(length(testIdx),1);

for i = 1:length(predChords)
        predChords(i) = templateDecision( batchVec12{i},templateType )
    % for each template type and feature type
end

err = computeError(real,predicted)
% for each predChords

%% statistical methods (already trained)
% fit models
% compute errors

%% display/plot
% grid on