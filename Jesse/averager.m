pth='\\128.200.57.212\Photon Portal\Data\data.phantomless\150128\'; %Path to data files
msmt=dir(strcat(pth,diode,'\','*MHZ-*')); %Find file with keywords
cal=dir(strcat(pth,'*MHZ_*')); %Find file with keywords
file=strcat(diode,'ACRIN2_23MM_50-1000MHZ'); %Output filename
msmtasc={msmt.name}; %Opens the imported filenames
msmtsort=sort_nat(msmtasc); %Sorting the data in numerical order
msmtmat=zeros(401,2); %Preparing the empty matrix
num2avg=100; %Number of files to open and averge
freq=importdata(strcat(pth,diode,'\',msmtsort{1}));

for i=1:num2avg
    msmtdata=importdata(strcat(pth,diode,'\',msmtsort{i})); %Importing data
    phi=msmtdata.data(:,2); %Pulling phase
    amp=msmtdata.data(:,3); %Pulling amp
    msmtmat(:,1)=msmtmat(:,1)+phi; %Adding phi(s)
    msmtmat(:,2)=msmtmat(:,2)+amp; %Adding amp(s)
    steady(i)=20*log10(amp(50));
end

disp(strcat(diode,'_done'))

h=figure;
plot(1:1:num2avg,steady,'k*');
title(diode);
ylabel('Amplitude');
xlabel('Measurement Number');
msmtmat=msmtmat/num2avg;
savefig(h,strcat(pth,file))
xlswrite(strcat(pth,file),msmtmat);
close(figure(1))