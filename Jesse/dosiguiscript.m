
clear fdpm
clear spec
clear physio
clear p
global guiVal;



%% FDPM Calibration Settings
fdpm.cal.which = 1;   
% selects the calibration method.  1 (off phantom) is standard.  
% 0 uncalibrated; 1 off phantom (multiple phantoms get averaged); 2 is 2 distance (not coded); 3 is multiple phantoms and autoselect by diode (phantoms do not get averaged)
% used in getFDPMCal.m

fdpm.cal.multi_phantom_freq = [75; 125]; 
%if using fdpm.cal.which = 3 (autoselect phantom)
% this is the frequency range over which to match amplitudes
% this is for a new calibration method we are testing that uses calibration
% method with closest matching amplitude
% used in getFDPMCal.m

fdpm.cal.phantoms=guiVal.phantomList; 
% files to use for calibration, if nFiles>1, files will be averaged together
% used in getFDPMCal.m

fdpm.cal.n = 1.4; 
% index of refraction of phantom
% used in getFDPMCal.m

fdpm.cal.model_to_fit =	'p1seminf';
% light transport model used to calculate theoretical phase and amplitude
% using known phantom optical properties
% p1seminf.m is standard model we use, other modified versions of the model
% can be found in ssfdpmPro\models
% used in getFDPMCal.m

fdpm.cal.rfixed = 0;  
% source-detector separation (mm) used to measure phantom
% if set to 0, program reads s-d separation from phantom measurement file
% otherwise file s-d will be ignored and this number used
% use by fdpm.cal.model_to_fit
% used in getFDPMCal.m

fdpm.cal.phantomdir = '';  %need ending \
% directory where phantom files are located (ssfdpmPro\phantoms)
% Because of way we set matlab path, this variable no longer necessary
% used in getFDPMCal.m


%% FDPM Settings
%fdpm.source = 'miniLBS';
fdpm.source=guiVal.source;
% this is just used for purposes of putting file paths together
% the source file extension is indicative of the instrumentation used in
% the measurement

%fdpm.diodes = [660 690 785 830]; 
fdpm.diodes = guiVal.fdpm_diodes;
% diode wavelengths to use for fdpm processing 
% must match wavelengths in measurement files
% in some cases with noisy data, diodes can be taken out to improve the
% subsequent broadband and physio fits
% used when reading the fdpm calibration files in, reading the fdpm
% measurement files in, and calculating the theoretical reflectance using 
% the fdpm recovered optical properties (getReflectance.m)

fdpm.n = 1.4;
% index of refraction to use for measurement files
% required by p1 model when doing fdpm fit
% fitFDPM.m -> mufit.m 

fdpm.boundary_option = 1;  %0 for reff polynomial, 1 for lookup
% option for method used to calculate reff in p1seminf.m

% fdpm.model_to_fit =	'vpSDA';%'p1seminfnorm';
fdpm.model_to_fit =	'p1seminfnorm';
% fdpm.model_to_fit = 'p1supernorm'; %Taken out for jessie
% model used for fdpm fit, calibrated phase and amplitude are main inputs
% inverse optimization yields optical properties
% fitFDPM.m -> mufit.m 

fdpm.stderr=[0.03, 0.3]; 
% used to give an estimate of error when dealing with a single file
% with multiple files, values are averaged and standard deviation
% calculated
% used when reading in fdpm files averageFDPMDataAtDiodes.m

fdpm.freqrange = [guiVal.lowFreq; guiVal.highFreq]; 
% frequency range to use in fdpm fitting
% all measured frequencies can be used but smaller frequency sets are
% sometimes required when data is noisy
% windowing the frequency results in windowing of the amplitude and phase
% arrays

fdpm.opt.rfixed = 17.5;
% source-detector separation (mm) used during measurement
% if set to 0, program reads s-d separation from measurement file
% otherwise file s-d will be ignored and this number used
% needed for fdpm.model_to_fit 


fdpm.opt.param = [1,1];	%fit mua?	%fit mus?  
% legacy variable that allowed for fitting of only mua or mus
% not currently coded

fdpm.opt.holdmus=0; 
% for processing of multiple measurements, will hold mus constant after 
% averaging n measurements where n=holdmus
% setting used sometimes for research purposes in cases where mus should
% be constant

fdpm.opt.mus_robust = 1; 
% bool, on or off
% turning on will weight the recovered fdpm mus at each wavelength
% during the powerlaw scattering fit
% weight is determined by the chi sq from the fdpm fit 
% fitSSFDPM.m -> fdpmFitScat.m

fdpm.opt.imagfit = 0;	   		
% 1 is real/im fit, 0 is amp/phase fit
% when fitting fdpm data, model can use either real/imaginary data or
% phase/amplitude
% standard use is real/imaginary

