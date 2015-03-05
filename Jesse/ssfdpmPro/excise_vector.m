%Removes any rows with NaN's
function [X, excised_idx] = excise_vector(X)

excised_idx= isnan(X);
X(excised_idx)=[];


