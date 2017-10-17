clear variables
close all
clc

%% init
% paths
addpath('init')

% parameters
trainPerc = .7;

% flags
performFeatureExtraction = true;

% feature extraction
if performFeatureExtraction
    % extract names and chords labels
    chordTable = getNameChordTable('wavs');
    batchVec12 = extractBatchFeatures(names,featureType)
    % should we save them? one per each feature type. computed only once and
    % for all. if so, wrap in if
    save('Save/init',{'chordTable','batchVec12'})
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
trainedObj = trainModel(modelType,trainChords,trainVec12,name-value_pairs)
% one per each model (gmm, svm), different features, different settings
% save objects or load from previously trained

%% template
predChords = <init>

for i = ...
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