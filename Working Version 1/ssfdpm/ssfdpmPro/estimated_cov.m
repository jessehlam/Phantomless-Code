%ESTIMATED_COV
%estimates error [d1, d2, d1d2] = estimated_err(num_constraints, num_degrees_of_freedom, RES, JAC);
%
% fit.ci = nlparci(p1, RESID, jac);  %gives confidence interval.. very slow and gives pretty close results to those below ..
% disp(sprintf('\t%7.6f \t%7.4f',(fit(a).ci(1,1)-fit(a).mua)/2,(fit(a).ci(2,2)-fit(a).mus)/2));
%% following section is Ray Muzic's estimate for covariance and correlation
%% assuming covariance of data is a diagonal matrix proportional to
%% diag(1/WT.^2).  
%% cov matrix of data est. from Bard Eq. 7-5-13, and Row 1 Table 5.1 
%
%NOTES: Version 1.8
%Below is modified from levmarreim3: removed weights ... they are already taken into account in jac and RESID .. gives same #'s DJ 10/00

function [cov] = estimated_cov(n, m, RES, JAC);
COVR=RES'*RES/(m-n);                 %covariance of residuals
VY=1/(1-n/m)*COVR;  % Eq. 7-13-22, Bard         %covariance of the data 
JTGJINV=inv(JAC'*JAC);
cov=JTGJINV*JAC'*VY*JAC*JTGJINV; % Eq. 7-5-13, Bard %cov of parm est
