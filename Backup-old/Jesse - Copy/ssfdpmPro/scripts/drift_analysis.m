% mdosi drift analysis
clear;
%close all;

file_location = 'C:\Users\Tom OSullivan\Desktop\temp';
broadband = 1;  %1 if want to analyze BB MUA and MUS too



if exist(file_location,'dir')
    cd(file_location);
end

[filename_sum path_sum] = uigetfile({'*_SUM.asc','mDOSI FDPM File';'*.*',  'All Files (*.*)'},'Select SUM file','MultiSelect', 'off');
 
% GET OPTICAL PROPERTIES FROM SUM FILE

fname=[path_sum '\' filename_sum];
filenameroot=filename_sum(1:end-7);
fid=fopen(fname,'r');

fw='';
mua_line_number=0;

% COUNT THE NUMBER OF DIODES
while ~strcmp(fw,'MUA')   
    l=fgetl(fid);
    fw=strtok(l);
    mua_line_number=mua_line_number+1;
end
l=fgetl(fid);
fw=strtok(l);
mus_line_number=mua_line_number+1;
num_diodes=0;
while ~strcmp(fw,'MUS')  
    l=fgetl(fid);
    fw=strtok(l);
    num_diodes=num_diodes+1;
    mus_line_number=mus_line_number+1;
end

% COUNT THE NUMBER OF MEASUREMENTS
temp = fgetl(fid);
[rows, cols] = size(str2num(temp));
fclose(fid);

% GET MUA VALUES
fid=fopen(fname,'r');
for ii=1:mua_line_number;
    l=fgetl(fid);
end
MUA = fscanf(fid,'%f',[cols num_diodes])'; 
fclose(fid);

% GET MUS VALUES
fid=fopen(fname,'r');
for ii=1:mus_line_number;
    l=fgetl(fid);
end
MUS = fscanf(fid,'%f',[cols num_diodes])'; 
fclose(fid);

% GET TIME VALUES FOR DRIFT
filename_time=[path_sum filenameroot 'TIME.asc'];
fname=filename_time;
fid=fopen(fname,'r');
if fid==-1
  disp(sprintf('Could not open broadband file %s.',fname));
return
end
drift_time_raw = textscan(fid,'%s %s');
fclose(fid);
for ii=2:length(drift_time_raw{2})
	drift_time_str=drift_time_raw{2}(ii);
    drift_time(ii-1)=str2num(drift_time_str{1}(1:2))*60*60+str2num(drift_time_str{1}(4:5))*60+str2num(drift_time_str{1}(7:8));
    if (ii==2)
        offset_time=drift_time(ii-1);
        drift_time(ii-1)=0;
    else
        drift_time(ii-1)=drift_time(ii-1)-offset_time;
    end
end

% CREATE MUA AND MUS PLOTS
for ii=1:num_diodes;
    diodename{ii}=num2str(MUA(ii,1));
    g=figure;
    subplot(2,1,1);  %plot mua
    plot(drift_time/60,MUA(ii,2:end));
    xlabel('Time (min)');
    stdev=std(MUA(ii,2:end));
    avg=mean(MUA(ii,2:end));
    cov=stdev/avg*100;
    title(strcat(diodename{ii},' nm MUA, mean=',num2str(avg,'%0.5f'),', stdev=',num2str(stdev,'%0.2e'),', COV=',num2str(cov,'%0.3f'),'%'));
      
    subplot(2,1,2); hold all;  %plot mus
    plot(drift_time/60,MUS(ii,2:end));
    xlabel('Time (min)');
    stdev=std(MUS(ii,2:end));
    avg=mean(MUS(ii,2:end));
    cov=stdev/avg*100;
    title(strcat(diodename{ii},' nm MUS, mean=',num2str(avg,'%0.3f'),', stdev=',num2str(stdev,'%0.2e'),', COV=',num2str(cov,'%0.3f'),'%'));
    
    naampje = [path_sum diodename{ii} 'nm_driftMUs.jpg'];
    saveas(g,naampje,'jpg')
end

if (broadband)
    filename_bb_mua=[path_sum filenameroot 'MUA_and_fit.asc'];
    filename_bb_mus=[path_sum filenameroot 'MUS.asc'];
    
    fname=filename_bb_mua;
    fid=fopen(fname,'r');
    
    if fid==-1
    disp(sprintf('Could not open broadband file %s.',fname));
    return
    end
    
    for ii=1:6
    l=fgetl(fid);
    end
  
    if ~isempty(strfind(l,'fit'))
        % chrom fit turned on
        temp_bbMUA = fscanf(fid,'%f',[2*cols-1 inf])';
        bbMUA(:,1) = temp_bbMUA(:,1);
        for ii=1:cols-1
            bbMUA(:,ii+1)=temp_bbMUA(:,ii*2);
        end
    else
        % chrom fit turned off
        bbMUA = fscanf(fid,'%f',[cols inf])';
    end
    
    
    [r c] = size(bbMUA);
    fclose(fid);
    g= figure;
    subplot(2,1,1);
    hold on;
    for ii=2:(c-2);
        plot(bbMUA(:,1),bbMUA(:,ii));
    end
    title('All Broadband MUA Measurements');
    xlabel('Wavelength (nm)');
     subplot(2,1,2);
    MUA_mean=mean(bbMUA(:,2:end)')';
    MUA_stdev=std(bbMUA(:,2:end)')';
    bb_COV_mua=MUA_stdev./MUA_mean*100;
    plot(bbMUA(:,1),bb_COV_mua);
    title(['Broadband mua coefficient of variation, average=',num2str(mean(bb_COV_mua),'%0.3f'),'%']);
    ylabel('Coefficient of variation (%)');      
    xlabel('Wavelength (nm)');
    naampje = [path_sum 'Broadband_mua_drift.jpg'];
    saveas(g,naampje,'jpg')

    fname=filename_bb_mus;
    fid=fopen(fname,'r');
    
    if fid==-1
    disp(sprintf('Could not open broadband file %s.',fname));
    return
    end
     
    l=fgetl(fid); l=fgetl(fid); l=fgetl(fid); l=fgetl(fid); l=fgetl(fid);
    bbMUS = fscanf(fid,'%f',[cols inf])';
    fclose(fid);
    [r c] = size(bbMUS);
    g=figure();
    subplot(2,1,1);
    hold on;
    for ii=2:c;
        plot(bbMUS(:,1),bbMUS(:,ii));
    end
    title('All Broadband MUS Measurements');
    xlabel('Wavelength (nm)');
    subplot(2,1,2);
    MUS_mean=mean(bbMUS(:,2:end)')';
    MUS_stdev=std(bbMUS(:,2:end)')';
    bb_COV=MUS_stdev./MUS_mean*100;
    plot(bbMUS(:,1),bb_COV);
    title(['Broadband mus coefficient of variation, average=',num2str(mean(bb_COV),'%0.3f'),'%']);
    ylabel('Coefficient of variation (%)');   
    xlabel('Wavelength (nm)');
    naampje = [path_sum 'Broadband_mus_drift.jpg'];
    saveas(g,naampje,'jpg')
end

