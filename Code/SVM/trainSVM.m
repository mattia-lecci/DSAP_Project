function mdl = trainSVM(X,Y,varargin)
%TRAINSVM Trains multiclass SVM.
% mdl = TRAINSVM(X,Y) Trains the multiclass SVM using the numerical matrix
%   X (columns are features, rows are samples) and the categorical array Y
%   containing the labels. It uses default parameters for TEMPLATESVM and
%   FITCECOC, excluding:
%   - 'Prior','uniform'
% mdl = TRAINSVM(__,Name,Value) Adds Name-Value pairs to TEMPLATESVM and
%   FITCECOC.
%
% NOTE: some parameters are not available due to retrocompability to Matlab
%   R2014b
% SEE ALSO: TEMPLATESVM, FITCECOC

%% arg check
p = inputParser;

% required
p.addRequired('X',@(x)validateattributes(x,{'numeric'},{'2d','nonempty'}));
p.addRequired('Y',@(x)validateattributes(x,{'categorical'},...
    {'vector','numel',size(X,1)}));
% templateSVM
p.addParameter('BoxConstraint',[]);
% p.addParameter('ClipAlphas',[]);
p.addParameter('GapTolerance',[]);
p.addParameter('KKTTolerance',[]);
p.addParameter('KernelFunction',[]);
p.addParameter('PolynomialOrder',[]);
p.addParameter('NumPrint',[]);
p.addParameter('Nu',[]);
p.addParameter('OutlierFraction',[]);
p.addParameter('Standardize',[]);
% p.addParameter('SaveSupportVectors',[]);
p.addParameter('Verbose',0);
% fitcecoc
p.addParameter('Coding','onevsone');
p.addParameter('CrossVal',[]);
p.addParameter('CVPartition',[]);
p.addParameter('Holdout',[]);
p.addParameter('KFold',[]);
p.addParameter('Leaveout',[]);
p.addParameter('Streams',[]);
p.addParameter('UseParallel',[]);
p.addParameter('UseSubstreams',[]);
p.addParameter('Prior','uniform');
% p.addParameter('OptimizeHyperparameters',[]);
% p.addParameter('HyperparameterOptimizationOptions',[]);

p.parse(X,Y,varargin{:});

%% init
tic
t = templateSVM('BoxConstraint',p.Results.BoxConstraint,...'ClipAlphas',p.Results.ClipAlphas,...
    'GapTolerance',p.Results.GapTolerance,...
    'KKTTolerance',p.Results.KKTTolerance,...
    'KernelFunction',p.Results.KernelFunction,...
    'PolynomialOrder',p.Results.PolynomialOrder,...
    'NumPrint',p.Results.NumPrint,...
    'Nu',p.Results.Nu,...
    'OutlierFraction',p.Results.OutlierFraction,...
    'Standardize',p.Results.Standardize,...'SaveSupportVectors',p.Results.SaveSupportVectors,...
    'Verbose',p.Results.Verbose);

fitInput = {X,Y,...
    'Learners',t,...
    'Coding',p.Results.Coding,...
    'Verbose',p.Results.Verbose,...
    'Options',statset('Streams',p.Results.Streams,...
                      'UseParallel',p.Results.UseParallel,...
                      'UseSubstreams',p.Results.UseSubstreams),...
    'Prior',p.Results.Prior,...'OptimizeHyperparameters',p.Results.OptimizeHyperparameters,...'HyperparameterOptimizationOptions',p.Results.HyperparameterOptimizationOptions
    'CrossVal',p.Results.CrossVal,...
    'CVPartition',p.Results.CVPartition,...
    'Holdout',p.Results.Holdout,...
    'KFold',p.Results.KFold,...
    'Leaveout',p.Results.Leaveout};

mdl = fitcecoc(fitInput{:});

elapsed = toc;
if p.Results.Verbose>=1
    fprintf('Training time: %.3fs\n',elapsed);
end
end