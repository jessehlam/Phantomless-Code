function ave_dat=averageFDPMDataAtDiodes(fnames,diodes_selected,stderr)
% fnames must have entire name and path
% Outputs: 
% ave_dat.error
% ave_dat.freq
% ave_dat.phase 
% ave_dat.AC
% ave_dat.dist
% ave_dat.ID
% ave_dat.diode_names
% ave_dat.nDiodes
% ave_dat.ACsd
% ave_dat.phsd
% Example
% ave_dat=averageFDPMDataAtDiodes(fnames,diodes_selected,stderr)
% averageFDPMDataAtDiodes(char({'fdpmdata-1-dcswitch.asc'}),[658 830], [.03, .3])

diod(size(fnames,1)) = struct('AC',[],'phase',[]);  %%array preallocation not really correct
for i=1:size(fnames,1)
    dat=readFDPMDataAtDiodes(fnames(i,:),diodes_selected);
    if dat.error~=0
        ave_dat.error=dat.error;
        return;
    end

    %%ERROR CHECKING
    [aa,bb]=size(dat.AC);

    if dat.nDiodes > bb
        disp('WARNING: Too many diodes selected')
    end


    for j = 1:dat.nDiodes
        diod(j).AC(:,i) = dat.AC(:,j);
        diod(j).phase(:,i) = dat.phase(:,j);
    end
    ave_dat.timestamp = dat.timestamp; %byh trying to avoid error with multiple files
    %Picked some things to check phantom file consistancy
    if i==1
        ave_dat = dat;
    else
        if ave_dat.nDiodes ~= dat.nDiodes
            disp ('Program aborted:  inconsistent numbers of diodes between files to be averaged');
            ave_dat.error=-1;
            return;
        elseif  ave_dat.freq(1) ~= dat.freq(1)
            disp ('Program aborted:  inconsistent initial frequencies between files to be averaged');
            ave_dat.error=-1;
            return;
        elseif   length(ave_dat.freq) ~= length(dat.freq)
            disp ('Program aborted:  inconsistent numbers of frequencies between files to be averaged');
            ave_dat.error=-1;
            return;
        elseif   ave_dat.dist ~=dat.dist,
            disp ('Inconsistent source-detector distances detected in files to be averaged');
            if fdpm.opt.rfixed(1) ~=0
                ave_dat.dist = fdpm.opt.rfixed(1);
                fprintf ('Selecting r =%3.1f mm from user input\n',ave_dat.dist);
            else
                disp ('Could not fix r, program aborting');
                ave_dat.error=-1;
                return;
            end
        end
    end
    
end

for j = 1:ave_dat.nDiodes	
	ave_dat.AC(:,j) = mean(diod(j).AC,2);
	ave_dat.phase(:,j) = mean(diod(j).phase,2);
    if length(fnames)>1
        ave_dat.ACsd(:,j) = std(diod(j).AC,0,2);
		ave_dat.phsd(:,j) = std(diod(j).phase,0,2);
    end
end
if size(fnames,1)==1
    ave_dat.ACsd = stderr(1) .* ave_dat.AC;
	ave_dat.phsd = stderr(2) .*ones(size(ave_dat.phase));
end
ave_dat.phase=ave_dat.phase.*pi/180;  
ave_dat.phsd=ave_dat.phsd.*pi/180;     
ave_dat.error=0;