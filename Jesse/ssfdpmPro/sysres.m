function sysres(fdpmfit,fdpm,final,guiVal,fdpmcal)
% Defining variables
freq=final.freq; %Frequency range (truncated already)
nFreq = length(freq); %Getting the length of data
noWt = ones(nFreq*2,1); %No weighting
nDiodes = length(guiVal.list_of_diodes); %Getting number of diodes

%Preallocating empty matrices to be filled
offset = zeros(nFreq,nDiodes);
amps1 = zeros(nFreq,nDiodes);
phis1 = zeros(nFreq,nDiodes);
amps2 = zeros(nFreq,nDiodes);
phis2 = zeros(nFreq,nDiodes);
guessamp = zeros(nFreq,nDiodes);
guessphi = zeros(nFreq,nDiodes);
AC_phan = zeros(nFreq,nDiodes);
PHI_phan = zeros(nFreq,nDiodes);

%% Importing calibrator data
dir=strcat(guiVal.dataDir,guiVal.patientID,'\',guiVal.date,'\'); %Directory of the data
match1=importdata(strcat(dir,guiVal.phantomList{1},'-',guiVal.source,'.asc')); %Importing
match1=match1.data; %Pulling data
match2=importdata(strcat(dir,guiVal.phantomList{1},'2','-',guiVal.source,'.asc')); %Importing
match2=match2.data; %Pulling data
tissue=importdata(strcat(dir,guiVal.prefixList{1},'-',guiVal.source,'.asc')); %Importing
tissue=tissue.data;

%% Getting data from imported files and recovering the flat line system response
for i=1:nDiodes %Loop through number of diodes
    titles{i}=num2str(guiVal.list_of_diodes(i)); %Labeling diodes
    
    rawAC(:,i)=tissue(eval('final.ind'),2*i+1); %Raw tissue amplitude
    rawPHI(:,i)=tissue(eval('final.ind'),2*i); %Raw tissue phase
    
    amps1(:,i)=match1(eval('final.ind'),2*i+1); %Pulling amplitude
    phis1(:,i)=match1(eval('final.ind'),2*i); %Pulling phase (already in degrees)
    
    amps2(:,i)=match2(eval('final.ind'),2*i+1); %Pulling amplitude
    phis2(:,i)=match2(eval('final.ind'),2*i); %Pulling phase (already in degrees)
    
    %Creating our flat line "standard" from the system responses
    flatamp=amps1./amps2; %If they are the *exact* same system response, they will be flat lines.
    flatphi=phis1-phis2; %If they are the *exact* same system response, we expect this to be all zeros.
    
    %Getting the offset due to the photon path through the calibrator
    offset(:,i)=ones(nFreq,1).*fdpmcal.phase_offset(final.ind);
end

%% Getting the recovered system response

% fdpmfit.mua=[0.00719955800000000;0.00673395200000000;0.00588275500000000;0.0133511560000000];
% fdpmfit.mus=[0.888075728000000;0.860057492000000;0.824719084000000;0.815834258000000];

for p=1:nDiodes %Loop through number of diodes
    theory=feval('p1seminf',[fdpmfit.mua(p),fdpmfit.mus(p)], freq, 0, fdpm.n, final.dist, 0, noWt, 0, fdpm.boundary_option);
    %'theory' returns the amplitude and phase as one vector
    
    AC_phan(:,p) = theory(1:nFreq); %Sectioning out the output of 'theory' that is the amplitude (a.u.)
    PHI_phan(:,p) = rad2deg(unwrap(theory(1+nFreq:2*nFreq)));  %Sectioning out the phase (radians)
end
%     AC_phan=fdpmfit.amp;
%     PHI_phan=rad2deg(fdpmfit.phi);
%Obtaining the recovered system response based on the minimization (i.e. guessing) of the phantom OP
sysamp=rawAC./AC_phan; %Removing phantom amplitude contribution from the raw amplitude
sysphi=rawPHI-PHI_phan; %Removing phantom phase contribution from the raw phase

%% Comparing how well the system response was recovered
guessamp=amps1./sysamp; %Dividing pure system response by the recovered system response
guessphi=phis1-offset-sysphi;

figure(5); %New figure
% cmap=distinguishable_colors(nDiodes*2); %Different colors per plot

for h=1:nDiodes
    %Finding the slope
    flatpoly=polyfit(freq,flatamp(:,h)./flatamp(1,h),1); %Fitting line to obtain slope
    guesspoly=polyfit(freq,guessamp(:,h)./guessamp(1,h),1); %Fitting line to obtain slope
    slopeval=polyval(guesspoly,freq); %Fitting line to recovered system response
    flatval=polyval(flatpoly,freq); %Fitting line to standard
    slope=guesspoly(1)/flatpoly(1); %Recording recovered to standard slope ratio
    
    %Plotting
    subplot(2,ceil(nDiodes/2),h,'align');
    plot(freq,flatamp(:,h)./flatamp(1,h),'k*','linewidth',2) %Plotting standard
    hold on
    plot(freq,guessamp(:,h)./guessamp(1,h),'r*','markersize',2) %Plotting recovered
    plot(freq,slopeval,'r','linewidth',2); %Plotting recovered slope
    plot(freq,flatval,'k','linewidth',2); %Plot standard's slope
    xlabel('Frequency (MHz)');
    ylabel('Amplitude (a.u.)');
    title(strcat(titles{h},'Slope Ratio:',num2str(slope))); %Eventually change title to slope of amps
    xlim([min(freq) max(freq)]);
%     ylim([.95 1.05]);
end

figure(6);

for k=1:nDiodes
    %Finding the average
    flatavg=mean(flatphi(:,k)); %Finding the average phase
      
    guessavg=mean(guessphi(:,k)); %Finding the average phase
    avgval=polyval(guessavg,freq); %Horizontal line of the recovered phase
    stanavg=polyval(flatavg,freq); %Horizontal line of the standard's phase
    phiavg=flatavg-guessavg; %Recording the phase
    
    subplot(2,ceil(nDiodes/2),k,'align');
    plot(freq,flatphi(:,k),'k*','linewidth',2) %Plotting standard
    hold on
    plot(freq,guessphi(:,k),'b*','markersize',2) %Plotting recovered
    plot(freq,avgval,'b','linewidth',2) %Plotting recovered phase avg
    plot(freq,stanavg,'k','linewidth',2) %Plotting standard's phase avg
    xlabel('Frequency (MHz)');
    ylabel('Phase (Degrees)');
    title(strcat(titles{k},'Degree Difference:',num2str(phiavg))); %Eventually change title to average degrees
    xlim([min(freq) max(freq)]);
end

%%
% legend('Standard','Recovered','location','eastoutside');


