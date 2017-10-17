clear variables
close all
clc

%% init
% paths
addpath('init')

performFeatureExtraction = true;

if performFeatureExtraction
    % extract names and chords labels
    chordTable = getNameChordTable('wavs');
    batchVec12 = extractBatchFeatures(names,featureType)
    % should we save them? one per each feature type. computed only once and
    % for all. if so, wrap in if
end
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