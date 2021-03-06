function calibrated=calibrateFDPM(cal,raw,freqrange,j)
% send in calibration factors and raw data and return calibrated data
% Output:
% calibrated.AC
% calibrated.phase
% calibrated.damp
% calibrated.dphi
% calibrated.freq
% calibrated.dist
% freqrange=[freqrange(1) freqrange(j+1)];
ind = find(raw.freq>=freqrange(1) & raw.freq<=freqrange(2));
calibrated.AC=raw.AC./cal.AC;
calibrated.phase=raw.phase-cal.phase;

for i=1:length(calibrated.phase(1,:))
    calibrated.phase(:,i) = calibrated.phase(:,i)-calibrated.phase(ind(1),i); %Normalizing to
end

calibrated.damp = calibrated.AC.*sqrt((raw.ACsd./raw.AC).^2 + cal.ACsd_AC_sqd);
calibrated.dphi = sqrt(cal.phsd_sqd + raw.phsd.^2);

calibrated.freq = raw.freq;

calibrated.dist = raw.dist;


