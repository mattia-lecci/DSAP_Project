function err = computeError(trueLabel,predLabel)
%COMPUTEERROR Computes error rate of the given prediction. Expects
%   predLabel and trueLabel to be categorical arrays.

p = inputParser;
p.addRequired('trueLabel',@(x)validateattributes(x,{'categorical'},{'vector'}));
p.addRequired('predLabel',@(x)validateattributes(x,{'categorical'},...
    {'vector','numel',length(trueLabel)}));
p.parse(trueLabel,predLabel);

% force column
predLabel = shiftdim(predLabel);
trueLabel = shiftdim(trueLabel);

Nerr = nnz(predLabel~=trueLabel);
err = Nerr/length(trueLabel);

end