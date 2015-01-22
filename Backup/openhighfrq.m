%% Opening and sorting the higher frequency data
highffile=importdata(strcat(pthf,samplef_file));
highf.amp = highffile.data(:,3); %pulls amp of "tissue" file
highf.phi = highffile.data(:,2); %pulls phase of "tissue" file

calffile=importdata(strcat(pthf,calfilef));
calf.amp = calffile.data(:,3); %pulls amp of calibrator file
calf.phi = calffile.data(:,2); %pulls phase of calibrator file

[sampf, pthf, filterindexf] = uigetfile('*.asc','Select High Frequency Data Set','MultiSelect', 'on',pth);

cd phantoms; %Current dir should be the phantomless_cal3 folder
[phan, phanpth, filterindex3] = uigetfile('*.txt','Select Phantom File');

whichfile=strfind(sampf{1},'MATCH'); %File with "MATCH" is from the calibrator
foundit=isempty(whichfile); %Returns a number or a 0 if found or not, respectively

if foundit==0 %Sorting which file is match and which is sample
    samplef_file=sampf{2};
    calfilef=sampf{1};
else
    samplef_file=sampf{1};
    calfilef=sampf{2};
end