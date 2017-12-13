%Computation of the "distance" between the new value and a certain gaussian
%described by its mean and its covariance

function dist = gaussianDistance(gaussDistrib, obj)
    
    
    % Return the "distance" between obj and the distribution
    
    dist = mahal(gaussDistrib, obj);  

end