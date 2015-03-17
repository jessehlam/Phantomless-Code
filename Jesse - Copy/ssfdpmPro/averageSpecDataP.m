function avedat=averageSpecDataP(specfiles)
% need to code still need error!
% Output:
% avedat.darkCorrected
% avedat.dist
% avedat.intTime
% avedat.wv
% avedat.amp
% avedat.ampsd
% avedat.wvsd
% modified for phantom study?
% need error checking


for i=1:size(specfiles,2)
    dat=getSpecData(specfiles{:,i});
    if dat.error~=0
        ave_dat.error=dat.error;
        return;
    end
    amp(:,i)=dat.amp;
end

avedat.amp=mean(amp,2);
avedat.ampsd=std(amp,0,2);
avedat.dist=dat.dist;
avedat.wv=dat.wv;
avedat.intTime=dat.intTime;
avedat.darkCorrected=dat.darkCorrected;
    
