
% 
% for system = 2:2
% for calibration = 1:10

close all
clear fdpm
clear spec
clear physio
clear p

%global guiVal;
%% FDPM Calibration Settings
fdpm.cal.which = 1;   %0 uncalibrated; 1 off phantom; 2 is 2 distance (not coded)

% if calibration == 1
%     fdpm.cal.phantoms={'ph013-1'};
% elseif calibration == 2
%     fdpm.cal.phantoms={'ph013-2'};
% elseif calibration == 3
%     fdpm.cal.phantoms={'ph013-3'};
% elseif calibration == 4
%     fdpm.cal.phantoms={'ph013-4'};
% elseif calibration == 5
%     fdpm.cal.phantoms={'ph013-5'};
% elseif calibration == 6
%     fdpm.cal.phantoms={'ph013-6'};
% elseif calibration == 7
%     fdpm.cal.phantoms={'ph013-7'};
% elseif calibration == 8
%     fdpm.cal.phantoms={'ph013-8'};
% elseif calibration == 9
%     fdpm.cal.phantoms={'ph013-9'};
% elseif calibration == 10
%     fdpm.cal.phantoms={'ph013-10'};
% end

fdpm.cal.phantoms={'ph010-10mm-1' 'ph010-10mm-2'};

% if calibration == 1
%     fdpm.cal.phantoms={'ph010-1' 'ph010-2' 'ph010-3' 'ph010-4' 'ph010-5' 'ph010-6' 'ph010-7' 'ph010-8' 'ph010-9' 'ph010-10'};
% elseif calibration == 2
%     fdpm.cal.phantoms={'ph010-3' 'ph010-4' 'ph010-5' 'ph010-8' 'ph010-9' 'ph010-10'};
% elseif calibration == 3
%     fdpm.cal.phantoms={'cavs1-1' 'cavs1-2' 'cavs1-3' 'cavs1-4' 'cavs1-5' 'cavs1-6' 'cavs1-7' 'cavs1-8' 'cavs1-9' 'cavs1-10'};
% elseif calibration == 4
%     fdpm.cal.phantoms={'cavs2m-1' 'cavs2m-2' 'cavs2m-3' 'cavs2m-4' 'cavs2m-5' 'cavs2m-6' 'cavs2m-7' 'cavs2m-8' 'cavs2m-9' 'cavs2m-10'};
% elseif calibration == 5
%     fdpm.cal.phantoms={'acrin1-1' 'acrin1-2' 'acrin1-3' 'acrin1-4' 'acrin1-5' 'acrin1-6' 'acrin1-7' 'acrin1-8' 'acrin1-9' 'acrin1-10'};
% elseif calibration == 6
%     fdpm.cal.phantoms={'acrin2-1' 'acrin2-2' 'acrin2-3' 'acrin2-4' 'acrin2-6' 'acrin2-7' 'acrin2-8' 'acrin2-9' 'acrin2-10'};
% elseif calibration == 7
%     fdpm.cal.phantoms={'ino1-1' 'ino1-2' 'ino1-3' 'ino1-4' 'ino1-5' 'ino1-6' 'ino1-7' 'ino1-8' 'ino1-9' 'ino1-10'};
% elseif calibration == 8
%     fdpm.cal.phantoms={'iss4-1' 'iss4-2' 'iss4-3' 'iss4-4' 'iss4-5' 'iss4-6' 'iss4-7' 'iss4-8' 'iss4-9'};
% end

%fdpm.cal.phantoms={'ph010-1' 'ph010-2' 'ph010-3' 'ph010-4' 'ph010-5' 'ph010-6' 'ph010-7' 'ph010-8' 'ph010-9' 'ph010-10'};
%fdpm.cal.phantoms = {strcat('phskin2-', rho, '-1') strcat('phskin2-', rho, '-2') strcat('phskin2-', rho, '-3')}; 
fdpm.cal.n = 1.43;
fdpm.cal.model_to_fit =	'p1seminf';
%fdpm.cal.model_to_fit =	'miRofFt';
fdpm.cal.rfixed = 10;  %0 read r listed in data file; otherwise use # as actual dist in mm
fdpm.cal.phantomdir = '';  %need ending \

%% FDPM Settings
% if system == 1
     fdpm.source= 'dcswitch';
% elseif system == 2
%    fdpm.source= 'miniLBS';
% end

%fdpm.diodes = [684 782 826]; %diodes to use for fdpm using mini-LBS 
% if system == 1
     fdpm.diodes = [656 687 779 814 824 852];  %diodes to use for fdpm using LBS3
