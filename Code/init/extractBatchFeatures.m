function batchVec12 = extractBatchFeatures(paths,featureType)

% input check
p = inputParser;
validFeaturesList = {};

p.addRequired(p,'paths',@(x)validateattributes(x,{'cell'},{'nonempty'}));
p.addRequired(p,'featureType',@(x)validatestring(x,validFeaturesList));

p.parse(paths,featureType);

% setup feature extraction

% extract features
batchVec12 = cell(size(paths));

end