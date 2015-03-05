%function writeFitReport dumps data into a file with the extension '.gbfi'
%to alert user about fit quality.  For each laser diode, a score is
%assigned compared to the average for the amplitude, phase, and SS value
%(relative to the FD value).
%
%
%   5/07    AEC 


function writeFitReport(fdpm,o,nFiles,specfit, pro)

%error warning level
lim_err = 0.25;

fid = fopen(strcat(pro.fitbase, '_gbfi.asc'), 'w');
fprintf(fid,'%% ANAYLSIS DATE   :\t%s\n',datestr(now));
fprintf(fid,'%% PATIENT ID #    :\t%s\n', pro.patientID);
fprintf(fid,'%% MEASURE DATE #    :\t%s\n\n', pro.date);
fprintf(fid,'\tAMP\t\t\t\t\t\tPHI\t\t\t\t\t\tSS-FDx10^6\t\t\t\t\t\tAVGERAGES\t\t\t\tSTDEV\t\t\tWARNINGS\n');

%generate header for table
fprintf(fid,'FILE\t');
for g= 1:3
    for k=1:fdpm.ndiodes,
        fprintf(fid,'%i \t', fdpm.diodes(k));
    end;  
end
%fprintf(fid,'AVG(AMP)\tSTD(AMP)\tAVG(PHI)\tSTD(PHI)\tSS\tSS\n');
%fprintf(fid,'AMP\tPHI\tSS-FD\tSS\tAMP\tPHI\tSS-FD\t');
fprintf(fid,'AMP\tPHI\tSS-FD\tAMP\tPHI\tSS-FD\t');

%for warnings
 for k=1:fdpm.ndiodes,
     fprintf(fid,'%i \t', fdpm.diodes(k));
end;  
fprintf(fid,'SS\n');

%%%%run thru files

for a=1:nFiles
    ss_err = specfit(a).fdpmsserr;    %get ss-FD mismatches
    
    %overall score averages
    avg(1) = mean(o.fd.gbfi_amp(a,:),2); %calc average fit index for amp
    avg(2) = mean(o.fd.gbfi_phi(a,:),2); %calc average fit index for phi
    avg(3) = std(o.fd.gbfi_amp(a,:),0,2);
    avg(4) = std(o.fd.gbfi_phi(a,:),0,2);    
    avg(5) = mean(abs(ss_err)*1000000); %ss-fd mismatch averages
    avg(6) = std(ss_err*1000000,0);
       
    %now make titles
%     fprintf(fid,'%s\t',fdpm.prefixes{a);
    fprintf(fid,'%d\t',a);
    
    %do amps first
    for b=1:fdpm.ndiodes
        fprintf(fid,'%f\t',o.fd.gbfi_amp(a,b));
    end

    %now phases
    for b=1:fdpm.ndiodes
        fprintf(fid,'%f\t',o.fd.gbfi_phi(a,b));
    end

    %now ss-fd differential
    for c=1:fdpm.ndiodes
        fprintf(fid,'%f\t',ss_err(c)*1000000);
    end 
    
    %print averages
    fprintf(fid,'%f\t%f\t%f\t%f\t%f\t%f\t',avg(1),avg(2),avg (5),avg(3),avg(4),avg(6));

    %print Warning messages
    for d=1:fdpm.ndiodes
        mk= '   ';mkm=0;
        
        if o.fd.gbfi_amp(a,d)>=(1+lim_err).*avg(1);mk(1) = 'A';mkm=1;end;
        if o.fd.gbfi_phi(a,d)>=(1+lim_err).*avg(2);mk(2)='P';mkm=1;end;
        if abs(ss_err(d)) >= abs((1+lim_err).*avg(5)./1000000);mk(3)='S';mkm=1;end;
        
        if mkm==0
            mk_code = '   ';
        else
            mk_code = strcat(mk(1),strcat(mk(2),mk(3)));
        end
        fprintf(fid,'%s\t',mk_code);
    end %done with this one 
    
    fprintf(fid,'\n');%go to next position
    
end
   
fclose(fid);