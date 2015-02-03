pth='C:\Users\Kyle\Documents\GitHub\150130\830\830'; %Path to data files
num2avg=100; %Number of files to open and averge

msmt=dir(strcat(pth,'\','*MHZ-*')); %Find file with keywords
file=strcat('PH010_18MM_50-1000MHZ'); %Output filename
msmtasc={msmt.name}; %Opens the imported filenames
msmtsort=sort_nat(msmtasc); %Sorting the data in numerical order
msmtmat=zeros(401,3); %Preparing the empty matrix

cal=dir(strcat(pth,'\','*MHZ_*')); %Find file with keywords
filematch=strcat('PH010_18MM_50-1000MHZ','_MATCH'); %Output filename
calasc={cal.name}; %Opens the imported filenames
calsort=sort_nat(calasc); %Sorting the data in numerical order
calmat=zeros(401,3); %Preparing the empty matrix

for i=1:num2avg
    msmtdata=importdata(strcat(pth,'\',msmtsort{i})); %Importing data
    phi=msmtdata.data(:,2); %Pulling phase
    amp=msmtdata.data(:,3); %Pulling amp
    msmtmat(:,2)=msmtmat(:,2)+phi; %Adding phi(s)
    msmtmat(:,3)=msmtmat(:,3)+amp; %Adding amp(s)
    steady(i)=20*log10(amp(20));
    
    caldata=importdata(strcat(pth,'\',calsort{i})); %Importing data
    calphi=caldata.data(:,2); %Pulling phase
    calamp=caldata.data(:,3); %Pulling amp
    calmat(:,2)=calmat(:,2)+calphi; %Adding phi(s)
    calmat(:,3)=calmat(:,3)+calamp; %Adding amp(s)
    steadycal(i)=20*log10(calamp(20));
end

h=figure;
plot(1:1:num2avg,steady,'k*'); %Plot "tissue" amplitude over measurement number
title('830');
ylabel('Amplitude');
xlabel('Measurement Number');
msmtmat=msmtmat/num2avg; %Average the amplitude and phase
msmtmat(:,1)=msmtdata.data(:,1); %Pulling frequency range
% savefig(h,strcat(pth,file)); %Save the plot
xlswrite(strcat(pth,file),msmtmat); %Write the data to file

j=figure;
plot(1:1:num2avg,steadycal,'b*'); %Plot "tissue" amplitude over measurement number
title(strcat('830','_Match'));
ylabel('Amplitude');
xlabel('Measurement Number');
calmat=calmat/num2avg; %Average the amplitude and phase
calmat(:,1)=caldata.data(:,1); %Pulling frequency range
% savefig(j,strcat(pth,filematch)); %Save the plot
xlswrite(strcat(pth,filematch),calmat); %Write the data to file

close all %Close the figures

disp(strcat('830','_done')) %Display progress