fdpm.opt.err = 3;			
% Weight in mu fit: 1 from experimental err; 2 standard err (see fdpm.lev.se_..; 3 use flat WEIGHT

fdpm.opt.jumps = 1;      
% bool
% occasionally see errors in unwrapping phase, turning on this setting will
% automatically try to eliminate phase jumps in data

fdpm.opt.chisqok = 0;   
% if chisquare is less than this, don't loop anymore
% we do 5 fdpm fits using different initial guesses, this is often
% unnecessary so we have additional criteria which can stop the fdpm fit
% fitFDPM.m -> mufit.m

%% Physio Fit Settings
physio.fdpm.fit = guiVal.doPhysioFdpmFit;    
% bool
% fit phsyio from fdpm wavelengths?
% in some cases we are only interested in fitting for optical properties

physio.spec.fit = guiVal.doPhysioSpecFit;    
% bool
% fit physio from spec?
% in some cases we are only interested in fitting for optical properties

physio.spec.baseline = 1; 
% bool
% adds an additional constant to fit to during the physio fit
% standard is on, we've found that this aids in fitting 
% chromophore values
% note: this variable isn't used, was meant to replace spec.opt.baseline
% to make code more clear

physio.chrom.file = 'chromophores_Zijlstra.600.txt'; 
% files located in ssfdpmPro\chromophore_files
% contain extiction coefficients of chromophores 
% different files can be used for different chromophores
% can also have extiction coefficients of same chromophores found from
% different sources

physio.chrom.names = {'HbO2', 'Hb', 'h2oFrac', 'fatFrac', 'Met','CO','Evans','MB','bkgd'};  
% names of chromophores found in chromophore file

physio.chrom.units = {'uM', 'uM', '%', '%', 'uM','uM','uM','uM','uM'};
% units to use for chomophores found in chomophore file

physio.chrom.mult = [10^3; 10^3; 100; 100; 10^3;10^3;10^3;10^3;10^3];
% conversion multiplier to use after fitting chromophores concentrations

physio.chrom.mins = [0;0;0;0;0;0;0;0];
physio.chrom.maxs = [.1;.1;1;1;.1;.1;0;0];
% if physio.fittype is constrained (see below) these variables set the
% lower and upper bounds of the fit

physio.chrom.selected = [1,1,0,0,0,0,0,0];
% sets which chromophores from the physio.chrom.names array are used in the fittings

physio.fittype = 3; 
% method for fitting physio
%                 0   is simple least squares
%                 1   is weighted least squares ( by fitted mua error)
%                 2   simple SVD
%                 3    constrained LSQ (positive only)
%                 4    constrained LSQ


%% Bound Water Settings
% these settigns represent an additional module that determines the
% concentration of bound water
% this module is not commonly used 
bw.fit = 0; %fit bound water?
bw.conc_guess = [0 .1 .1 .1 .1 .1 0 0 0];      % baseline, water, fat, nigrosin, Hb, HbO2, silicone, ethanol
bw.conc_en =    [1 1 1 0 1 1 0 0 0];
bw.specDir = '';
bw.ubc = 998;   %upperbound for concentration window nm
bw.lbc = 650;      % lowerbound for concentration window nm
bw.temp = 36;  %60?
bw.bw_guess= 0;
bw.peak_guess = 973;  %water peak location at 35 C
bw.refwl = 935;  

%% Spec Settings
spec.on=guiVal.doSpecFit;
% bool
% do broadband fit after fdpm fit? 
% many times we do fdpm only studies or have circumstances in which we want
% to ignore the broadband data

spec.source='tis';
spec.suffix='.asc';
% spec file naming, just used for setting up file paths, standardardized

spec.usediodes = guiVal.use_diodes_spec;
% array of bools
% array that specifies which fdpm diodes are used for the broadband fit
% nomrally same diodes are used but in cases of noise, fdpm diodes can be
% eliminated

spec.cal.sphere = guiVal.sphereList;  
% reflectance calibration file(s) to be used for sphere calibration

spec.cal.dark = {}; 
spec.dark = {}; 
% legacy variables used before we saved broadband data with the dark
% already subtracted

spec.opt.rfixed=0;
% source-detector separation (mm) used during broadband measurement
% if set to 0, program reads s-d separation from measurement file
% otherwise file s-d will be ignored and this number used
% used by reflectance model in fitSSFDPM.m

spec.opt.spike = 1;
spec.opt.spikewindow = 1;
spec.opt.boxcar = 1;
% above options allow for smoothing the reflectance spectra
% getReflectance.m

spec.opt.lambdashift = 0;
% allows for shift of wavelengths and corresponding data
% not used

spec.opt.docal = 1;  
% bool
% do sphere/reflectance standard calibration
% standard is always on

spec.opt.baseline = 0;
% bool
% adds an additional constant to fit to during the bb physio fit
% standard is on, we've found that this aids in fitting 
% chromophore values physioSetup.m

spec.opt.mua_robust = 1;  
% bool
% turning on will weight the fitting of the broadband reflectance to the
% calculated reflectance at the fdpm diodes
% weight is determined by the chi sq from the fdpm fit 
% getReflectance.m 

spec.wvrange = (650:1:1000);
% broadband wavelengths to use in processing

spec.mua_guess = [0.08,0.005];  	
% initial guesses for broadband mua fit
% fitSSFDPM.m

%%General Settings
p.files=guiVal.prefixList;
% measurement file list

p.repnum = 0;
% allows multiple measurements at single location to be averaged

p.rootdir=guiVal.rootDir;
% root data directory

p.patientID=guiVal.patientID;
% patient id in directory

p.date=guiVal.date;
% date in directory

p.outLabel=['pt' guiVal.patientID '_' guiVal.date '_' guiVal.filePrefix];
% name appended to output files

p.verbose = 1;
% turns on console output

p.graphing = 1;
% turns on graphing during processing

p.savefitgraphs=1;
% saves graphs to file

p.fileWrite=1;
% saves output files

p.gridimager=0;
% runs additional gridimager module

%%Run Processing
error = ssfdpmPRO(fdpm,spec,physio,bw,p);
save(p.outLabel,'fdpm','spec','physio','bw','p');

% newly added code for running grid imager module
% not yet used
if(p.gridimager)
    try
        giscript_ssfdpmpro(p,'L');
    catch ME
        disp('error with left side');
    end
    try
        giscript_ssfdpmpro(p,'R');
    catch ME
        disp('error with right side');
    end
end


