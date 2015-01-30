%Settings
L_list=[4.6 5.35 7.18 7.18 7.18]; %Length of GLASS in calibrator
diode_list=[660 690 779 800 830]; %Wavelength used
strfrq=1000; %Counting down max freq, starting from (for file name)
calfreq=1; %Counting down max freq, starting from
calfreqstart=.05; %Frequency of interest, starting (Ghz). Cannot be less than instrument frequency.
    
%Looping
for i=1:length(diode_list)
    amp_first=1; %prioritizing amp
    sample_file=strcat(num2str(diode_list(i)),'nmACRIN2_23MM_50-1000MHZ.xls'); %Opening msmt file
    calfile=strcat(num2str(diode_list(i)),'nmACRIN2_23MM_50-1000MHZ_MATCH.xls'); %Opening calibrator file
    diode=diode_list(i); %Loop through list of diodes
    L_filter=L_list(i); %Loop through corresponding lengths of glass
    
    for j=0:9 %Will loop until max freq is reduced by 700 MHz
        writenote=strcat('50-',num2str(strfrq-j*100),'mhz_ampfirst'); %Attach note to file
        calfreq=1-j*.1; %Frequency of interest, ending (Ghz). Cannot be more than instrument frequency.
        phantomless_cal4_itr_gimped %Run program
    end
    
end

for i=1:length(diode_list)
    amp_first=0; %prioritizing phase
    sample_file=strcat(num2str(diode_list(i)),'nmACRIN2_23MM_50-1000MHZ.xls'); %Opening msmt file
    calfile=strcat(num2str(diode_list(i)),'nmACRIN2_23MM_50-1000MHZ_MATCH.xls'); %Opening calibrator file
    diode=diode_list(i); %Loop through list of diodes
    L_filter=L_list(i); %Loop through corresponding lengths of glass
    
    for j=0:9 %Will loop until max freq is reduced by 700 MHz
        writenote=strcat('50-',num2str(strfrq-j*100),'mhz_phifirst'); %Attach note to file
        calfreq=1-j*.1; %Frequency of interest, ending (Ghz). Cannot be more than instrument frequency.
        phantomless_cal4_itr_gimped %Run program
    end
    
end
