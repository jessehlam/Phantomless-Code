%======================================================================
%                    raw fdpm data viewer 
%======================================================================
% Select -dcswitch and -miniLBS files for amplitude and phase plotting
% Features :
%  - select multiple files in one File Open window
%  - select files from different folders by responding Yes to "get more
%  files"?
%  - files do not need to have same number or types of diodes, or even 
%  frequencies- the viewer will open each wavelength in a new plot
%
%  Change Log:
%  v0 - Tom O'Sullivan - Original version
%=======================================================================

clear;

[filename1 path1] = uigetfile({'*miniLBS.asc','mDOSI FDPM Files';'*dcswitch.asc','LBS FDPM Files';'*.*',  'All Files (*.*)'},'Pick a file','MultiSelect', 'on');
       cd(path1);
if iscell(filename1)
    filename=filename1;
    for ii=1:length(filename1)
        path{ii}=path1;
    end
else
   filename{1}=[filename1];
   path{1}=path1;
end
       
no_more_files=0;
while no_more_files==0
    button=questdlg('Do you want to load more files?','More Files?','Yes','No','No');
    if strcmp(button,'Yes')
       [filename1 path1] = uigetfile({'*miniLBS.asc','mDOSI FDPM Files ';'*dcswitch.asc','LBS FDPM Files';'*.*',  'All Files (*.*)'},'Pick a file','MultiSelect', 'on');
        
        if iscell(filename1)
            for ii=1:length(filename1)
                path2{ii}=path1;
            end
            filename=[filename filename1];
            path = [path path2];
        else
            filename2{1}=[filename1];
            filename=[filename filename2];
            path2{1}=path1;
            path=[path path2];
        end
        
        cd(path1);
    else
        no_more_files=1;
    end   
end


for ii=1:length(filename)
    filenamelong=[path{ii} filename{ii}];
    dat(ii)=readFDPMDataAtDiodes_viewer(filenamelong);
end

number_of_files=length(dat);
nDiodes = dat(1).nDiodes;
diode_names = dat(1).diode_names;

for ii=1:number_of_files
    if ii==1
        for ind=1:nDiodes         
            diodedata(ind).freq{ii}=dat(ii).freq;
            diodedata(ind).phase{ii}=dat(ii).phase(:,ind);
            diodedata(ind).AC{ii}=dat(ii).AC(:,ind);
            diodedata(ind).name=diode_names(ind);
            if iscell(filename)
                diodedata(ind).filename={filename{1}};
            else
                diodedata(ind).filename={filename};
            end
            
        end
    else
        for jj=1:dat(ii).nDiodes %search through diodes to see if in the list already
            ind=find(diode_names==dat(ii).diode_names(jj));
            if isempty(ind)
                diode_names=[diode_names; dat(ii).diode_names(jj)];
                nDiodes=nDiodes+1;
                ind=nDiodes;
                diodedata(ind).freq{1}=dat(ii).freq;
                diodedata(ind).phase{1}=dat(ii).phase(:,jj);
                diodedata(ind).AC{1}=dat(ii).AC(:,jj);    
                diodedata(ind).name=diode_names(ind);
                diodedata(ind).filename{1}=filename{ii};
            else
                diodedata(ind).freq{end+1}=dat(ii).freq;
                diodedata(ind).phase{end+1}=dat(ii).phase(:,jj);
                diodedata(ind).AC{end+1}=dat(ii).AC(:,jj);    
                diodedata(ind).filename{end+1}=filename{ii};
            end         
        end 
    end
end

for ii=1:nDiodes
    figure;
    subplot(2,1,1); hold all; %plot amplitude
    for jj=1:length(diodedata(ii).freq)
        plot(diodedata(ii).freq{jj},diodedata(ii).AC{jj});
    end
    title(strcat(num2str(diodedata(ii).name),' nm AMPLITUDE'));
    legend(diodedata(ii).filename)
    
    subplot(2,1,2); hold all;  %plot phase
    for jj=1:length(diodedata(ii).freq)
        plot(diodedata(ii).freq{jj},diodedata(ii).phase{jj});
    end
    title(strcat(num2str(diodedata(ii).name),' nm PHASE'));
    legend(diodedata(ii).filename)
end
    