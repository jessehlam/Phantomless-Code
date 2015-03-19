function dat=averageSpecData(specfile)
% need to code still need error!
% Output:
% dat.darkCorrected
% dat.dist
% dat.intTime
% dat.wv
% dat.amp



fid=fopen(specfile);
if fid == -1
   display(['File could not be opened:  ' specfile]);
   dat.error=-1;
   return;
end

fw='';
while ~strcmp(fw,'wv')
    l=fgetl(fid);
    fw=strtok(l);
    
    if findstr(l,'Dark Corrected:')
        dat.darkCorrected = str2double(strtok(l(16:length(l))));
    elseif findstr(l,'Source-Detector (mm):')
        dat.dist = str2double(strtok(l(22:length(l))));
    elseif findstr(l,'True Integration time (ms):')
        dat.intTime = str2double(strtok(l(28:length(l))));
    elseif findstr(l,'Integration time (ms):')
        dat.intTimeProgram = str2double(strtok(l(24:length(l))));
    end
end

A = fscanf(fid, '%f %f',[2,Inf]); 

fclose(fid);

dat.wv=A(1,:)';
dat.amp=A(2,:)';
dat.error=0;