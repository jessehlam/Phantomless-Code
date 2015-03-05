defaultdir=pwd;
L_cal=96; %Rho in calibrator
n_air = 1.0; %Index of refraction of air
n_filter = 1.5; %Index of refraction of glass
n = 1.43; %Index of refraction of sample
c = 2.9979*10^11;   %mm/s in air
num=401; %Number of data points
polyN=2; %Order of the polynomial that is fit to the amplitude and phase (for normalization)
polyfrq=.25; %Frequency at which the polynomial fits the amplitude and phase up to
vtsdir='C:\Users\Jesse\Desktop\Phantomless-Code\VTS';
plots=0; %Turns plotting on or off
plotraws=0; %Plot the raw data?
    plotrawcal=1; %Plot the raw non-normalized, calibrated data?
plotfit=1; %Plot the polynomial fits?
highfrqdata=0; %Calibrate using high frequency data?
simdat=0; %Use simulated, test data?
write2file=1; %Write results to file? (saved in same dir as this .m file)
freqstep=(freqend-freqstart)/num; %The step size in GHz
frqnum2=floor((calfreqstart-freqstart)/freqstep)+1; %The element number containing the calibration frequency, starting
frqnum=floor((calfreq-freqstart)/freqstep); %The element number containing the calibration frequency, ending
polyfrq=floor((polyfrq-freqstart)/freqstep); %The element number containing the calibration frequency for the poly fit
ft = linspace(freqstart,freqend,num); %Frequency set

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