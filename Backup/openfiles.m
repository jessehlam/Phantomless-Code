%% Importing sample and calibrator data
cd(pth)
%%Opens the "tissue" measurement
FDPM=importdata(strcat(pth,sample_file)); %sample file (i.e. the phantom)
FDPM.F = FDPM.data(:,1); %Pulls the frequency range

numdiode=size(FDPM.data); %Detects number of diodes used
numdiode=(numdiode(:,2)-1)/2;

if numdiode > 1 %If more than 1 diode detected (doesn't quite work yet)
    waitfor(msgbox('Multidiode detected. Enter diode number to calibrate'));
    diag2={'Diode Number'};
    boxdisp2=''; %Dialog title
    lines2=1; %Number of lines per input box
    output2=inputdlg(diag2,boxdisp2,lines2);
    diode=str2double(output2{1});
    
    FDPM.PHI = FDPM.data(:,2*diode); %amp of sample file
    FDPM.AMP = FDPM.data(:,1+2*diode); %phase of sample file
else
    FDPM.PHI = FDPM.data(:,2); %pulls amp of sample file
    FDPM.AMP = FDPM.data(:,3); %pulls phase of sample file
end

%% Opens the "calibrator" file
CAL=importdata(strcat(pth,calfile));
CAL.AMP = CAL.data(:,3); %pulls amp of cal file
CAL.PHI = CAL.data(:,2); %pulls phase of cal file
