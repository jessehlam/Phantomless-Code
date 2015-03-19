function ss = fitSSFDPM(fdpmfit, fdpmDiodes, whichspecDiodes, wvrange, fdopt, specopt, verbose,R,diodR,rho,n,mua_guess,fdpmsserr, reff_option)
%%%byh Function recovers optical absorption at each broadband wavelength

ss.diodMua = [];ss.diodMus = [];
ss.diodDmua= [];ss.diodDmus = [];
ss.phy=[];
ss.fitmua=[];
ss.ss=[];

%if length(intersect(fdpmDiodes, specDiodes)) ~= length(fdpmDiodes)  %if we're using a different list of diodes than original fit
%%%byh This step is already done in mufit.m where the power law
%%%coefficients are recovered by fitting the fdpm scattering.  A subset of the 
%%%fdpm diodes can be used which would result in a different fit.
if sum(whichspecDiodes)<length(fdpmDiodes)
    specDiodes=fdpmDiodes(whichspecDiodes==1);
    mus=fdpmfit.mus(whichspecDiodes==1);
    chi=fdpmfit.chi(whichspecDiodes==1);
    [ss.preft, ss.slope, ss.dpreft, ss.dslope] = fdpmFitScat(specDiodes', mus, chi, fdopt, verbose);
    if verbose
        disp(sprintf('Slope refit %g %g', ss.preft, ss.slope));
    end
else
    specDiodes=fdpmDiodes;
    ss.preft = fdpmfit.preft;
    ss.slope = fdpmfit.slope;
    ss.dpreft = fdpmfit.dpreft;
    ss.dslope = fdpmfit.dslope;
    if verbose
        disp(sprintf('Using same slope %g %g', ss.preft, ss.slope));
    end
end
%%%byh Using the power law cofficients (preft and slope), the optical
%%%scattering is generated for the complete broadband wavelength range
ss.mus = powerlaw([ss.preft ss.slope], wvrange); % making musp_spectrum over given wv range
for i = 1:length(specDiodes)
    index = find (fdpmDiodes == specDiodes(i));
    if ~isempty(index)
        [ss.diodMua(i), ss.diodMus(i), ss.diodDmua(i), ss.diodDmus(i)] = ...
            deal(fdpmfit.mua(index), fdpmfit.mus(index), fdpmfit.dmua(index), fdpmfit.dmus(index));
    else
        disp(['Error .. wavelengths in spec is not represented in fdpm: ' int2str(spec.diodes(i))]);
    end
end;
ss.diodMua = ss.diodMua';ss.diodMus=ss.diodMus';ss.diodDmua=ss.diodDmua'; ss.diodDmus = ss.diodDmus';

% COMPUTE MUA SPECTRUM --------------------------------------------------------------------------------------------
N=length(wvrange);
options=optimset('display', 'off');
ss.muaSPEC=zeros(N,1);
for i=1:N,  %loop over all wavelengths (fsolve could avoid the loop but seems too memory-consuming)
    if i>1
        mua_guess(2)=ss.muaSPEC(i-1);
    end
    if R(i) <=0 || isnan(R(i))==1  %added
        ss.muaSPEC(i)=0;
    else
        %%%byh Using the generated optical scattering and the measured reflectance, for each wavelength the
        %%%optical absorption is recovered by finding the solution that
        %%%minimizes the reflectance model prediction from the measured
        %%%reflectance
        ss.muaSPEC(i)=fzero('rexp_minus_rtheory',mua_guess(2),options, R(i), ss.mus(i), rho,  n, reff_option); % find mua for a single lambda value
        if isnan(ss.muaSPEC(i))
            ss.muaSPEC(i)=fzero('rexp_minus_rtheory',mua_guess(1),options, R(i), ss.mus(i), rho,  n, reff_option);
            if isnan(ss.muaSPEC(i))
                fprintf('mua at %i nm not fit\n',wvrange(i));
            end
        end
    end
end

ss.R=R;
ss.diodR=diodR;
ss.muaSPEC=spectrumSmoother(ss.muaSPEC,4,3);    %despike
ss.muaSPEC=spectrumSmoother(ss.muaSPEC,1,specopt.boxcar)';    %despike
ss.fdpmsserr=fdpmsserr;


