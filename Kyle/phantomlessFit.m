function [fitFreqRange,muaPredict,musPredict,ampPredict,phasePredict,freqset,normAmp,normPhi] = phantomlessFit( rhoPhantom, rhoSetup, glassThick, wavelength, dataPath,dataname,caldataname,dataFreqRange,fitFreqRange,muaRange,muaRes,musRange,musRes )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Constants
n_air = 1.0; %Index of refraction of air
n_filter = 1.5; %Index of refraction of glass
n = 1.43; %Index of refraction of sample
c = 2.9979*10^11;   %mm/s in air

% Rename variables
rho = rhoPhantom;
L_cal = rhoSetup;
L_filter = glassThick;
diode = wavelength;
freqstart = dataFreqRange(1);
freqend = dataFreqRange(2);
num = 401; %Instrument data points
polyN = 2; %Polynomial order to fit
polyfrq = .25; %Polynomial fit upper limit in Ghz
calfreqstart = fitFreqRange(1);
calfreq = fitFreqRange(2);
mua = muaRange(1):muaRes:muaRange(2);
mus = musRange(1):musRes:musRange(2);
fitIndexStart = floor((calfreqstart-freqstart)/((freqend-freqstart)/num)+1);
fitIndexEnd = floor((calfreq-freqstart)/((freqend-freqstart)/num));
fitRange = fitIndexStart:fitIndexEnd;
freqset = linspace(freqstart,freqend,num);

% Open Files
cd(dataPath)
datafile = importdata(strcat(dataPath,'\',dataname));
datafile.freq = datafile.Sheet1(:,1);
datafile.phi = datafile.Sheet1(:,2);
datafile.amp = datafile.Sheet1(:,3);
calfile = importdata(strcat(dataPath,'\',caldataname));
calfile.freq = calfile.Sheet1(:,1);
calfile.phi = calfile.Sheet1(:,2);
calfile.amp = calfile.Sheet1(:,3);

% Calibrate Files
% Amplitude
datafile.amp_sample = datafile.amp./calfile.amp;
rawamp = datafile.amp_sample;
normFactor1 = datafile.amp_sample(1);
normAmp = datafile.amp_sample/normFactor1;
% Phase
calfile.phase_offset = 360*datafile.freq*10^6*((L_cal-L_filter)/c/n_air+L_filter/c/n_filter);
calfile.phase_corrected = calfile.phi - calfile.phase_offset;
datafile.phi_sample = datafile.phi - calfile.phase_corrected;
rawphi = datafile.phi_sample;
normFactor2 = datafile.phi_sample(1);
normPhi = datafile.phi_sample-normFactor2;

cd('C:\Users\Kyle\Documents\GitHub\Phantomless-Code\VTS');
startup();

itr = 0;
errstart = 100000;
mu = [0 0];
totalitr = length(mua)*length(mus);
h = waitbar(0,strcat('0/',num2str(totalitr)));

for i=1:length(mua)
    for j=1:length(mus)
        itr = itr+1;
        phanop_itr=[mua(i),mus(j)];
        op_itr = [phanop_itr .8 n];
        VtsSolvers.SetSolverType('PointSourceSDA');
        vtsmod = VtsSolvers.ROfRhoAndFt(op_itr, rho, freqset);
        mod_amp = abs(vtsmod)/(abs(vtsmod(1)));
        mod_phi_raw = unwrap(-angle(vtsmod)*180/pi);
        mod_phi = mod_phi_raw-mod_phi_raw(1);
%         mod_phi = unwrap(mod_phi);
        
        erramp = sum(abs(normAmp(fitRange)-mod_amp(fitRange))./normAmp(fitRange));
        errphi = sum(abs(normPhi(fitRange)-mod_phi(fitRange))./norm(fitRange));
        totalerror = erramp+errphi;        
        if totalerror < errstart
            errstart = totalerror;
            mu = phanop_itr;
        else
            mu = mu;
        end
        progress = itr/totalitr;
        progtext = strcat(num2str(itr),'/',num2str(totalitr));
        waitbar(progress,h,sprintf(progtext));
    end
end
close(h)

op_fin = [mu .8 n];
VtsSolvers.SetSolverType('PointSourceSDA');
vtsmod = VtsSolvers.ROfRhoAndFt(op_fin, rho, freqset);
mod_amp = abs(vtsmod)/(abs(vtsmod(1)));
mod_phi_raw = unwrap(-angle(vtsmod)*180/pi);
mod_phi = mod_phi_raw-mod_phi_raw(1);
muaPredict = mu(1);
musPredict = mu(2);
ampPredict = mod_amp;
phasePredict = mod_phi;

end