% elseif system == 2
%    fdpm.diodes = [660 690 785 830];  %diodes to use for fdpm using LBS5
% end

fdpm.n = 1.4;
fdpm.boundary_option = 1;  %0 for reff polynomial, 1 for lookup
fdpm.model_to_fit =	'p1seminf';
%fdpm.model_to_fit =	'miRofFt';
%fdpm.stderr=[0.01, 1];   %used if only single point
fdpm.stderr=[0.03, 0.3]; 
fdpm.freqrange = [50; 350];


fdpm.opt.rfixed = 10;  %0 read r listed in data file; otherwise use # as actual dist in mm
fdpm.opt.param = [1,1];	%fit mua?	%fit mus?  (Only used in nonconstrained fit) (currently not coded)
fdpm.opt.mus_robust = 0; %weight mus  by chi sq in scat fit
fdpm.opt.imagfit = 1;	   		%1 is real/im fit, 0 is amp/phase fit
fdpm.opt.err = 3;			%Weight in mu fit: 1 from experimental err; 2 standard err (see fdpm.lev.se_..; 3 use flat WEIGHT
fdpm.opt.jumps = 1;      %tries to eliminate extra phase jumps that occur in noisy data
fdpm.opt.chisqok = 1;   %if chisquare is less than this, don't loop anymore

%% Physio Fit Settings
physio.fdpm.fit = 0;    %fit phsyio from fdpm wavelengths?
physio.spec.fit = 0;    %fit physio from spec?
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
spec.on=0;
spec.source='tis';
spec.suffix='.asc';
%spec.diodes = [658 682 785 810 830 850];  %diodes to use for ssfdpm
% if system == 1
 %    spec.usediodes = [1 1 1 1 1 1];
% elseif system == 2
    spec.usediodes = [1 1 1 1];
% end


spec.cal.sphere = {strcat('rc01-1-sph')};  %only 1!
spec.cal.dark = {}; %leave empty, will appened -dark to sphere name
spec.dark = {}; %leave empty to autodark if needed
spec.opt.rfixed=22;
spec.opt.spike = 1;
spec.opt.spikewindow = 1;
spec.opt.boxcar = 1;
spec.opt.lambdashift = 0;
spec.opt.docal = 1;  %do sphere/reflectance standard calibration
spec.opt.baseline = 1;
spec.opt.mua_robust = 1;   %use weighting of fd errors for ss

spec.wvrange = (650:.5:1000);

spec.mua_guess = [0.08,0.005];  	% 1st and second initial guess for mua computation

%%General Settings
%p.files={'RP000P090A'};   %will need to do something with averaging files later on
%p.files = {strcat('rob-then-', num2str(iteration)), strcat('rob-for-', num2str(iteration)), strcat('rob-tri-', num2str(iteration)), strcat('rob-upab-', num2str(iteration)), strcat('rob-lowab-', num2str(iteration)), strcat('sor-then-', num2str(iteration)), strcat('sor-for-', num2str(iteration)), strcat('sor-tri-', num2str(iteration)), strcat('sor-upab-', num2str(iteration)), strcat('sor-lowab-', num2str(iteration))};

%p.files = {'acrin1-1', 'acrin1-2', 'acrin1-3', 'acrin2-1', 'acrin2-2', 'acrin2-3', 'ph013-1', 'ph013-2', 'ph013-3', 'ino1-1', 'ino1-2', 'ino1-3', 'ino14-1', 'ino14-2', 'ino14-3'};

%NEED TO FINISH PUTTING IN PHANTOM NAMES!!!!

    for i = 1:2
        p.files{i} = strcat('alox-10mm-', num2str(i));
    end
% 
% if calibration == 1
%     for i = 1:10
%         p.files{i} = strcat('ph013-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+10} = strcat('cavs1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+20} = strcat('cavs2m-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+30} = strcat('acrin1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+40} = strcat('acrin2-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+50} = strcat('ino1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+60} = strcat('ino14-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+70} = strcat('iss4-', num2str(i));
%     end
% elseif calibration == 2
%     for i = 1:10
%         p.files{i} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+10} = strcat('cavs1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+20} = strcat('cavs2m-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+30} = strcat('acrin1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+40} = strcat('acrin2-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+50} = strcat('ino1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+60} = strcat('ino14-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+70} = strcat('iss4-', num2str(i));
%     end
% elseif calibration == 3
%     for i = 1:10
%         p.files{i} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+10} = strcat('ph013-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+20} = strcat('cavs2m-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+30} = strcat('acrin1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+40} = strcat('acrin2-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+50} = strcat('ino1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+60} = strcat('ino14-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+70} = strcat('iss4-', num2str(i));
%     end
% elseif calibration == 4
%     for i = 1:10
%         p.files{i} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+10} = strcat('ph013-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+20} = strcat('cavs1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+30} = strcat('acrin1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+40} = strcat('acrin2-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+50} = strcat('ino1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+60} = strcat('ino14-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+70} = strcat('iss4-', num2str(i));
%     end
% elseif calibration == 5
%     for i = 1:10
%         p.files{i} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+10} = strcat('ph013-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+20} = strcat('cavs1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+30} = strcat('cavs2m-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+40} = strcat('acrin2-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+50} = strcat('ino1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+60} = strcat('ino14-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+70} = strcat('iss4-', num2str(i));
%     end
% elseif calibration == 6
%     for i = 1:10
%         p.files{i} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+10} = strcat('ph013-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+20} = strcat('cavs1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+30} = strcat('cavs2m-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+40} = strcat('acrin1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+50} = strcat('ino1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+60} = strcat('ino14-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+70} = strcat('iss4-', num2str(i));
%     end
% elseif calibration == 7
%     for i = 1:10
%         p.files{i} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+10} = strcat('ph013-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+20} = strcat('cavs1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+30} = strcat('cavs2m-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+40} = strcat('acrin1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+50} = strcat('acrin2-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+60} = strcat('ino14-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+70} = strcat('iss4-', num2str(i));
%     end
% elseif calibration == 8
%     for i = 1:10
%         p.files{i} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+10} = strcat('ph013-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+20} = strcat('cavs1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+30} = strcat('cavs2m-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+40} = strcat('acrin1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+50} = strcat('acrin2-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+60} = strcat('ino1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+70} = strcat('ino14-', num2str(i));
%     end
% end

