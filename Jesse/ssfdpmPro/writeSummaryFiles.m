function writeSummaryFiles(fdpm, spec,bw,p ,physio, o, nFiles, final)

% if o.averaged==1
%     fitbase=o.fitbase;
% else
%     fitbase=p.fitbase;
% end

cd(strcat(p.rootdir,p.patientID));
mkdir('PROCESSED')
cd(strcat(p.rootdir,p.patientID,'\PROCESSED'))

a= sprintf('%% ANAYLSIS DATE   :\t%s\n',datestr(now));
d=sprintf('%% REFERENCE FILE  :\t%s\n\n',strcat(fdpm.cal.phantoms{:}));
e=sprintf('%% PATIENT ID #    :\t%s\n',p.patientID);
g=sprintf('%% FREQUENCY RANGE  :\t%4.1f to %4.1f MHz\n\n',o.fd.minfreq,o.fd.maxfreq);
h=sprintf('%% MODEL FILE       :\t%s\n',fdpm.model_to_fit);
i=sprintf('%% CHROMOPHORE FILE :\t%s\n',physio.chrom.file);   
j=sprintf('%% S-D FIT DISTANCE r1 & r2:\t%d\t%d\n\n',o.fd.r1, o.fd.r2);   
if(fdpm.cal.which==0),
	k=sprintf('%% CALIBRATION     :\tData was already calibrated.\n');
elseif (fdpm.cal.which==2),
	k=sprintf('%% CALIBRATION     :\tTwo-distance.\n');
else
	k=sprintf('%% CALIBRATION     :\tPerformed phantom calibration using %s as a model.\n%% PHANTOM FILE    :\t%s\n',...
		fdpm.cal.model_to_fit, fdpm.cal.model_to_fit);
end;   
fdpm.opt.feedback=0;
if(fdpm.opt.feedback==1),
	l=sprintf('%% SPECTRUM        :\tRe-fit mua using spectral fit of all mus values.\n');
elseif(fdpm.opt.feedback==2),
	l=sprintf('%% SPECTRUM        :\tRe-fit mua using spectral fit for mus values deviating by %2.1f%%.\n\n',fdpm.musper);
else
	l=sprintf('%% SPECTRUM        :\tFit normally.\n');	
end;
footer = [a d e g h i j k l];
header = sprintf('%% ID = %s\n%% date = %s\n%% spec.opt.baseline = %d\n', ...
	p.patientID, p.date, spec.opt.baseline);
filelist = 'wavelength(nm)\t'; conclist = 'chromophore\t';
wvfileformat='%f\t'; concformat='%s\t';

%AEC added for averaging
if nFiles>length(p.files)     %if no averaging then use whole list
    newfilelist=char(p.prefixes);
else
    newfilelist=char(p.files);           %converting from cell to strings
end

for i=1:nFiles    
    filelist = [filelist newfilelist(i,:) '\t'];  %AEC for average
    conclist = [conclist newfilelist(i,:) '\t'];  %AEC for average
   	wvfileformat=[wvfileformat,' %8.12f\t'];
   	concformat = [concformat,' %8.12f\t'];
end   

%filelist = [filelist '\n'];
conclist = [conclist '\n'];
wvfileformat=[wvfileformat,' \n'];
concformat = [concformat,' \n'];

% all_conc (and fdpm) _file

conc_file=strcat(p.outLabel,'_SUM',spec.suffix);


