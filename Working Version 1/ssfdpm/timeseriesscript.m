for goutidiot = 1:1
clear fdpm
clear spec
clear physio
clear p
global guiVal;
%% FDPM Calibration Settings
fdpm.cal.which = 1;   %0 uncalibrated; 1 off phantom; 2 is 2 distance (not coded)
%fdpm.cal.phantoms = {strcat('ph010-d1-1') strcat('ph010-d1-2') strcat('ph010-d1-3')}; 
fdpm.cal.phantoms={'iss4-3'};
%fdpm.cal.phantoms = {strcat('phskin2-', rho, '-1') strcat('phskin2-', rho, '-2') strcat('phskin2-', rho, '-3')}; 
fdpm.cal.n = 1.43;
fdpm.cal.model_to_fit =	'p1seminf';
%fdpm.cal.model_to_fit =	'miRofFt';
fdpm.cal.rfixed = 13;  %0 read r listed in data file; otherwise use # as actual dist in mm
fdpm.cal.phantomdir = '';  %need ending \

%% FDPM Settings
fdpm.source= 'miniLBS';
%fdpm.diodes = [684 782 826]; %diodes to use for fdpm using mini-LBS 
%fdpm.diodes = [656 687 783 814 824 852];  %diodes to use for fdpm using LBS3
fdpm.diodes = [656 684 782 826];  %diodes to use for fdpm using LBS5
fdpm.n = 1.4;
fdpm.boundary_option = 1;  %0 for reff polynomial, 1 for lookup
fdpm.model_to_fit =	'p1seminf';
%fdpm.model_to_fit =	'miRofFt';
%fdpm.stderr=[0.01, 1];   %used if only single point
fdpm.stderr=[0.03, 0.3]; 
fdpm.freqrange = [150; 300];


fdpm.opt.rfixed = 13;  %0 read r listed in data file; otherwise use # as actual dist in mm
fdpm.opt.param = [1,1];	%fit mua?	%fit mus?  (Only used in nonconstrained fit) (currently not coded)
fdpm.opt.mus_robust = 1; %weight mus  by chi sq in scat fit
fdpm.opt.imagfit = 1;	   		%1 is real/im fit, 0 is amp/phase fit
fdpm.opt.err = 3;			%Weight in mu fit: 1 from experimental err; 2 standard err (see fdpm.lev.se_..; 3 use flat WEIGHT
fdpm.opt.jumps = 1;      %tries to eliminate extra phase jumps that occur in noisy data
fdpm.opt.chisqok = 1;   %if chisquare is less than this, don't loop anymore

%% Physio Fit Settings
physio.fdpm.fit = 1;    %fit phsyio from fdpm wavelengths?
physio.spec.fit = 1;    %fit physio from spec?
physio.spec.baseline = 1; 
physio.chrom.file = 'chromophores_Zijlstra.600.txt'; 
physio.chrom.names = {'HbO2', 'Hb', 'h2oFrac', 'fatFrac', 'Met','CO','Evans','MB','bkgd'};  %%load all this stuff from chrom file?
physio.chrom.units = {'uM', 'uM', '%', '%', 'uM','uM','uM','uM','uM'};
physio.chrom.mult = [10^3; 10^3; 100; 100; 10^3;10^3;10^3;10^3;10^3];
physio.chrom.mins = [0;0;0;0;0;0;0;0];
physio.chrom.maxs = [.1;.1;1;1;.1;.1;0;0];
physio.chrom.selected = [1,1,1,1,0,0,0,0];
% physio.chrom.file = 'chromophores_vanveen_water36c_zijlstra_sophie.txt'; 
% physio.chrom.names = {'fatFrac', 'h2oFrac', 'HbO2', 'Hb', 'bkgd'};  %%load all this stuff from chrom file?
% physio.chrom.units = {'%', '%', 'uM', 'uM', 'uM','uM','uM','uM','uM'};
% physio.chrom.mult = [ 100; 100; 10^3; 10^3; 10^3;10^3;10^3;10^3;10^3];
% physio.chrom.mins = [0;0;0;0;0;0;0;0];
% physio.chrom.maxs = [1;1;.1;.1;.1;.1;0;0];
% physio.chrom.selected = [1,1,1,1,0,0,0,0];
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
bw.specDir = '';
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
spec.usediodes = [1 1 1 1];
spec.cal.sphere = {'rc20a-2-sph'};  %only 1!
spec.cal.dark = {}; %leave empty, will appened -dark to sphere name
spec.dark = {}; %leave empty to autodark if needed
spec.opt.rfixed=13;
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
%p.files={'RP000P090A'};   %will need to do something with averaging files later on
if goutidiot == 1
    for i=1:1620
        p.files{i} = strcat('EK_lip_inf_thenar-', num2str(i));
    end
elseif goutidiot == 2
    for i=1:1515
        p.files{i} = strcat('PH_lip_inf_thenar2-', num2str(i));
    end    
elseif goutidiot == 3
    for i=1:315
        p.files{i} = strcat('PH_lip_inf_thenar3-', num2str(i));
    end
end

p.repnum = 0;
% p.rootdir='C:\fdpm.data\data.breast';
% p.patientID='563-291';
% p.date='071005';
% p.outLabel = 'bwtest';
p.rootdir='C:\Users\Rob Warren\Desktop\data\Applications'; %root directory
p.patientID='Lipid Infusion'; %subfolder1
p.date='120223'; %subfolder2
if goutidiot == 1
    p.outLabel = strcat('lipid_EK'); %notes for tagging results from processing
elseif goutidiot == 2
    p.outLabel = strcat('lipid_PH2'); %notes for tagging results from processing 
elseif goutidiot == 3
    p.outLabel = strcat('lipid_PH3'); %notes for tagging results from processing
end
p.verbose = 1;
p.graphing = 0;
p.fileWrite=1;

%%Run Processing

error = ssfdpmPRO(fdpm,spec,physio,bw,p);
save(p.outLabel,'fdpm','spec','physio','bw','p');
end
