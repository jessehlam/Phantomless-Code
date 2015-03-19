warning('off')
pth='\\128.200.57.212\Photon Portal\Data\data.phantomless\150128\Processed\Lower Res\Amp First'; %Path of files
files=dir(pth); %Getting names of files
pullnames={files.name}; %Pulling the names from the director
filesorted=sort_nat(pullnames); %Sorting in logical order
filesorted=filesorted(3:52); %Removing non-files
diodes={'660 Compiled' '690 Compiled' '778 Compiled' '800 Compiled' '830 Compiled'};
besttot=10;
best=0;
titles={'Freq' 'PhiDat' 'AmpDat' 'PhiGuess' 'AmpGuess'};

for j=0:length(diodes)-1
    for i=1+j*10:10*(j+1)
        if best < besttot %Looping from 1 to 10
            best=best+1; %If less than 10, adds 1 to current value
        else
            best=1; %If 10, then loops back to 1
        end
        
        %currentfile=xlsread(strcat(pth,'\',filesorted{i})); %Importing data
        %xlswrite(strcat(pth,'\',diodes{j+1}),currentfile,best); %Writing data
        xlswrite(strcat(pth,'\',diodes{j+1}),titles,best,'A2'); %Writing data
    end
end

pth='\\128.200.57.212\Photon Portal\Data\data.phantomless\150128\Processed\Lower Res\Phi First'; %Path of files
files=dir(pth); %Getting names of files
pullnames={files.name}; %Pulling the names from the director
filesorted=sort_nat(pullnames); %Sorting in logical order
filesorted=filesorted(3:52); %Removing non-files
besttot=10;
best=0;

for j=0:length(diodes)-1
    for i=1+j*10:10*(j+1)
        if best < besttot %Looping from 1 to 10
            best=best+1; %If less than 10, adds 1 to current value
        else
            best=1; %If 10, then loops back to 1
        end
        
        %currentfile=xlsread(strcat(pth,'\',filesorted{i})); %Importing data
        %xlswrite(strcat(pth,'\',diodes{j+1}),currentfile,best); %Writing data
        xlswrite(strcat(pth,'\',diodes{j+1}),titles,best,'A2'); %Writing data
    end
end