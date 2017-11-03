function X = createDataMatrix(features)
%CREATEDATAMATRIX Transforms the cell-array vector into a data matrix
%   whose columns are the different features and the rows are different
%   samples

p = inputParser;
p.addRequired('features',@(x)validateattributes(x,{'cell'},{'nonempty','vector'}));
p.parse(features);

% force column
features = shiftdim(features);

features_rows = cellfun(@(x) shiftdim(x).',features,...
    'UniformOutput',false); % every array in the cell is now row
X = cell2mat(features_rows); % stacks rows on top of each other

end