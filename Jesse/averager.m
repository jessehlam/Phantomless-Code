pth='\\128.200.57.212\Photon Portal\Data\data.phantomless\150128\'; %Path to data files
num2avg=100; %Number of files to open and averge

msmt=dir(strcat(pth,diode,'\','*MHZ-*')); %Find file with keywords
file=strcat(diode,'ACRIN2_23MM_50-1000MHZ'); %Output filename
msmtasc={msmt.name}; %Opens the imported filenames
msmtsort=sort_nat(msmtasc); %Sorting the data in numerical order
msmtmat=zeros(401,2); %Preparing the empty matrix

cal=dir(strcat(pth,diode,'\','*MHZ_*')); %Find file with keywords
filematch=strcat(diode,'ACRIN2_23MM_50-1000MHZ','_MATCH'); %Output filename
calasc={cal.name}; %Opens the imported filenames
calsort=sort_nat(calasc); %Sorting the data in numerical order
calmat=zeros(401,2); %Preparing the empty matrix


for i=1:num2avg
    msmtdata=importdata(strcat(pth,diode,'\',msmtsort{i})); %Importing data
    phi=msmtdata.data(:,2); %Pulling phase
    amp=msmtdata.data(:,3); %Pulling amp
    msmtmat(:,1)=msmtmat(:,1)+phi; %Adding phi(s)
    msmtmat(:,2)=msmtmat(:,2)+amp; %Adding amp(s)
    steady(i)=20*log10(amp(20));
    
    caldata=importdata(strcat(pth,diode,'\',calsort{i})); %Importing data
    calphi=caldata.data(:,2); %Pulling phase
    calamp=caldata.data(:,3); %Pulling amp
    calmat(:,1)=calmat(:,1)+calphi; %Adding phi(s)
    calmat(:,2)=calmat(:,2)+calamp; %Adding amp(s)
    steadycal(i)=20*log10(calamp(20));
end

h=figure;
plot(1:1:num2avg,steady,'k*');
title(diode);
ylabel('Amplitude');
xlabel('Measurement Number');
msmtmat=msmtmat/num2avg;
savefig(h,strcat(pth,file))
xlswrite(strcat(pth,file),msmtmat);

j=figure;
plot(1:1:num2avg,steadycal,'b*');
title(strcat(diode,'_Match'));
ylabel('Amplitude');
xlabel('Measurement Number');
calmat=calmat/num2avg;
savefig(j,strcat(pth,filematch))
xlswrite(strcat(pth,filematch),calmat);

close all

disp(strcat(diode,'_done'))