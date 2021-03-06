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
    
    %Creating our flat line "benchmark" from the system responses
    flatamp=amps1./amps2; %If they are the *exact* same system response, they will be flat lines.
    flatphi=phis1-phis2; %If they are the *exact* same system response, we expect this to be all zeros.
    
    %Getting the offset due to the photon path through the calibrator
    offset(:,i)=ones(nFreq,1).*fdpmcal.phase_offset(final.ind);
end

%% Getting the recovered system response

%Forcing OP (used comparing phantom with phantomless calibrator values)
% fdpmfit.mua=[0.00377376600000000;0.00342215700000000;0.00275231600000000;0.00275796000000000];
% fdpmfit.mus=[0.756820609000000;0.738469518000000;0.714923202000000;0.696490992000000];

for p=1:nDiodes %Loop through number of diodes
    theory=feval('p1seminf',[fdpmfit.mua(p),fdpmfit.mus(p)], freq, 0, fdpm.n, final.dist, 0, noWt, 0, fdpm.boundary_option);
    %'theory' returns the amplitude and phase as one vector
    
    AC_phan(:,p) = theory(1:nFreq); %Sectioning out the output of 'theory' that is the amplitude (a.u.)
    PHI_phan(:,p) = rad2deg(unwrap(theory(1+nFreq:2*nFreq)));  %Sectioning out the phase (radians)
end

%Obtaining the recovered system response based on the minimization (i.e. guessing) of the phantom OP
sysamp=rawAC./AC_phan; %Removing phantom amplitude contribution from the raw amplitude
sysphi=rawPHI-PHI_phan; %Removing phantom phase contribution from the raw phase

%% Comparing how well the system response was recovered
guessamp=amps1./sysamp; %Dividing pure system response by the recovered system response
guessphi=phis1-offset-sysphi;

f5=figure(5); %New figure
clf(f5); %Clears figure contents so it doesn't overlap with any previous plots

for h=1:nDiodes
    %Fitting polynomials
    flatpoly=polyfit(freq,flatamp(:,h)./flatamp(1,h),1); %Fitting line to obtain slope
    guesspoly=polyfit(freq,guessamp(:,h)./guessamp(1,h),1); %Fitting line to obtain slope
    slopeval=polyval(guesspoly,freq); %Fitting line to recovered system response
    flatval=polyval(flatpoly,freq); %Fitting line to benchmark
%     slope=guesspoly(1)/flatpoly(1); %Recording recovered to benchmark slope ratio

    %Calculating the slopes
    slopeflat=(flatval(end)-flatval(1))/(freq(end)-freq(1));
    slopeguess=(slopeval(end)-slopeval(1))/(freq(end)-freq(1));
%     slope=slopeguess/slopeflat; %Recording recovered to benchmark slope ratio
    slopes=[slopeflat slopeguess].*10^6; %Recording raw slope, scaled
    
    %Plotting
    subplot(2,ceil(nDiodes/2),h,'align');
    plot(freq,flatamp(:,h)./flatamp(1,h),'k*','linewidth',2) %Plotting benchmark
    hold on
    plot(freq,guessamp(:,h)./guessamp(1,h),'r*','markersize',2) %Plotting recovered
    s1=plot(freq,slopeval,'r','linewidth',2); %Plotting recovered slope
    s2=plot(freq,flatval,'k','linewidth',2); %Plot benchmark's slope
    xlabel('Frequency (MHz)');
    ylabel('Amplitude (a.u.)');
    title(strcat(titles{h},'Slopes:',num2str(slopes))); %Eventually change title to slope of amps
    xlim([min(freq) max(freq)]);
    ylim([.95 1.05]);
end

legend([s1 s2],{'Recovered','Benchmark'},'location','best')
f6=figure(6);
clf(f6); %Clears figure contents so it doesn't overlap with any previous plots

for k=1:nDiodes
    %Finding the average
    flatavg=mean(flatphi(:,k)); %Finding the average phase
      
    guessavg=mean(guessphi(:,k)); %Finding the average phase
    avgval=polyval(guessavg,freq); %Horizontal line of the recovered phase
    stanavg=polyval(flatavg,freq); %Horizontal line of the benchmark's phase
    phiavg=guessavg-flatavg; %Recording the phase
    
    subplot(2,ceil(nDiodes/2),k,'align');
    plot(freq,flatphi(:,k),'k*','linewidth',2) %Plotting benchmark
    hold on
    plot(freq,guessphi(:,k),'b*','markersize',2) %Plotting recovered
    d1=plot(freq,avgval,'b','linewidth',2); %Plotting recovered phase avg
    d2=plot(freq,stanavg,'k','linewidth',2); %Plotting benchmark's phase avg
    xlabel('Frequency (MHz)');
    ylabel('Phase (Degrees)');
    title(strcat(titles{k},'Degree Difference:',num2str(phiavg))); %Eventually change title to average degrees
    xlim([min(freq) max(freq)]);
end

legend([d1 d2],{'Recovered','Benchmark'},'location','best')

end