function batchVec12 = extractBatchFeatures(paths,featureType,mat2vecFunc)

% input check
p = inputParser;
validFeaturesList = {'CLP','CENS','CRP'};

p.addRequired('paths',@(x)validateattributes(x,{'cell'},{'nonempty'}));
p.addRequired('featureType',@(x)any(validatestring(x,validFeaturesList)));
p.addRequired('mat2vecFunc',@(x)validateattributes(x,...
    {'function_handle'},{'nonempty','vector'}));

p.parse(paths,featureType,mat2vecFunc);

% setup feature extraction
switch featureType
    case 'CLP'
        featureParameters = getCLPParam();
    case 'CENS'
        featureParameters = getCENSParam();
    case 'CRP'
        featureParameters = getCRPParam();
    otherwise
        error('featureType not recognized')
end

% extract features
Ntot = length(paths);
batchVec12 = cell(Ntot,1);

parfor i = 1:Ntot
    fprintf('Processing file %4d/%4d\n',i,Ntot);
    
    [f_audio,sideinfo] = wav_to_audio('', '', paths{i});
    shiftFB = estimateTuning(f_audio);
    
    paramPitch = struct();
    paramPitch.winLenSTMSP = 4410;
    paramPitch.shiftFB = shiftFB;
    
    [f_pitch,sideinfo] = audio_to_pitch_via_FB(f_audio,paramPitch,sideinfo);
    
    switch featureType
        case 'CLP'
            [f,~] = pitch_to_chroma(f_pitch,featureParameters,sideinfo);
        case 'CENS'
            [f,~] = pitch_to_CENS(f_pitch,featureParameters,sideinfo);
        case 'CRP'
            [f,~] = pitch_to_CRP(f_pitch,featureParameters,sideinfo);
        otherwise
            error('featureType not recognized')
    end
    
    batchVec12{i} = mat2vecFunc(f);
    
end

end

%% utility functions
function param = getCLPParam()
param.applyLogCompr = 1;
param.factorLogCompr = 100;
end

function param = getCENSParam()
param.winLenSmooth = 21;
param.downsampSmooth = 5;
end

function param = getCRPParam()
param.coeffsToKeep = [55:120];
end