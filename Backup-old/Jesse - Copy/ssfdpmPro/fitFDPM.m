function fdpmfit = fitFDPM(diodes, freq, amp, damp, phi, dphi, model_to_fit, options, verbose, n, dist, reff_option)
%%%byh mufit.m has the actual fdpm fit.  

% Nested functions
    % mufit - Fits the model to the data using chi-squared minimization and runs the final model output for the best fitting curve.
        % fdpmFitScat - If we have more than 1 diode, attempts to fit the scattering curve using the power law

if(strcmp(model_to_fit,'vpSDA'))
    VtsSolvers.SetSolverType('PointSourceSDA');
    model_to_fit='vpRofRhoandFt';
elseif(strcmp(model_to_fit,'vpMCBasic'))
    VtsSolvers.SetSolverType('MonteCarlo');
    model_to_fit='vpRofRhoandFt';
elseif(strcmp(model_to_fit,'vpMCNurbs'));
    VtsSolvers.SetSolverType('Nurbs');
    model_to_fit='vpRofRhoandFt';
end

if verbose
    disp('WV     AC(fmin)  phi(fmin)')
    disp([diodes' amp(1,:)' phi(1,:)']);
end

if options.imagfit && verbose 
	disp(sprintf('Wv(nm)\tMua \tDmua (mm-1)\t  Mus \t Dmus (mm-1) \tChiReIm\tGuess # \tTotal Guesses\tCov'))
elseif verbose
	disp(sprintf('Wv(nm)\tMua \tDmua (mm-1)\t  Mus \t Dmus (mm-1) \tChiPhAm\tGuess # \tTotal Guesses\tCov'))
end 

%%%byh fdpm fit can be done either with phase/amplitude or real/imaginary.
%%%Standard is to fit real/imaginary.
if options.imagfit==1
    cosphi = cos(phi);
    sinphi = sin(phi);
    DATA = [amp.*cosphi; amp.*sinphi]; %[real; imag]
else
    %DATA = [amp; phi];

    %Normalizes the calibrated data by fitting a polynomial to the first 40
    %frequencies then dividing everything by the first point of that
    %polynomial
    for loop=1:length(diodes)
      ampfit = polyfit(freq(1:40),amp(1:40,loop),1);
      ampoly = polyval(ampfit,freq);
      amp(:,loop)=amp(:,loop)./ampoly(1);
    end
    
%     DATA=[(amp./ampoly(1));phi];
    DATA=[amp;phi];
    %       DATA=[10*(amp./ampoly(1));phi];
end

flen = length(freq);

%Assign Weights
if options.err==3   %no weights
    if options.imagfit==1
        WT= ones(2*flen,1) * (1./ (sum(DATA)./2) ) .*10^4;   %quick fix for low values of real/imag
    else
        WT = [ones(flen,1)*(1./sum(amp));  ones(flen,1)*(1./sum(phi))].*10^4;   %normalize amp and phase fits
    end
elseif(options.imagfit==0) % amp/phase weights
 	WT = 1./abs([damp; dphi]);  %radians
else %real/imag weights
 	ERR_REAL=sqrt((damp.*cosphi).^2 + (dphi.*amp.*sinphi).^2);
	ERR_IMAG=sqrt((damp.*sinphi).^2 + (dphi.*amp.*cosphi).^2);
	WT = abs([1./ERR_REAL;1./ERR_IMAG]);  
end

%YDATA = DATA.*WT;
YDATA = DATA;


fdpmfit = mufit(diodes, model_to_fit, YDATA, WT, freq, n, dist, options, verbose, reff_option);


