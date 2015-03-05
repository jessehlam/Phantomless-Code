function cal=getFDPMCal(fdpmcal, diodes_selected, stderr, reff_option, file)
%%%byh Calculates instrument response using measurement on phantom of known optical properties 

% which_cal: 0 uncalibrated; 1 off phantom; 2 is 2 distance
% calibration files need to be in path, will probably need to specify
% location at some point. . 2 distance not coded yet.
% phantom name must not have dash
% OUTPUT:
% cal.error
% cal.dist
% cal.AC
% cal.ACsd_AC_sqd
% cal.phase
% cal.phsd_sqd



which_cal=fdpmcal.which;
phantoms=fdpmcal.phantoms;
rfixed=fdpmcal.rfixed;
n=fdpmcal.n;
model=fdpmcal.model_to_fit;
phantomdir=fdpmcal.phantomdir;

if(strcmp(model,'vpSDA'))
    VtsSolvers.SetSolverType('PointSourceSDA');
    model='vpRofRhoandFt';
elseif(strcmp(model,'vpMCBasic'))
    VtsSolvers.SetSolverType('MonteCarlo');
    model='vpRofRhoandFt';
elseif(strcmp(model,'vpMCNurbs'));
    VtsSolvers.SetSolverType('Nurbs');
    model='vpRofRhoandFt';
end

%%%byh off phantom is standard calibration method, other methods in this
%%%file will be ignored
if which_cal==1     %% OFF PHANTOM
    %%%byh phantom files are read in and averaged together
    refdat=averageFDPMDataAtDiodes(char(phantoms),diodes_selected,stderr);
    if refdat.error~=0
        cal.error=-1;
        return;
    end
    %%%byh s-d separation used for measurement is either read from file or
    %%%taken from settings
    if rfixed==0
        cal.dist=refdat.dist;
    else
        cal.dist=rfixed;
    end
    
    base_ph='ph010';%phtrunc(char(phantoms(1)));
    %%%checks to make sure files being averaged on are the same phantom
    if (length(phantoms)>1)
        for ii=2:length(phantoms)        
            base_ph_next=phtrunc(char(phantoms(ii)));
            if ~strcmp(base_ph,base_ph_next)
                display(['Aborting: Calibration phantoms must be the same']);
                cal.error=-1;
                return;
            end
        end
    end
    
    %%%checks for phantom file of same name as measurement file
    if ~exist(strcat(phantomdir,base_ph,'.txt'),'file')
        display(['Aborting: Phantom file not found for phantom ' base_ph]);
        cal.error=-1;
        return;
    else
        cal_file=strcat(phantomdir,base_ph,'.txt');
    end
    
    nFreq=length(refdat.freq);         	%find number of data points
    noWt = ones(nFreq*2,1);
    
    %%%byh For phantom files, standardized names are used which match up to
    %%%calibration files in the phantom directory.  the calibration files
    %%%consist of the phantom optical properties at a number of wavelengths.  The
    %%%wavelengths and optical properties are loaded here below 
    cfile=load(cal_file);
    %%%byh The wavelengths in the phantom files do not always match up to the fdpm wavelengths, 
    %%%so we do an interpolation of that dataset to get mua and mus at each
    %%%of the fdpm diode wavelengths
    pmua = interp1(cfile(:,1), cfile(:,2), diodes_selected); %mua
    pmus = interp1(cfile(:,1), cfile(:,3), diodes_selected); %mus
    
    pdmua = pmua.*0.05; %assume 5% error
    pdmus = pmus.*0.05; %assume 5% error
    
    
%%%byh Instrument response is calculated for each diode separately.  Using
%%%the known phantom mua and mus at the diode wavelength, a forward calculation is done with the model
%%%and a theoretical phase and ampltidude is calculated covering all the
%%%measured frequencies
    for a=1:length(diodes_selected)
        cal.phantom_used(a)=1;
        %%%byh Forward calculation - for matlab purposes, the model is set up to return the
        %%%amplitude and phase as a single array, ampltiude at every
        %%%frequency followed by phase at each frequency
        theory=feval(model,[pmua(a),pmus(a)], refdat.freq, 0, n, cal.dist, 0, noWt, 0, reff_option);
        AC_phan = theory(1:nFreq);
        PHI_phan = theory(1+nFreq:2*nFreq);  %in radians
        %%%byh Once the theoretical phase and amplitude are calculated,
        %%%this phase is subtracted from the measured phantom phase and the
        %%%measured amplitude is divided by the theoretical amplitude.  The
        %%%result is the instrument response that can then be used to
        %%%calibrate the measurement files
        L_cal = 95;
        L_filter = 4.66;
        c = 2.9979e11;
        n_air = 1;
        n_filter = 1.5;
        
        cal.phase_offset = 360*refdat.freq*10^6*((L_cal-L_filter)/c/n_air+L_filter/c/n_filter);
        cal.phase(:,a) =refdat.phase(:,a) - deg2rad(cal.phase_offset);% - PHI_phan; %Correct phase through air and glass   		
