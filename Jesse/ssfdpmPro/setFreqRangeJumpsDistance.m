function final = setFreqRangeJumpsDistance(calibrateddata, freqrange, jumps, nDiodes, rfixed)
%windows calibrated data to given frequency range
% also filters phase jumps out
%   Output:
%   final.AC
%   final.phase
%   final.damp
%   final.dphi
%   final.freq
%   final.dist

if rfixed==0
    final.dist=calibrateddata.dist;
else
    final.dist=rfixed;
end


ind = find(calibrateddata.freq>=freqrange(1) & calibrateddata.freq<=freqrange(2));

final.freq = calibrateddata.freq(ind);

final.AC = calibrateddata.AC(ind,:);

final.phase = calibrateddata.phase(ind,:);

final.dphi = calibrateddata.dphi(ind,:);

final.damp = calibrateddata.damp(ind,:);


flen = length(final.freq);

%filter phase jumps out
if jumps
    for x=1:nDiodes,
        for m=1:flen,
            if final.phase(m,x)<-4 %test if gets too negative
                final.phase(m:flen,x)=final.phase(m:flen,x)+2*pi;% add 2pi
            elseif final.phase(1,x)>4  %if too positive
                final.phase(:,x)=final.phase(:,x)-2*pi;% subtract 2pi
            end
        end   
    end
end


