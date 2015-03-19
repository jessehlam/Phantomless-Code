
function avedat = averageData(fdpm, spec,bw, dat, pro, physioset)
%averages final processed data

nFiles=length(pro.files)*pro.repnum;


AvailableForMatch = (1:nFiles);

avedat.averaged=1;

avedat.fitbase = [pro.fitbase 'AVE'];
avedat.nMatches = length(pro.files); %num of matches will be the number of unique aveprefixes


for i=1:avedat.nMatches,
	matches = pro.repnum;
	avedat  = averagethisdata(i, fdpm,spec,bw,  avedat, dat, 1:matches, physioset,pro.repnum);
	AvailableForMatch = setxor(AvailableForMatch,matches); %remove matched indexes out of list
end



%----------------
function avedat  = averagethisdata(i, fdpm, spec,bw, avedat, dat, matches, physioset,repnum)	
nMatches = length(matches);
if physioset.fdpm.fit,
	clear physio;
    if i==1, avedat.fd.physio(1,:) = dat.fd.physio(1,:); end; 
    nChrom = size(dat.fd.physio,2)/2;
	datidx = 1:nChrom;
	erridx = nChrom+1:nChrom*2;

	physio = reshape([dat.fd.physio{nMatches*(i-1)+matches+1,:}], nMatches, nChrom*2); 
	avedat.fd.physio(i+1,datidx) = num2cell(mean(physio(:,datidx),1))';
	avedat.fd.physio(i+1,erridx) = num2cell(std(physio(:,datidx),0,1))';
	avedat.fd.ss(i) = max(dat.fd.ss(matches));  
end
if spec.on && physioset.spec.fit
    nChromSS = size(dat.ss.physio,2)/2;
    if i ==1
        avedat.ss.physio(1,:) = dat.ss.physio(1,:);
        avedat.ss.diodphysio(1,:) = dat.ss.diodphysio(1,:);
    end
    physio = reshape([dat.ss.physio{nMatches*(i-1)+matches+1,:}], nMatches, nChromSS*2);
    avedat.ss.physio(i+1,1:nChromSS)  = num2cell(mean(physio(:,1:nChromSS),1))';
    avedat.ss.physio(i+1,nChromSS+1:nChromSS*2)  = num2cell(std(physio(:,1:nChromSS),0,1))';

    % 		physio = reshape([dat.ss.diodphysio{nMatches*(i-1)+matches+1,:}], nMatches, nChrom*2);
    % 		avedat.ss.diodphysio(i+1,datidx)  = num2cell(mean(physio(:,datidx),1))';
    % 		avedat.ss.diodphysio(i+1,erridx)  = num2cell(std(physio(:,datidx),0,1))';
    avedat.ss.ss(i) = mean(dat.ss.ss(matches));

    avedat.ss.mua(:,2*i-1) =mean(dat.ss.mua(:,(2.*matches-1+nMatches*2*(i-1))),2);
    avedat.ss.mua(:,(2*i))  =mean(dat.ss.mua(:,(2.*matches+nMatches*2*(i-1))),2);
else
    if spec.on
        avedat.ss.mua(:,i) = mean(dat.ss.mua(:,(i-1)*repnum+matches,:),2);
    end
end
if spec.on && bw.fit
    avedat.bw.bwi(i)=mean(dat.bw.bwi(matches));
end
avedat.fd.mua(i,:) = mean(dat.fd.mua((i-1)*repnum+matches,:),1);
avedat.fd.mus(i,:) = mean(dat.fd.mus((i-1)*repnum+matches,:),1);
avedat.fd.mua_err(i,:) = std(dat.fd.mua((i-1)*repnum+matches,:),0,1);
avedat.fd.mus_err(i,:) = std(dat.fd.mus((i-1)*repnum+matches,:),0,1);

avedat.fd.guessnum(i,:) = max(dat.fd.guessnum((i-1)*repnum+matches,:),[],1);
avedat.fd.preft(i) = mean(dat.fd.preft((i-1)*repnum+matches));
avedat.fd.dpreft(i)= std(dat.fd.preft((i-1)*repnum+matches));
avedat.fd.slope(i) = mean(dat.fd.slope((i-1)*repnum+matches));
avedat.fd.dslope(i)= std(dat.fd.slope((i-1)*repnum+matches));
if physioset.fdpm.fit
    avedat.fd.ss(i) = mean(dat.fd.ss((i-1)*repnum+matches));
    avedat.fd.dss(i)= std(dat.fd.ss((i-1)*repnum+matches));
end
avedat.fd.conv(i,:) = min(dat.fd.conv((i-1)*repnum+matches,:),[], 1);
avedat.fd.minfreq = dat.fd.minfreq; avedat.fd.maxfreq = dat.fd.maxfreq;
avedat.fd.r1 = dat.fd.r1; avedat.fd.r2=dat.fd.r2;
if length(avedat.fd.minfreq) >1 || length(avedat.fd.maxfreq)>1
	warning([sprintf('Min or Max frequency changed between measurements:\n') sprintf('%d %d', avedat.fd.minfreq, avedat.fd.maxfreq)]);
end;	
if length(avedat.fd.r1) >1 || length(avedat.fd.r2)>1
	warning([sprintf('r1 or r2 changed between measurements:\n') sprintf('%d %d', avedat.fd.r1, avedat.fd.r2)]);
end;	

if spec.on
    avedat.ss.R(:,i) = mean(dat.ss.R(:,(i-1)*repnum+matches),2);
    avedat.ss.diodR(:,i) = mean(dat.ss.diodR(:,(i-1)*repnum+matches),2);
    avedat.ss.mus(:,i) = mean(dat.ss.mus(:,(i-1)*repnum+matches),2);
    avedat.ss.diodMus(:,i) = mean(dat.ss.diodMus(:,(i-1)*repnum+matches),2);
    avedat.ss.preft(i) = mean(dat.ss.preft((i-1)*repnum+matches));
    avedat.ss.dpreft(i)= std(dat.ss.preft((i-1)*repnum+matches));
    avedat.ss.slope(i) = mean(dat.ss.slope((i-1)*repnum+matches));
    avedat.ss.dslope(i)= std(dat.ss.slope((i-1)*repnum+matches));
    avedat.ss.ss(i)= mean(dat.ss.ss((i-1)*repnum+matches));
    avedat.ss.dss(i)= std(dat.ss.ss((i-1)*repnum+matches));
end