%         cal.phase(:,a) = cal.phase(:,a)-cal.phase(1,a);
        cal.AC(:,a)   =refdat.AC(:,a);%./ AC_phan;
        deriv_phan=dfdp(model,refdat.freq,theory, [pmua(a),pmus(a)],.0001*ones(2,1),0,n,cal.dist,0,noWt,0, reff_option);
        dACdmua=deriv_phan(1:nFreq,1);				%derivative of Re with respect to mua
        dPHIdmua=deriv_phan(1+nFreq:2*nFreq,1); %radians
        dACdmus=deriv_phan(1:nFreq,2);
        dPHIdmus=deriv_phan(1+nFreq:2*nFreq,2); %radians
        cal.ACsd_AC_sqd(:,a)=  (refdat.ACsd(:,a) ./refdat.AC(:,a)).^2 + ((pdmua(a)*dACdmua).^2 +(pdmus(a)*dACdmus).^2)./AC_phan.^2;
        cal.phsd_sqd(:,a)= refdat.phsd(:,a).^2 + (pdmua(a)*dPHIdmua).^2 + (pdmus(a)*dPHIdmus).^2 ;
    end
elseif which_cal==0    %%NO CAL
    cal.phase=0;
    cal.AC=1;  
    cal.ACsd_AC_sqd =  0;
    cal.phsd_sqd= 0;
    cal.phantom_used(1:length(diodes_selected))=1;
elseif which_cal==2
    display('2 distance calibration not currently coded');
        cal.error=-1;
        return;
elseif which_cal==3  % calibrate against multiple phantoms and select the closest based on FDPM amplitude   
    phantom_error_check=averageFDPMDataAtDiodes(char(phantoms),diodes_selected,stderr); % for error checking only that refs have same # diodes, freqs, etc.
    if phantom_error_check.error~=0
        cal.error=-1;
        return;
    end
    
    for ii=1:length(phantoms)
        mrefdat{ii}=averageFDPMDataAtDiodes(char(phantoms(ii)),diodes_selected,stderr);
        if mrefdat{ii}.error~=0
            cal.error=-1;
            return;
        end  
        
        base_ph=phtrunc(char(phantoms(ii)));
        if ~exist(strcat(phantomdir,base_ph,'.txt'),'file')
            display(['Aborting: Phantom file not found for phantom ' base_ph]);
            cal.error=-1;
            
            return;
        else
            cal_file=strcat(phantomdir,base_ph,'.txt');
        end
        
     
        cfile=load(cal_file);
        mpmua{ii} = interp1(cfile(:,1), cfile(:,2), diodes_selected); %mua
        mpmus{ii} = interp1(cfile(:,1), cfile(:,3), diodes_selected); %mus
        
        mpdmua{ii} = mpmua{ii}.*0.05; %assume 5% error
        mpdmus{ii} = mpmus{ii}.*0.05; %assume 5% error
        
    end
    
    nFreq=length(mrefdat{1}.freq);         	%find number of data points
    noWt = ones(nFreq*2,1);
        
    if rfixed==0
        cal.dist=mrefdat{1}.dist;
    else
        cal.dist=rfixed;
    end

    
raw = averageFDPMDataAtDiodes(file, diodes_selected, stderr);    
    
ind = find(mrefdat{1}.freq>=fdpmcal.multi_phantom_freq(1) & mrefdat{1}.freq<=fdpmcal.multi_phantom_freq(2));

    for a=1:length(diodes_selected)
        % select the best phantom for calibration by diode
        
        for ii=1:length(phantoms)
            ACdiff(ii)=abs(mean(raw.AC(ind,a)) - mean(mrefdat{ii}.AC(ind,a)));    
        end
        [mindiff, indexmindiff]=min(ACdiff);
        cal.phantom_used(a)=indexmindiff;
        
        theory=feval(model,[mpmua{indexmindiff}(a),mpmus{indexmindiff}(a)], mrefdat{indexmindiff}.freq, 0, n, cal.dist, 0, noWt, 0, reff_option);
        AC_phan = theory(1:nFreq);
        PHI_phan = theory(1+nFreq:2*nFreq);  %in radians
        cal.phase(:,a) =mrefdat{indexmindiff}.phase(:,a) - PHI_phan;    		
        cal.AC(:,a)   =mrefdat{indexmindiff}.AC(:,a) ./ AC_phan;
        deriv_phan=dfdp(model,mrefdat{indexmindiff}.freq,theory, [mpmua{indexmindiff}(a),mpmus{indexmindiff}(a)],.0001*ones(2,1),0,n,cal.dist,0,noWt,0, reff_option);
        dACdmua=deriv_phan(1:nFreq,1);				%derivative of Re with respect to mua
        dPHIdmua=deriv_phan(1+nFreq:2*nFreq,1); %radians
        dACdmus=deriv_phan(1:nFreq,2);
        dPHIdmus=deriv_phan(1+nFreq:2*nFreq,2); %radians
        cal.ACsd_AC_sqd(:,a)=  (mrefdat{indexmindiff}.ACsd(:,a) ./mrefdat{indexmindiff}.AC(:,a)).^2 + ((mpdmua{indexmindiff}(a)*dACdmua).^2 +(mpdmus{indexmindiff}(a)*dACdmus).^2)./AC_phan.^2;
        cal.phsd_sqd(:,a)= mrefdat{indexmindiff}.phsd(:,a).^2 + (mpdmua{indexmindiff}(a)*dPHIdmua).^2 + (mpdmus{indexmindiff}(a)*dPHIdmus).^2 ;
    end
else
    display('fdpm.cal.which not in range');
        cal.error=-1;
        return;
end
cal.error=0;