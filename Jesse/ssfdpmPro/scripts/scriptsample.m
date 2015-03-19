clear fdpm
clear spec
clear physio
clear p

%% FDPM Calibration Settings
fdpm.cal.which = 1;   %0 uncalibrated; 1 off phantom; 2 is 2 distance (not coded)
fdpm.cal.phantoms = {'ph010-1' 'ph010-2' 'ph010-3'}; 
fdpm.cal.n = 1.43;
fdpm.cal.model_to_fit =	'p1seminf';
fdpm.cal.rfixed = 21.5;  %0 read r listed in data file; otherwise use # as actual dist in mm
fdpm.cal.phantomdir = 'C:\Documents and Settings\temp\Desktop\proGUI\phantoms\';  %need ending \  %just put in path?

%% FDPM Settings
fdpm.source= 'dcswitch';
fdpm.diodes = [658 682 785 810 830 850];  %diodes to use for fdpm
fdpm.n = 1.4;
fdpm.boundary_option = 1;  %0 for reff polynomial, 1 for lookup
fdpm.model_to_fit =	'p1seminf';
fdpm.stderr=[0.03, 0.3];   %used if only single point
fdpm.freqrange = [50; 400];


fdpm.opt.rfixed = 28.5;  %0 read r listed in data file; otherwise use # as actual dist in mm
fdpm.opt.param = [1,1];	%fit mua?	%fit mus?  (Only used in nonconstrained fit) (currently not coded)
fdpm.opt.mus_robust = 0; %weight mus  by chi sq in scat fit
fdpm.opt.imagfit = 1;	   		%1 is real/im fit, 0 is amp/phase fit
fdpm.opt.err = 3;			%Weight in mu fit: 1 from experimental err; 2 standard err (see fdpm.lev.se_..; 3 use flat WEIGHT
fdpm.opt.jumps = 1;      %tries to eliminate extra phase jumps that occur in noisy data
fdpm.opt.chisqok = 1;   %if chisquare is less than this, don't loop anymore

%% Physio Fit Settings
physio.fdpm.fit = 1;    %fit phsyio from fdpm wavelengths?
physio.spec.fit = 1;    %fit physio from spec?
physio.spec.baseline = 1; 
physio.chrom.file = 'C:\doscode\SSFDPM\consts_and_funcs\chromophore_files\chromophores_Zijlstra.600.txt';   %just put in path?
physio.chrom.names = {'HbO2', 'Hb', 'h2oFrac', 'fatFrac', 'Met','CO','Evans','MB','bkgd'};  %%load all this stuff from chrom file?
physio.chrom.units = {'uM', 'uM', '%', '%', 'uM','uM','uM','uM','uM'};
physio.chrom.mult = [10^3; 10^3; 100; 100; 10^3;10^3;10^3;10^3;10^3];
physio.chrom.mins = [0;0;0;0;0;0;0;0];
physio.chrom.maxs = [.1;.1;1;1;.1;.1;0;0];
physio.chrom.selected = [1,1,1,1,0,0,0,0];
physio.fittype = 3; 
%                 0   is simple least squares
%                 1   is weighted least squares ( by fitted mua error)
%                 2   simple SVD
%                 3    constrained LSQ (positive only)
%                 4    constrained LSQ

%% Bound Water Settings
bw.fit = 0; %fit bound water?
bw.conc_guess = [0 .1 .1 .1 .1 .1 0 0 0];      % baseline, water, fat, nigrosin, Hb, HbO2, silicone, ethanol
bw.conc_en =    [1 1 1 0 1 1 0 0 0];
bw.specDir = 'C:\Documents and Settings\temp\Desktop\ssfdpmPro\bw\specdata\';  %just put in path?
bw.ubc = 998;   %upperbound for concentration window nm
bw.lbc = 650;      % lowerbound for concentration window nm
bw.temp = 36;  %60?
bw.bw_guess= 0;
bw.peak_guess = 973;  %water peak location at 35 C
bw.refwl = 935;  

%% Spec Settings
spec.on=1;
spec.source='tis';
spec.suffix='.asc';
%spec.diodes = [658 682 785 810 830 850];  %diodes to use for ssfdpm
spec.usediodes = [1 1 1 1 1 1];
%spec.diodes = [658 682 785 810 830];
spec.cal.sphere = {'rc01-1-sph'};  %change later for multiple
spec.cal.dark = {};
spec.dark = {};
spec.opt.rfixed=29;
spec.opt.spike = 1;
spec.opt.spikewindow = 1;
spec.opt.boxcar = 1;
spec.opt.lambdashift = 0;
spec.opt.docal = 1;  %do sphere/reflectance standard calibration
spec.opt.baseline = 1;
spec.opt.mua_robust = 1;   %use weighting of fd errors for ss
spec.wvrange = (650:.5:998);
spec.mua_guess = [0.08,0.005];  	% 1st and second initial guess for mua computation

%%General Settings
p.files={'LN010P050B'};   %will need to do something with averaging files later on
p.repnum = 1;
p.rootdir='C:\Documents and Settings\temp\Desktop\Data';
p.patientID='2306-45';
p.date='070719';
p.outLabel = 'test';
p.verbose = 1;
p.graphing = 1;
p.fileWrite=1;

%%Run Processing
error = ssfdpmPRO(fdpm,spec,physio,bw,p);
