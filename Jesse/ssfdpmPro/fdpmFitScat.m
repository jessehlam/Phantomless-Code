function [preft, slope, dpreft, dslope] = fdpmFitScat(diodes, mus, chi_weight, options, verbose)
%Returns sattering fit parms and [possibly new fit (if feedback~=0)
%change fitopions after debugging for speed

num_diodes = length(diodes);

mus = mus';
%do weighting of mus if requested
if options.mus_robust==0
    wt_mus = ones(num_diodes,1);
else
    wt_mus = (1./chi_weight*min(chi_weight))';  %weight by chi square (where lowest chi2 is 1)    
end


%linear fit of the function log(musp) versus log(wavelength)
a=[ones(num_diodes,1) log(diodes)];  % [ones log(wavelenght)]
b=log(mus); 
c=a\b; %least-square fit to a linear function
d(1)=exp(c(1));
d(2)=c(2);

powerinit=[d(1),d(2);80,-1;10,-.5;600 -.9];

% then using the values from the linear fit as initial guess to a non-linear fit
m = length(mus);
n= 2;
num_guesses = size(powerinit,2);
P1 = zeros(num_guesses, n); RESID = zeros(m, num_guesses); 
CONVERGED = zeros(1,num_guesses); JACOBIAN = zeros(m, n, num_guesses);
%fitoptions=optimset('display','off','TolFun',1e-1,'LargeScale','off','LevenbergMarquardt','off');
fitoptions=optimset('display','off');
CHI = zeros(num_guesses,1);
%OUTPUT=repmat(struct('iterations',0,'funcCount',0,'stepsize',0,'cgiterations','','firstorderopt',0,'algorithm',0,'message',''),1,num_guesses);
OUTPUT=repmat(struct('firstorderopt',0,'iterations',0,'funcCount',0,'cgiterations','','algorithm',0,'message',''),1,num_guesses);
for t=1:num_guesses
   [P1(t,:), ss, RESID(:,t), CONVERGED(t), OUTPUT(t), lambda, JACOBIAN(:, :, t)] = ...
      lsqcurvefit('powerlaw', powerinit(t,:), diodes, mus.*wt_mus, [], [], fitoptions,  wt_mus);
   CHI(t) =  ss./n;    %check with albert about whether use length(fit.freq) or length(reim) 
   if(CHI(t)<options.chisqok),
       break;
   end
end   
[chi, best] = min(CHI(1:t));	
preft = P1(best,1);
slope = P1(best,2);

%Estimate error
[dpreft, dslope] = estimated_err(n, m, RESID(:,best), JACOBIAN(:,:,best));

%Scattering results
if verbose
    disp(['Scattering  = ',sprintf('%1.4f*LAMBDA^n, with n = %1.3f +/- %1.3f\n guess # %d: %g %g',preft,slope,dpreft, best, powerinit(best,1), powerinit(best,2))]);
end


