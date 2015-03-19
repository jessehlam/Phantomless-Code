function cal = getSpecCal(calfile, caldark, opt)
%%%byh This file mainly just opens the reflectance calibration files.  

cal = averageSpecData(calfile);
if cal.error==-1
    return
end

%%%byh Files are always saved now with the dark already subtracted so this
%%%bit of code is not necessary
if cal.darkCorrected~=1
    darkcal = averageSpecData(caldark);
    if opt.spike
        darkcal.amp = spectrumSmoother(darkcal.amp,2,opt.spikewindow,opt.spike); %remove spikes
        darkcal.amp = spectrumSmoother(darkcal.amp,1,opt.boxcar);   %filer
    end
    cal.amp = cal.amp - darkcal.amp;
end

%%%byh We've always done some smoothing to the reflectance curves but its
%%%likely unnecessary.  If I can verify that, then this would not be ported. 
cal.amp = spectrumSmoother(cal.amp,1,opt.boxcar);
cal.amp = spectrumSmoother(cal.amp,3); %no negs
cal.file=calfile;
cal.error=0;