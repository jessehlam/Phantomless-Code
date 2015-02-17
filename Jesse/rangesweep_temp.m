%Settings
rho=17.5; %Rho on phantom (mm)
L_list=[5.15 4.66 5.33 5.33 5.33]; %Length of GLASS in calibrator (PH010)
% L_list=[3.79 5.45 5.33 5.33 5.33]; %Length of GLASS in calibrator (ACIN2)
diode_list=[660 690 778 800 830]; %Wavelength used
calfreqstart=.15; %Frequency of interest, starting (Ghz). Cannot be less than instrument frequency.
freqstart=.1; %Instrument starting frequency (GHz)
freqend=1; %Instrument ending frequency (GHz)
% freqs=[.700 .350 1 1 1]; %Frequency to calibrate up to, ACRIN2
%freq_list=[.800 .700 1 1 1]; %Frequency to calibrate up to, PH010
%freq_list=[.6 .35 .8 .8 .8];
%freq_list=[.6 .6 .6 .6 .6];
%freq_list=[.4 .4 .4 .4 .4];
freq_list=[.8 .8 .8 .8 .8];
basepth='\\128.200.57.212\Photon Portal\Data\data.phantomless\150202\PH010\';
% mua=.005:.0001:.012; %Range and resolution of MUa (Acrin 2)
% mus=.8:.0005:1.4; %Range and resolution of MUs (Acrin 2)
% mua=.005:.0001:.009; %Range and resolution of MUa (Ph010)
% mus=.7:.001:1.1; %Range and resolution of MUs (Ph010)
mualist=[0.007363921	0.007373299	0.00782959	0.00792048	0.007794];
muslist=[0.90114413	0.902338888	0.905573179	0.906326216	0.907321347];

for i=1:length(diode_list)
    mua=mualist(i);
    mus=muslist(i);
    pth=strcat(basepth,num2str(diode_list(i)));
    amp_first=1; %prioritizing amp
    sample_file=strcat('\PH010_19MM_100-1000MHZ-0100-dcswitch.asc'); %Opening msmt file
    calfile=strcat('\PH010_19MM_100-1000MHZ_MATCH-0100-dcswitch.asc'); %Opening calibrator file
    diode=diode_list(i); %Loop through list of diodes
    L_filter=L_list(i); %Loop through corresponding lengths of glass
    writenote=strcat('100-',num2str(freq_list(i)*1000),'mhz_ampfirst'); %Attach note to file
    calfreq=freq_list(i); %Frequency of interest, ending (Ghz). Cannot be more than instrument frequency.
    phantomless_cal4_itr_gimped %Run program
end


for i=1:length(diode_list)
    mus=muslist(i);
    mua=mualist(i);
    pth=strcat(basepth,num2str(diode_list(i)));
    amp_first=0; %prioritizing phase
    sample_file=strcat('\PH010_19MM_100-1000MHZ-0100-dcswitch.asc'); %Opening msmt file
    calfile=strcat('\PH010_19MM_100-1000MHZ_MATCH-0100-dcswitch.asc'); %Opening calibrator file
    diode=diode_list(i); %Loop through list of diodes
    L_filter=L_list(i); %Loop through corresponding lengths of glass
    writenote=strcat('100-',num2str(freq_list(i)*1000),'mhz_phifirst'); %Attach note to file
    calfreq=freq_list(i); %Frequency of interest, ending (Ghz). Cannot be more than instrument frequency.
    phantomless_cal4_itr_gimped %Run program
end