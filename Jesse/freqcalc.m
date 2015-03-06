dataloc=strcat(guiVal.dataDir,guiVal.patientID,'\',guiVal.date,'\'); %Getting location of dark file
darkimport=importdata(strcat(dataloc,'DARK-dcswitch.asc')); %Reconstructing location of dark file
msmtimport=importdata(strcat(dataloc,guiVal.prefixList{1},'-dcswitch.asc')); %Reconstructing location of msmt file
phanimport=importdata(strcat(dataloc,guiVal.phantomList{1},'-dcswitch.asc')); %Reconstructing location of msmt file
freq=darkimport.data(:,1); %Importing frequency range
darkdat=20*log10(darkimport.data(:,3)); %Importing dark data
msmtdat=20*log10(msmtimport.data(:,3)); %Importing "tissue" data
phandat=20*log10(phanimport.data(:,3)); %Importing calibrator data

snrmsmt=msmtdat./darkdat; %Calculating the ratio of signal to noise (pseudo SNR)
snrphan=phandat./darkdat;

msmtcut=find(snrmsmt>0.9,1); %If this ratio is equal or greater than 1, the signal is dominated by noise
phancut=find(snrphan>0.9,1);

if isempty(msmtcut) %If the entire amplitude is above the noise floor, set to the max freq
    msmtcut=max(freq);
end
if isempty(phancut)
    phancut=max(freq);
end

msmtupper=find(msmtdat>-15); %Finding when the amplitude is out of the non-linear region of APD
phanupper=find(phandat>-15);

if isempty(msmtupper) %If the amplitude is within the linear region, set to the min freq
    msmtupper=min(freq);
end
if isempty(phanupper)
    phanupper=min(freq);
end

if msmtcut < phancut %The amplitude that first approaches an SNR of 1 is the lower amp cutoff
    down=floor(freq(msmtcut));
    numdown=msmtcut;
elseif msmtcut > phancut
    down=floor(freq(phancut));
    numdown=phancut;
else
    down=max(freq);
    numdown=401;
end

if msmtupper(end) > phanupper(end) %The amplitude that last exits the non-linear range is the upper amp cutoff
    up=floor(freq(msmtupper(end)));
    numup=msmtupper(end);
elseif msmtupper(end) < phanupper(end)
    up=floor(freq(phanupper(end)));
    numup=phanupper(end);
else
    up=min(freq);
    numup=1;
end