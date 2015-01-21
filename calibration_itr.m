%% Calibrate amplitude
FDPM.AMP_sample = FDPM.AMP./CAL.AMP; %Calibrating out system response
rawamp=FDPM.AMP_sample;
ampfit=polyfit(FDPM.F(frqnum2:polyfrq),FDPM.AMP_sample(frqnum2:polyfrq),polyN);
amppoly=polyval(ampfit,FDPM.F(frqnum2:polyfrq)); %Fitting a polynomial to the calibrated amp data
FDPM.MOD_sample = FDPM.AMP_sample/amppoly(1); %Normalizing to the first point of the polynomial
amppolyN=amppoly/amppoly(1); %Normalizing poly fit

%% Calibrate phase
CAL.phase_offset = 360*FDPM.F*10^6*((L_cal-L_filter)/c/n_air+L_filter/c/n_filter); %get filter correction for phase. Pham et al., Review of Scientific Instruments, eq. 14
CAL.phase_corrected = CAL.PHI - CAL.phase_offset;
FDPM.PHI_sample = FDPM.PHI - CAL.phase_corrected; %Calibrating phase
rawphi=FDPM.PHI_sample;
phifit=polyfit(FDPM.F(frqnum2:polyfrq),FDPM.PHI_sample(frqnum2:polyfrq), polyN);
phipoly=polyval(phifit,FDPM.F(frqnum2:polyfrq)); %Fitting a polynomial to the calibrated phi data
%FDPM.PHI_sample = FDPM.PHI_sample-FDPM.PHI_sample(1); %Normalizing phase
FDPM.PHI_sample = FDPM.PHI_sample-phipoly(1); %Normalizing to the poly fit
phipolyN = phipoly-phipoly(1); %Normalizing poly fit

%% Saving calibrated amplitude and phase
curramp=FDPM.MOD_sample; %Calibrated amplitude
currphi=FDPM.PHI_sample; %Calibrated phase