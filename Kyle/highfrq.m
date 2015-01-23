%% Average high frequency data and adding it to the amplitude and phase
highfavg.amp=mean(highf.amp); %Average "tissue" high freq amp
calfavg.amp=mean(calf.amp); %Average calibrator high freq amp
highfavg.amp=highfavg.amp/calfavg.amp; %Calibrating out system response
highfavg.amp=highfavg.amp/amppoly(1); %Normalizing to the same polynomial

highfavg.phi=mean(highf.phi); %Average "tissue" high freq phi
calfavg.phi=mean(calf.phi); %Average calibrator high freq phi
highf_phase_offset = 360*highffile.data(1,1)/1000*10^7*((L_cal-L_filter)/c/n_air+L_filter/c/n_filter); %get filter correction for phase. Pham et al., Review of Scientific Instruments, eq. 14
calfavg.phi=calfavg.phi-highf_phase_offset;
calfavg.phi=highfavg.phi-calfavg.phi; %Calibrating out system response
calfavg.phi=calfavg.phi-phipoly(1); %Normalizing to the same polynomial

%% Calibrating out the system response
