function calibrated=calibrateFDPM(cal,raw,freqrange)
% send in calibration factors and raw data and return calibrated data
% Output:
% calibrated.AC
% calibrated.phase
% calibrated.damp
% calibrated.dphi
% calibrated.freq
% calibrated.dist

ind = find(raw.freq>=freqrange(1) & raw.freq<=freqrange(2));
calibrated.AC=raw.AC./cal.AC;
calibrated.phase=raw.phase-cal.phase;
calibrated.phase = calibrated.phase-calibrated.phase(ind(1))+1;
calibrated.damp = calibrated.AC.*sqrt((raw.ACsd./raw.AC).^2 + cal.ACsd_AC_sqd);
calibrated.dphi = sqrt(cal.phsd_sqd + raw.phsd.^2);

calibrated.freq = raw.freq;

calibrated.dist = raw.dist;


