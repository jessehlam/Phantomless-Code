% Reads fdpm data files at selected diodes
% Last modified: 10/08/08 BYH
% Filename should include entire path
% Outputs: 
% dat.error
% dat.freq
% dat.phase 
% dat.AC
% dat.dist
% dat.ID
% dat.diode_names
% dat.nDiodes
% Example Call: 
% readFDPMDataAtDiodes('fdpmdata-1-dcswitch.asc',[658 682 785 810 830])
% need to convert to radians after

function dat=readFDPMData(fname)

fid=fopen(fname,'r');

if fid==-1
    disp(sprintf('Could not open file %s.',fname));
    dat.error=-1;
    return
end

fw='';
while ~strcmp(fw,'Frequency')   %this section reads needed header info
    l=fgetl(fid);
    fw=strtok(l);
    
    if findstr(l,'Source-Detector (mm):')
        dat.dist = str2double(strtok(l(22:length(l))));
    elseif findstr(l,'Patient ID:')
        dat.ID = strtok(l(12:length(l)));
    elseif findstr(l,'Laser names:')
        dat.diode_names = sscanf(l(13:length(l)), '%d');
        dat.nDiodes = length(dat.diode_names);
    end
end
            
A = fscanf(fid,'%lg',[1+dat.nDiodes*2 inf]);   % read numerical data

fclose(fid);  

dat.freq=A(1,:)';
for j=1:dat.nDiodes
	dat.phase(:,j) = A(2+ 2*(j-1), :)';
	dat.AC(:,j) = A(3+ 2*(j-1), :)';
end

% %REMOVE UN-WANTED DIODES
% j=1;
% while j<=dat.nDiodes  %AEC 8/02 to fix the problem of assigning wrong phantom data with wrong wavelength
% 	idx = find(dat.diode_names(j)==diodes_selected);
% 
%     if length(idx)>1
%         disp('Error: duplicates in diode array');
%         dat.error=-1;
%         return
%     elseif isempty(idx)
%         dat.nDiodes=dat.nDiodes-1;
%         dat.diode_names(j) = [];
%         dat.phase(:,j) = [];
%         dat.AC(:,j) = [];
%     else
%         j = j+1;
%     end
% end
% if dat.nDiodes==0
%     disp(['Error: No selected diodes match with data in file ' fname]);
%     dat.error=-1;
%     return
% end
dat.error=0;
end


