function fcalc = freqcalc(guiVal)
%Importing data
dataloc=strcat(guiVal.dataDir,guiVal.patientID,'\',guiVal.date,'\'); %Getting location of dark file
darkimport=importdata(strcat(dataloc,'DARK-dcswitch.asc')); %Reconstructing location of dark file
msmtimport=importdata(strcat(dataloc,guiVal.prefixList{1},'-dcswitch.asc')); %Reconstructing location of msmt file
phanimport=importdata(strcat(dataloc,guiVal.phantomList{1},'-dcswitch.asc')); %Reconstructing location of msmt file
freq=darkimport.data(:,1); %Importing frequency range

fcalc.dark=darkimport.data;
fcalc.msmt=msmtimport.data;
fcalc.cal=phanimport.data;

%Converted to log amplitude
darkdat=20*log10(darkimport.data); %Importing dark data
msmtdat=20*log10(msmtimport.data); %Importing "tissue" data
phandat=20*log10(phanimport.data); %Importing calibrator data

%% Recording the higher frequency cutoff
for p=1:length(guiVal.fdpm_diodes)
    dark=darkdat(:,2*p+1); %Pulling dark
    cal=phandat(:,2*p+1); %Pulling calibrator
    tissue=msmtdat(:,2*p+1); %Pulling "tissue"
    
    fcalc.caldat(:,p)=tissue./cal; %Calibrated signal
    snrmsmt=tissue./dark; %Calculating the SNR of the calibrator
    snrphan=cal./dark; %Calculating the SNR on the "tissue"

    msmtcut=find(snrmsmt>0.9,1); %Finding the cutoff for acceptable SNR
    phancut=find(snrphan>0.9,1);

    if isempty(msmtcut) %If the entire amplitude is above the noise floor, set to the max freq
        msmtcut=max(freq);
    end
    if isempty(phancut)
        phancut=max(freq);
    end

    if msmtcut < phancut %The amplitude that first approaches an SNR of 1 is the lower amp cutoff
        fcalc.down(p)=25*floor(freq(msmtcut)/25); %Round to the nearest 25
%         fcalc.numdown(p)=msmtcut;
    elseif msmtcut > phancut
        fcalc.down(p)=25*floor(freq(phancut)/25);
%         fcalc.numdown(p)=phancut;
    elseif msmtcut == phancut
        fcalc.down(p)=25*floor(freq(phancut)/25);
%         fcalc.numdown(p)=phancut;
    else
        fcalc.down(p)=max(freq);
%         fcalc.numdown(p)=401;
    end
end

fcalc.down=min(fcalc.down); %Using the lowest frequency cutoff
