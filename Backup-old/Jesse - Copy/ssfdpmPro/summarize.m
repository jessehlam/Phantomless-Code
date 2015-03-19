function o = summarize(spec,final, nFiles, fdpmfit, specfit,fdpmchrom,ssfdpmchrom,physio,bw,bwfit)
o.averaged=0;
if physio.fdpm.fit
    %o initializations
    o.fd.physio = cell(nFiles+1, 2*size(fdpmfit(1).phy,2));
    o.fd.physio(1,:) = [fdpmchrom.names strcat(fdpmchrom.names,'_err')];
end

if physio.spec.fit && spec.on
    o.ss.physio =cell(nFiles+1, 2*size(specfit(1).phy,2));
    o.ss.physio(1,:) = [ssfdpmchrom.names strcat(ssfdpmchrom.names,'_err')] ;
    o.ss.diodphysio = cell(nFiles+1, 2*size(specfit(1).phy,2));
    o.ss.diodphysio(1,:) = [ssfdpmchrom.names strcat(ssfdpmchrom.names,'_err')];
end


o.ss.mua= [];
o.ss.muaonly=[];
o.ss.slope=[];o.ss.preft=[];o.ss.dslope=[];o.ss.dpreft=[];
minfreq=zeros(size(nFiles));maxfreq=zeros(size(nFiles));r1=zeros(size(nFiles));r2=zeros(size(nFiles));

for i=1:nFiles,
    if physio.fdpm.fit
%        o.fd.physio{i+1,:} = [fdpmfit(1).phy(1,:) fdpmfit(1).phy(2,:)];
        o.fd.physio(i+1,:)=num2cell([fdpmfit(i).phy(1,:) fdpmfit(i).phy(2,:)]);
        o.fd.ss(i,:) = fdpmfit(i).ss;
    end;
%     [o.fd.mua(i,:), o.fd.mus(i,:), o.fd.mua_err(i,:), o.fd.mus_err(i,:), o.fd.preft(i), o.fd.ss(i)]  =  ...
%         deal(fdpmfit(i).mua, fdpmfit(i).mus, fdpmfit(i).dmua, fdpmfit(i).dmus, fdpmfit(i).preft,fdpmfit(i).ss);
       [o.fd.mua(i,:), o.fd.mus(i,:)]  =  ...
        deal(fdpmfit(i).mua, fdpmfit(i).mus);
%     [o.fd.slope(i), o.fd.dslope(i), o.fd.conv(i,:), o.fd.guessnum(i,:), o.fd.guesses(i,:)] = deal(fdpmfit(i).slope, fdpmfit(i).dslope,fdpmfit(i).converged, fdpmfit(i).guessnum, fdpmfit(i).guesses);
    [minfreq(i) maxfreq(i) r1(i) r2(i)] = deal(min(final(i).freq), max(final(i).freq), final(i).dist, 0);

    [o.fd.gbfi_amp(i,:),o.fd.gbfi_phi(i,:)] = deal(fdpmfit(i).gbfi(:,1),fdpmfit(i).gbfi(:,2));
    
    if spec.on       
        if ~physio.spec.fit
            mua=[specfit(i).muaSPEC'];
        else
            mua=[specfit(i).muaSPEC' specfit(i).fitmua];
            o.ss.ss(i,:) = specfit(i).ss;
            o.ss.physio(i+1,:)=num2cell([specfit(i).phy(1,:) specfit(i).phy(2,:)]);
        end
        o.ss.mua = [o.ss.mua mua];
        o.ss.muaonly=[o.ss.muaonly specfit(i).muaSPEC'];
    
        [o.ss.R(:,i), o.ss.diodR(:,i)] = deal(specfit(i).R, specfit(i).diodR);
        
        [o.ss.mus(:,i), o.ss.diodMus(:,i)] = deal(specfit(i).mus, specfit(i).diodMus);
%          if fdpm.opt.physioon,
%              [o.ss.physio(i+1,:), o.ss.diodphysio(i+1,:), o.ss.ss(i)] = deal(specfit(i).phy, specfit(i).diodPhy, specfit(i).ss);
%          end;

        [o.ss.slope(:,i), o.ss.preft(:,i),o.ss.dslope(:,i),o.ss.dpreft(:,i)] =  ...
            deal(specfit(i).slope, specfit(i).preft, specfit(i).dslope,specfit(i).dpreft);

    end
    
    if bw.fit && spec.on
        o.bw.bwi(i)=bwfit(i).BWI;
    end
    o.fd.phantom_used(i,:)=final(i).phantom_used;
end

o.fd.minfreq = unique(minfreq); o.fd.maxfreq = unique(maxfreq);
o.fd.r1 = unique(r1); o.fd.r2=unique(r2);

if length(o.fd.minfreq) >1 || length(o.fd.maxfreq)>1
    warning([sprintf('Min or Max frequency changed between measurements:\n') sprintf('%d %d', [o.fd.minfreq o.fd.maxfreq])]);
end;
if length(o.fd.r1) >1 || length(o.fd.r2)>1
    warning([sprintf('r1 or r2 changed between measurements:\n') sprintf('%d %d', [o.fd.r1 o.fd.r2])]);
end;
