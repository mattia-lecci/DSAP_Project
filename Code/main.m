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