fid=fopen(conc_file, 'w');
fprintf(fid, ['%s\n' filelist], header);
fdpm.opt.scatfit=0;
fprintf(fid, 'FDPM Results: \t real/imag fit: %d \t weighting: %d\nMUA\tUberfit: %d\n', fdpm.opt.imagfit, fdpm.opt.err, fdpm.opt.scatfit);
fprintf(fid, wvfileformat, [fdpm.diodes' o.fd.mua']');
fprintf(fid, 'MUS\n');
fprintf(fid, wvfileformat, [fdpm.diodes' o.fd.mus']');
% fprintf(fid, 'MUA_ERR\n');
% fprintf(fid, wvfileformat, [fdpm.diodes' o.fd.mua_err']');
% fprintf(fid, 'MUS_ERR\n');
% fprintf(fid, wvfileformat, [fdpm.diodes' o.fd.mus_err']');
% fprintf(fid, 'converged\n');
if fdpm.opt.scatfit %only for uberfit
        guss=o.fd.guessnum*ones(size(fdpm.diodes));
    if o.fd.conv
        conv=ones(size(fdpm.diodes));    
    else
        conv=zeros(size(fdpm.diodes));
    end
        fprintf(fid, wvfileformat, [fdpm.diodes' conv']');
else
    fprintf(fid, wvfileformat, [fdpm.diodes']');
end
if (fdpm.cal.which==3) %% Report which phantom if multiple selected
    fprintf(fid, 'Calibration Phantom\n');
    %fprintf(fid,wvfileformat, [fdpm.diodes' o.fd.phantom_used']');
    %fprintf(fid,'%s\n', char(o.fd.phantom_used)');
    diodestr=strcat({''},int2str(fdpm.diodes.')).';
    temp=[diodestr;o.fd.phantom_used];
    txt=sprintf([repmat('%s\t',1,size(temp,1)),'\n'],temp{:});
    fclose(fid);
    dlmwrite(conc_file,txt,'-append','delimiter','');
    fid=fopen(conc_file, 'a+');
end
fprintf(fid, 'SCATTERING\n');
% fprintf(fid, concformat, 'Slope', o.fd.slope);
% fprintf(fid, concformat, 'Prefactor', o.fd.preft);
% fprintf(fid, concformat, 'Slope Err', o.fd.dslope);
% fprintf(fid, concformat, 'Prefactor Err', o.fd.dpreft);
fprintf(fid, 'GUESS #\n');

% if fdpm.opt.scatfit %only for uberfit
%     fprintf(fid, wvfileformat, [fdpm.diodes' guss']');
% else
%     fprintf(fid, wvfileformat, [fdpm.diodes' o.fd.guessnum']');
% end

if physio.fdpm.fit, fprintf(fid, concformat, 'FDPM MUA RESIDUAL', o.fd.ss); end;


if physio.fdpm.fit
	fprintf(fid, ['Conc (FDPM):\tweighting opts: ' int2str(physio.fittype) ' ' int2str(physio.fittype) '\n' conclist]); 
	fprintf(fid, concformat, o.fd.physio{:,:});
end
	if spec.on && physio.spec.fit
		fprintf(fid, ['\nConc (SSFDPM):\n' conclist]); 
		fprintf(fid, concformat, o.ss.physio{:,:}); 
		fprintf(fid, ['\nConc (selected diodes only):\n' conclist]); 
		fprintf(fid, concformat, o.ss.diodphysio{:,:}); 
    end
fprintf(fid,'%s',footer);
fclose(fid); 







% %% db files
% fid = fopen( strcat(p.outLabel, '_dBMU', spec.suffix), 'w');
% fprintf(fid, 'patientID \tdate \tposition \twv \tmua \tdmua \tmus \tdmus \tfitmethod \tcomment\n');
% fid2 = fopen( strcat(p.outLabel, '_dBSUM	', spec.suffix), 'w');
% fprintf(fid2, 'patientID\t date \t position \t variable \t value \t dvalue \t fitmethod \tcomment\n');
% sumformat = '%s \t%s \t%s \t%s \t%8.12f \t%8.12f \t%s\t%s\n';
% if isfield(o.fd, 'physio')
% 	nChromFD = size(o.fd.physio,2)/2;
% end
% if isfield(o.ss, 'physio')
% 	nChromSS = size(o.ss.physio,2)/2;
% end
% 
% % if physio.spec.fit
% % fid3 = fopen( strcat(p.outLabel, 'SPEC-rob', spec.suffix), 'w');
% % fprintf(fid3, 'measurementID\t time\t HbO2 \t Hb \t H2O \t Fat \t THC \t O2Sat \t 660mua \t 660mus \t 690mua \t 690mus \t 785mua \t 785mus \t 830mua \t 830mus \t preft \t slope\n');
% % sumformat3 = '%s \t %s \t%8.12f \t%8.12f \t%8.12f \t%8.12f \t%8.12f \t%8.12f \t%8.12f \t%8.12f \t%8.12f \t%8.12f \t%8.12f \t%8.12f \t%8.12f \t%8.12f \t%8.12f \t%8.12f\n';
% %     for i=1:nFiles,
% %             %fprintf(fid3, sumformat3, newfilelist(i,:), final(i).time, o.ss.physio{i+1,1}, o.ss.physio{i+1,2}, o.ss.physio{i+1,3}, o.ss.physio{i+1,4}, o.ss.physio{i+1,6}, o.ss.physio{i+1,7}, o.fd.mua(i,1),o.fd.mus(i,1),o.fd.mua(i,2),o.fd.mus(i,2),o.fd.mua(i,3),o.fd.mus(i,3), o.fd.preft(1,i), o.fd.slope(1,i));                      
% %             fprintf(fid3, sumformat3, newfilelist(i,:), final(i).time, o.ss.physio{i+1,1}, o.ss.physio{i+1,2}, o.ss.physio{i+1,3}, o.ss.physio{i+1,4}, o.ss.physio{i+1,6}, o.ss.physio{i+1,7}, o.fd.mua(i,1),o.fd.mus(i,1),o.fd.mua(i,2),o.fd.mus(i,2),o.fd.mua(i,3),o.fd.mus(i,3), o.fd.mua(i,4),o.fd.mus(i,4), o.fd.preft(1,i), o.fd.slope(1,i));                      
% %     end
% %     fclose(fid3);
% % end


for i=1:nFiles,
%     for k=1:fdpm.ndiodes,
%         fprintf(fid, '%s \t%s \t%s \t%d \t%8.12f \t%8.12f \t%8.12f \t%8.12f \t%s\t%s\n', p.patientID, ...
%             p.date,newfilelist(i,:), fdpm.diodes(k),  o.fd.mua(i,k), ...
%             o.fd.mus(i,k), fdpm.model_to_fit, p.outLabel);
%     end    
	%same changes here: AEC for average
% 	fprintf(fid2, sumformat, p.patientID, p.date, newfilelist(i,:), 'slope',  o.fd.slope(i), o.fd.dslope(i), 'FD', p.outLabel);
% 	fprintf(fid2, sumformat, p.patientID, p.date, newfilelist(i,:), 'preft',  o.fd.preft(i), o.fd.dpreft(i), 'FD', p.outLabel);
    if o.averaged==0
        o.fd.dss(i)=0;
    end
    if physio.fdpm.fit
        fprintf(fid2, sumformat, p.patientID, p.date, newfilelist(i,:), 'residual',  o.fd.ss(i), o.fd.dss(i), 'FD', p.outLabel);
        for k=1:nChromFD%AEC for avewrage here too
            fprintf(fid2, sumformat, p.patientID, p.date, newfilelist(i,:), o.fd.physio{1,k}, o.fd.physio{1+i, k}, ...
                o.fd.physio{1+i,k+nChromFD}, 'FD', p.outLabel);
        end
    end
end
% fclose(fid);
% %% TIME FILE
% fid = fopen( strcat(p.outLabel, '_TIME', spec.suffix), 'w');
% fprintf(fid,'position\ttime\n');
% for i=1:nFiles
%     fprintf(fid,'%s\t%s\n',newfilelist(i,:),final(i).timestamp);
% end
% fclose(fid);
% 
% if ~spec.on
% 	fclose(fid2);
% 	return; % .. b/c the rest is spectroscopy reporting
% end
% 
% %rest of db writing
% if spec.on
%     for i=1:nFiles,
%         fprintf(fid2, sumformat, p.patientID, p.date, newfilelist(i,:), 'slope',  o.ss.slope(i), o.ss.dslope(i), 'SS', p.outLabel); %AEC added
%         fprintf(fid2, sumformat, p.patientID, p.date, newfilelist(i,:), 'preft',  o.ss.preft(i), o.ss.dpreft(i), 'SS', p.outLabel);
%         if physio.spec.fit
%             nChromSS = size(o.ss.physio,2)/2;
%             for k=1:nChromSS
%                 fprintf(fid2, sumformat, p.patientID, p.date, newfilelist(i,:), o.ss.physio{1,k}, o.ss.physio{1+i, k}, ...
%                     o.ss.physio{1+i,k+nChromSS}, 'SS', p.outLabel);
%             end
%         end
%         if bw.fit && spec.on
%             fprintf(fid2, sumformat, p.patientID, p.date, newfilelist(i,:), 'BWI',  o.bw.bwi(i), 0, 'SS', p.outLabel);
%         end
%     end
% end
% fclose(fid2);

% %% CHROM FILES
% if physio.fdpm.fit
%     fid = fopen( strcat(p.outLabel, '_CHROM_FD', spec.suffix), 'w');
%     fprintf(fid,'position\tslope\tslope_err\tpreft\tpreft_err\t');
%     for k=1:nChromFD
%         fprintf(fid,'%s\t%s\t',o.fd.physio{1,k},strcat(o.fd.physio{1,k},'_err'));
%     end
%     fprintf(fid,'\n');
%     for i=1:nFiles
%         fprintf(fid,'%s\t',newfilelist(i,:));
%         fprintf(fid,'%8.12f\t%8.12f\t',o.fd.slope(i),o.fd.dslope(i));
%         fprintf(fid,'%8.12f\t%8.12f\t',o.fd.preft(i),o.fd.dpreft(i));
%         for k=1:nChromFD
%             fprintf(fid,'%8.12f\t%8.12f\t',o.fd.physio{1+i,k},o.fd.physio{1+i,k+nChromFD});
%         end
%         fprintf(fid,'\n');
%     end
%     fclose(fid);
% end
% if physio.spec.fit
%     fid = fopen( strcat(p.outLabel, '_CHROM_SS', spec.suffix), 'w');
%     fprintf(fid,'position\tslope\tslope_err\tpreft\tpreft_err\t');
%     for k=1:nChromSS
%         fprintf(fid,'%s\t%s\t',o.ss.physio{1,k},strcat(o.ss.physio{1,k},'_err'));
%     end
%     fprintf(fid,'\n');
%     for i=1:nFiles
%         fprintf(fid,'%s\t',newfilelist(i,:));
%         fprintf(fid,'%8.12f\t%8.12f\t',o.ss.slope(i),o.ss.dslope(i));
%         fprintf(fid,'%8.12f\t%8.12f\t',o.ss.preft(i),o.ss.dpreft(i));
%         for k=1:nChromSS
%             fprintf(fid,'%8.12f\t%8.12f\t',o.ss.physio{1+i,k},o.ss.physio{1+i,k+nChromSS});
%         end
%         fprintf(fid,'\n');
%     end
%     fclose(fid);
% end
%% mua_file
% mua_file=strcat(p.outLabel,'_MUA_and_fit',spec.suffix);
% fid=fopen(mua_file, 'w');
% fprintf(fid, '%s', header); fprintf(fid,'%% %s\n','mua in (1/mm)');
% fprintf(fid,'%% chromophore file = %s\n',physio.chrom.file); fprintf(fid,'%% %s\t','wavelength(nm)');
% fileformat='%8.12f\t';
% for i=1:nFiles    
%     if physio.spec.fit
%         fprintf(fid,'%s\t %s\t',char(newfilelist(i,:)),'fit');
%         fileformat=[fileformat,' %8.12f\t %8.12f\t'];
%     else
%         fprintf(fid,'%s\t',char(newfilelist(i,:)));
%         fileformat=[fileformat,' %8.12f\t'];
%     end
% end   
% fprintf(fid,'\n'); fileformat=[fileformat,'\n'];    
% fprintf(fid, fileformat, [spec.wvrange' o.ss.mua]'); 
% fclose(fid);
% 
%     % mua_file_w/o_fitted_spec
%     a_file=strcat(p.outLabel,'_MUA',spec.suffix);
%     fid=fopen(a_file, 'w');
% 
%     fileformat='%8.12f\t';
%     fprintf(fid,'%s\t','wavelength');
%     for i=1:nFiles
%         fprintf(fid,'%s\t',char(newfilelist(i,:)));
%         fileformat=[fileformat,' %8.12f\t'];
%     end
%     fprintf(fid,'%s\t','average');
%     fileformat=[fileformat,' %8.12f\t'];
%     fprintf(fid,'%s\t','standard deviation');
%     fileformat=[fileformat,' %8.12f\t'];
%     fprintf(fid,'\n');fileformat=[fileformat,'\n'];
%     fprintf(fid, fileformat, [spec.wvrange' o.ss.muaonly mean(o.ss.muaonly,2) std(o.ss.muaonly,0,2)]');


%     A = zeros(length(spec.wvrange),nFiles+3);
%     A(:,1) =  spec.wvrange';
% 
%     for n = 1:nFiles
%         A(:,n+1) =  o.ss.mua(:,n);
%     end
% 
%     
%     %huge stupid problem here!!!!
%     A(:,nFiles+2) =  mean(o.ss.mua,2)';
% 
%     A(:,nFiles+3) =  std(o.ss.mua,0,2)';
% 
%     for w = 1:length(spec.wvrange)
%         fprintf(fid, fileformat, A(w,:));
%         fprintf(fid,'\n');
%     end


%     fclose(fid); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






% spec.opt.muaSPEC_from_file=0;
% if spec.opt.muaSPEC_from_file==0,  
% 	% Reflectance_file
% 	ss_file=strcat(p.outLabel,'_specR',spec.suffix);
% 	fid=fopen(ss_file, 'w');
% 	fprintf(fid, ['%s\n' filelist '\n'], header);
% 	fprintf(fid, wvfileformat, [spec.wvrange' o.ss.R]'); 
% 	fclose(fid);  
% end

%muspSPEC 
% e_file=strcat(p.outLabel,'_MUS',spec.suffix);
% fid=fopen(e_file, 'w');
% fprintf(fid, ['%s\n' filelist '\n'], header);
% fprintf(fid, wvfileformat, [spec.wvrange' o.ss.mus]'); 
% fclose(fid); 
fclose('all');
