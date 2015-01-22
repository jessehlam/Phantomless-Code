%% Average high frequency data and adding it to the amplitude and phase
highfavg.amp=mean(highf.amp); %Average "tissue" high freq amp
calfavg.amp=mean(calf.amp); %Average calibrator high freq amp
highfavg.amp=highfavg.amp/calfavg.amp; %Calibrating out system response
highfavg.amp=highfavg.amp/amppoly(1); %Normalizing to the same polynomial

highfavg.phi=mean(highf.phi); %Average "tissue" high freq phi
calfavg.phi=mean(calf.phi); %Average calibrator high freq phi
calfavg.phi=calfavg.phi-CAL.phase_corrected;
calfavg.phi=highfavg.phi-calfavg.phi; %Calibrating out system response
calfavg.phi=calfavg.phi-phipoly(1); %Normalizing to the same polynomial

%% Calibrating out the system response
