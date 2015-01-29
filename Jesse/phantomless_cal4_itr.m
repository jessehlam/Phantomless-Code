%dbstop if error;



%% Pop ups
%Add the VTS files to the MATLAB path

defaultdir=pwd; %Keep current directory to return to after program finishes
mpth=mfilename('fullpath'); %Get path of current m file
mname=mfilename; %Getting name of function to remove from path
mpth=mpth(1:length(mpth)-length(mfilename)); %Removing filename from path
cd(mpth); %Change dir to this script path

if exist('output','var')==1 && length(output)==4 && exist('pth','var')==1 && pth(1)>0; %If there was a previous processing
    clearvars -except output pth defaultdir %Keep previous values
    default={output{1},output{2},output{3},output{4}}; %Input previous values
else %If fresh processing
    clearvars -except defaultdir
    default={'23','96','5','800'}; %Default values displayed per box
    pth='\\128.200.57.212\Photon Portal\Data\data.phantomless';
end

%Measurement values
diag={'Enter rho on Phantom (mm)',... %Text in the dialog
    'Enter rho on Setup (mm)','Enter thickness of glass (mm)',...
    'Enter the diode wavelength (nm)'};
boxdisp=''; %Dialog title
lines=1; %Number of lines per input box
output=inputdlg(diag,boxdisp,lines,default); %Output variable

rho=str2double(output{1}); %Rho on phantom
L_cal=str2double(output{2}); %Rho in calibrator
L_filter=str2double(output{3}); %Length of GLASS in calibrator
diode=str2double(output{4}); %Wavelength used

%% Parameters
n_air = 1.0; %Index of refraction of air
n_filter = 1.5; %Index of refraction of glass
n = 1.43; %Index of refraction of sample
c = 2.9979*10^11;   %mm/s in air

freqstart=.05; %Instrument starting frequency (GHz)
freqend=1; %Instrument ending frequency (GHz)
num=401; %Number of data points
polyN=2; %Order of the polynomial that is fit to the amplitude and phase (for normalization)
polyfrq=.20; %Frequency at which the polynomial fits the amplitude and phase up to
vtsdir='C:\Users\Jesse\Desktop\Phantomless-Code\VTS';

%% Options
plots=1; %Turns plotting on or off
plotraws=1; %Plot the raw data?
    plotrawcal=1; %Plot the raw non-normalized, calibrated data?
plotfit=1; %Plot the polynomial fits?
highfrqdata=0; %Calibrate using high frequency data?
simdat=0; %Use simulated, test data?
write2file=1; %Write results to file? (saved in same dir as this .m file)
    writenote='50-1000mhz'; %Attach note to file

calfreqstart=.05; %Frequency of interest, starting (Ghz). Cannot be less than instrument frequency.
calfreq=1; %Frequency of interest, ending (Ghz). Cannot be more than instrument frequency.
mua=.005:.0001:.01; %Range and resolution of MUa, based on typical physiological values for human tissue
mus=.5:.001:1.5; %Range and resolution of MUs, based on typical physiological values for human tissue

%% Some calculations
freqstep=(freqend-freqstart)/num; %The step size in GHz
frqnum2=floor((calfreqstart-freqstart)/freqstep)+1; %The element number containing the calibration frequency, starting
frqnum=floor((calfreq-freqstart)/freqstep); %The element number containing the calibration frequency, ending
polyfrq=floor((polyfrq-freqstart)/freqstep); %The element number containing the calibration frequency for the poly fit
ft = linspace(freqstart,freqend,num); %Frequency set

%% Selecting the sorting the tissue and calibrator measurements
if simdat==0
    [samp, pth, filterindex] = uigetfile({'*.xls';'*.asc'},'Select Both Sample and Calibration Files','MultiSelect', 'on',pth);
    if filterindex==0;
        error('Invalid File Selection')
    end

    whichfile=strfind(samp{1},'MATCH'); %File with "MATCH" is from the calibrator
    foundit=isempty(whichfile); %Returns a number or a 0 if found or not, respectively

    if foundit==0 %Sorting which file is match and which is sample
        sample_file=samp{2};
        calfile=samp{1};
    else
        sample_file=samp{1};
        calfile=samp{2};
    end
end

%% Running the next scripts

%opening higher frequency data
if highfrqdata == 1
    openhighfrq
end

%Importing data
if simdat==0
    openfiles
end

%Calibrating
if simdat==1
    cd(pth)
    calibration_sim %If using simulated data
else
    calibration_itr %Calibrates out system response
end

%Calibrating high frq data
if highfrqdata == 1
    highfrq
end

%Recover optical properties
model_lookup_itr2 %Attempts to recovers optical properties

% Plotting
if simdat==0
    plotter %Comment out if using simulated data
end