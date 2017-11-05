%Computation of the "distance" between the new value and a certain gaussian
%described by its mean and its covariance

function dist = gaussianDistance(obj,gaussdistribution)
    
    %Check if the input parameters are correct
    
    p = inputParser;
    p.addRequired('gaussdistribution',@(x)validateattributes(x,{'gmdistribution'}));
    p.addRequired('value',@(x) validateattributes(x,{'numeric'},{'size',[12,1]}));
    p.parse(gaussdistribution, value);
    
    % Return the "distance" between obj and the distribution
    
    dist = mahal(obj, gaussdistribution);  

end