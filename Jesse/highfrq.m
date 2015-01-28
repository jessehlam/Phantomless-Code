%% Calibrate and average high frequency data
modf.amp=highf.amp./calf.amp;
modfavg.amp=mean(modf.amp); %Average "tissue" high freq amp
modfavg.amp=modfavg.amp/amppoly(1); %Normalizing to the same polynomial