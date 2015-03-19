function final = initFDPM(fdpm, cal, files)
%%%byh This function mainly opens the measurement files and removes the
%%%instrument response

%   Output:
%   final.AC
%   final.phase
%   final.damp
%   final.dphi
%   final.freq
%   final.dist




% Open FDPM Data Files
raw = averageFDPMDataAtDiodes(files, fdpm.diodes, fdpm.stderr);
if raw.error~=0, return; end

% Calibrate Raw Data
%%%byh Calibration factors are used by subtracting from measured phase, and
%%%dividing into measured amplitude
calibrated = calibrateFDPM(cal, raw, fdpm.freqrange);
% Window data to give freq range and filter phase jumps out if needed and set distance!
%%%byh A subset of frequencies can be used in the processing, here we
%%%reduce the measurement data to frequencies in the subset range.  We also
%%%have a check and fix for possible phase jumps.  
final = setFreqRangeJumpsDistance(calibrated, fdpm.freqrange, fdpm.opt.jumps, fdpm.ndiodes, fdpm.opt.rfixed);
final.phantom_used=fdpm.cal.phantoms_short(cal.phantom_used);
final.timestamp = raw.timestamp;