% 
% if calibration == 1
%     for i = 1:10
%         p.files{i} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+10} = strcat('cavs1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+20} = strcat('cavs2m-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+30} = strcat('acrin1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+40} = strcat('acrin2-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+50} = strcat('ino1-', num2str(i));
%     end
% %     for i = 1:10
% %         p.files{i+60} = strcat('ino14-', num2str(i));
% %     end
%     for i = 1:10
%         p.files{i+60} = strcat('iss4-', num2str(i));
%     end
%     p.files{71} = 'ph013-3';
%     p.files{72} = 'ph013-4';
%     p.files{73} = 'ph013-5';
%     p.files{74} = 'ph013-8';
%     p.files{75} = 'ph013-9';
%     p.files{76} = 'ph013-10';
% elseif calibration == 2
%     for i = 1:10
%         p.files{i} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+10} = strcat('cavs1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+20} = strcat('cavs2m-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+30} = strcat('acrin1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+40} = strcat('acrin2-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+50} = strcat('ino1-', num2str(i));
%     end
% %     for i = 1:10
% %         p.files{i+60} = strcat('ino14-', num2str(i));
% %     end
%     for i = 1:10
%         p.files{i+60} = strcat('iss4-', num2str(i));
%     end
%     p.files{71} = 'ph013-3';
%     p.files{72} = 'ph013-4';
%     p.files{73} = 'ph013-5';
%     p.files{74} = 'ph013-8';
%     p.files{75} = 'ph013-9';
%     p.files{76} = 'ph013-10';
% elseif calibration == 3
%     for i = 1:10
%         p.files{i} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+10} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+20} = strcat('cavs2m-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+30} = strcat('acrin1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+40} = strcat('acrin2-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+50} = strcat('ino1-', num2str(i));
%     end
% %     for i = 1:10
% %         p.files{i+60} = strcat('ino14-', num2str(i));
% %     end
%     for i = 1:10
%         p.files{i+60} = strcat('iss4-', num2str(i));
%     end
%     p.files{71} = 'ph013-3';
%     p.files{72} = 'ph013-4';
%     p.files{73} = 'ph013-5';
%     p.files{74} = 'ph013-8';
%     p.files{75} = 'ph013-9';
%     p.files{76} = 'ph013-10';
% elseif calibration == 4
%     for i = 1:10
%         p.files{i} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+10} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+20} = strcat('cavs1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+30} = strcat('acrin1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+40} = strcat('acrin2-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+50} = strcat('ino1-', num2str(i));
%     end
% %     for i = 1:10
% %         p.files{i+60} = strcat('ino14-', num2str(i));
% %     end
%     for i = 1:10
%         p.files{i+60} = strcat('iss4-', num2str(i));
%     end
%     p.files{71} = 'ph013-3';
%     p.files{72} = 'ph013-4';
%     p.files{73} = 'ph013-5';
%     p.files{74} = 'ph013-8';
%     p.files{75} = 'ph013-9';
%     p.files{76} = 'ph013-10';
% elseif calibration == 5
%     for i = 1:10
%         p.files{i} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+10} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+20} = strcat('cavs1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+30} = strcat('cavs2m-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+40} = strcat('acrin2-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+50} = strcat('ino1-', num2str(i));
%     end
% %     for i = 1:10
% %         p.files{i+60} = strcat('ino14-', num2str(i));
% %     end
%     for i = 1:10
%         p.files{i+60} = strcat('iss4-', num2str(i));
%     end
%     p.files{71} = 'ph013-3';
%     p.files{72} = 'ph013-4';
%     p.files{73} = 'ph013-5';
%     p.files{74} = 'ph013-8';
%     p.files{75} = 'ph013-9';
%     p.files{76} = 'ph013-10';
% elseif calibration == 6
%     for i = 1:10
%         p.files{i} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+10} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+20} = strcat('cavs1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+30} = strcat('cavs2m-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+40} = strcat('acrin1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+50} = strcat('ino1-', num2str(i));
%     end
% %     for i = 1:10
% %         p.files{i+60} = strcat('ino14-', num2str(i));
% %     end
%     for i = 1:10
%         p.files{i+60} = strcat('iss4-', num2str(i));
%     end
%     p.files{71} = 'ph013-3';
%     p.files{72} = 'ph013-4';
%     p.files{73} = 'ph013-5';
%     p.files{74} = 'ph013-8';
%     p.files{75} = 'ph013-9';
%     p.files{76} = 'ph013-10';
% elseif calibration == 7
%     for i = 1:10
%         p.files{i} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+10} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+20} = strcat('cavs1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+30} = strcat('cavs2m-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+40} = strcat('acrin1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+50} = strcat('acrin2-', num2str(i));
%     end
% %     for i = 1:10
% %         p.files{i+60} = strcat('ino14-', num2str(i));
% %     end
%     for i = 1:10
%         p.files{i+60} = strcat('iss4-', num2str(i));
%     end
%     p.files{71} = 'ph013-3';
%     p.files{72} = 'ph013-4';
%     p.files{73} = 'ph013-5';
%     p.files{74} = 'ph013-8';
%     p.files{75} = 'ph013-9';
%     p.files{76} = 'ph013-10';
% elseif calibration == 8
%     for i = 1:10
%         p.files{i} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+10} = strcat('ph010-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+20} = strcat('cavs1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+30} = strcat('cavs2m-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+40} = strcat('acrin1-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+50} = strcat('acrin2-', num2str(i));
%     end
%     for i = 1:10
%         p.files{i+60} = strcat('ino1-', num2str(i));
%     end
% %     for i = 1:10
% %         p.files{i+70} = strcat('ino14-', num2str(i));
% %     end
%     p.files{71} = 'ph013-3';
%     p.files{72} = 'ph013-4';
%     p.files{73} = 'ph013-5';
%     p.files{74} = 'ph013-8';
%     p.files{75} = 'ph013-9';
%     p.files{76} = 'ph013-10';
% end





p.repnum = 0;
% p.rootdir='C:\fdpm.data\data.breast';
% p.patientID='563-291';
% p.date='071005';
% p.outLabel = 'bwtest';
% if system == 1
%     p.rootdir='C:\Users\Rob Warren\Desktop\data\Devices and Phantoms\jDOSI Testing\lbs5-jdosi'; %root directory
%     p.patientID='lbs5-jdosi'; %subfolder1
%     p.date='120315'; %subfolder2
%     p.outLabel = strcat(num2str(system), num2str(calibration)); %notes for tagging results from processing
% elseif system == 2
    p.rootdir='C:\Users\Rob Warren\Desktop\data'; %root directory
    p.patientID='Truman'; %subfolder1
    p.date='translucent'; %subfolder2
    p.outLabel = strcat('alox-', 'ph010cal'); %notes for tagging results from processing
% end

p.verbose = 1;
p.graphing = 1;
p.fileWrite=0;

%%Run Processing

error = ssfdpmPRO(fdpm,spec,physio,bw,p);
save(p.outLabel,'fdpm','spec','physio','bw','p');
% end
% end