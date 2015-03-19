%% Combine LBS wavelength files into one file per phantom

clear
clc

% dirString = 'C:\Users\Kyle\Downloads\150310';
% pathString = 'C:\Users\Kyle\Downloads\150310\150310';
% phantomList = {'ARYA' 'INO1' 'OBERYN1' 'VACS1' 'VACS2' 'PH010' 'ACRIN2' 'BOT1'};
dirString = 'C:\Users\Jesse\Desktop\Measurement\150316\';
pathString = 'C:\Users\Jesse\Desktop\Measurement\150316\msmt\';
phantomList = {'Oberyn1'};

% lists = 2;
%%
for lists = 1:length(phantomList)
    % files = dir(strcat(pathString,'\*ARYA4-MATCH-dcswitch.asc'))
    %% Measure File 1
    phantomName = phantomList{lists};%'VACS2';
    for j = 1:5
        if j == 1
            filesMeasure1 = dir(strcat(pathString,'\*',phantomName,'*-MATCH-*'));
        elseif j == 2
            filesMeasure1 = dir(strcat(pathString,'\*',phantomName,'*-MATCH2-*'));
        elseif j == 3
             filesMeasure1 = dir(strcat(pathString,'\*',phantomName,'*-1*'));
        elseif j == 4
            filesMeasure1 = dir(strcat(pathString,'\*',phantomName,'*-2*'));
        elseif j == 5
            filesMeasure1 = dir(strcat(pathString,'\*',phantomName,'*-3*'));
        end
    % for measures = 1:3
    cd(pathString)
    wavelengthString = [];
    for i = 1:length(filesMeasure1)
        %     for i = 1:length(importedFiles{measures})
        wvcase = filesMeasure1(i).name(1:3);
        wavelengthString = [wavelengthString strcat(wvcase,',')];
        data = importdata(filesMeasure1(i).name);
        sumData(:,1) = data.data(:,1);
%         sumData(:,2*i) = data.data(:,2*i);
%         sumData(:,2*i+1) = data.data(:,2*i+1); 
%         if strcmp(wvcase,'660')
%             sumData(:,2*i) = data.data(:,2);
%             sumData(:,2*i+1) = data.data(:,3);
%         elseif strcmp(wvcase, '690')
%             sumData(:,2*i) = data.data(:,4);
%             sumData(:,2*i+1) = data.data(:,5);
        if strcmp(wvcase,'778')
            sumData(:,2*i) = data.data(:,2);
            sumData(:,2*i+1) = data.data(:,3);
        elseif strcmp(wvcase,'800')
            sumData(:,2*i) = data.data(:,4);
            sumData(:,2*i+1) = data.data(:,5);
        elseif strcmp(wvcase,'830')
            sumData(:,2*i) = data.data(:,6);
            sumData(:,2*i+1) = data.data(:,7);
        elseif strcmp(wvcase,'855')
            sumData(:,2*i) = data.data(:,8);
            sumData(:,2*i+1) = data.data(:,9);
        end
        
%         sumData(:,2*i) = data.data(:,2);
%         sumData(:,2*i+1) = data.data(:,3);
    end
    
    headerLine12 = 'Laser names: 779 798 829 855 *End of laser names';
    headerLine16= {'Frequency (MHz)' 'phase' 'amp' 'phase' 'amp' 'phase' 'amp' 'phase' 'amp' 'phase' 'amp' 'phase' 'amp'};
    cd(dirString)
    if j == 1  
        fid = fopen(strcat(phantomName,'-MATCH-dcswitch.asc'),'w');
    elseif j == 2
        fid = fopen(strcat(phantomName,'-MATCH2-dcswitch.asc'),'w');
    elseif j == 3
        fid = fopen(strcat(phantomName,'-1-dcswitch.asc'),'w');
    elseif j == 4
        fid = fopen(strcat(phantomName,'-2-dcswitch.asc'),'w');
    elseif j == 5
        fid = fopen(strcat(phantomName,'-3-dcswitch.asc'),'w');
    end
%     fid = fopen(strcat(phantomName,'-MATCH-dcswitch.asc'),'w');
%     fid = fopen(strcat(phantomName,'-MATCH2-dcswitch.asc'),'w');
%     fid = fopen(strcat(phantomName,'-1-dcswitch.asc'),'w');
%     fid = fopen(strcat(phantomName,'-2-dcswitch.asc'),'w');
%     fid = fopen(strcat(phantomName,'-3-dcswitch.asc'),'w');
    for i = 1:12
        fprintf(fid,data.textdata{i});
        fprintf(fid,'\n');
    end
%     fprintf(fid,headerLine12);
    fprintf(fid,'\n');
    for i = 13:15
        fprintf(fid,data.textdata{i});
        fprintf(fid,'\n');
    end
    for j = 1:length(headerLine16)
        fprintf(fid, headerLine16{j});
        fprintf(fid,'\t');
    end
    fprintf(fid,'\n');
    for i=1:length(sumData(:,1))
        fprintf(fid, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t', sumData(i,:));
        fprintf(fid,'\n');
    end
    fclose('all');
    end
end
%     %% Measure File 2
%     cd(pathString)
%     wavelengthString = [];
%     for i = 1:length(filesMeasure2)
%         %     for i = 1:length(importedFiles{measures})
%         wvcase = filesMeasure2(i).name(1:3);
%         wavelengthString = [wavelengthString strcat(wvcase,',')];
%         data = importdata(filesMeasure2(i).name);
%         sumData(:,1) = data.data(:,1);
%         if strcmp(wvcase,'660')
%             sumData(:,2*i) = data.data(:,2);
%             sumData(:,2*i+1) = data.data(:,3);
%         elseif strcmp(wvcase, '690')
%             sumData(:,2*i) = data.data(:,4);
%             sumData(:,2*i+1) = data.data(:,5);
%         elseif strcmp(wvcase,'778')
%             sumData(:,2*i) = data.data(:,6);
%             sumData(:,2*i+1) = data.data(:,7);
%         elseif strcmp(wvcase,'800')
%             sumData(:,2*i) = data.data(:,8);
%             sumData(:,2*i+1) = data.data(:,9);
%         elseif strcmp(wvcase,'830')
%             sumData(:,2*i) = data.data(:,10);
%             sumData(:,2*i+1) = data.data(:,11);
%         end
%     end
%     
%     headerLine12 = 'Laser names: 657 779 798 829 *End of laser names';
%     headerLine16= {'Frequency (MHz)' 'phase' 'amp' 'phase' 'amp' 'phase' 'amp' 'phase' 'amp' 'phase' 'amp'};
%     cd(dirString)
%     fid = fopen(strcat(phantomName,'-2-dcswitch.asc'),'w');
%     for i = 1:11
%         fprintf(fid,data.textdata{i});
%         fprintf(fid,'\n');
%     end
%     fprintf(fid,headerLine12);
%     fprintf(fid,'\n');
%     for i = 13:15
%         fprintf(fid,data.textdata{i});
%         fprintf(fid,'\n');
%     end
%     for j = 1:length(headerLine16)
%         fprintf(fid, headerLine16{j});
%         fprintf(fid,'\t');
%     end
%     fprintf(fid,'\n');
%     for i=1:length(sumData(:,1))
%         fprintf(fid, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t', sumData(i,:));
%         fprintf(fid,'\n');
%     end
%     fclose('all');
%     
%     %% Measure File 3
%     cd(pathString)
%     wavelengthString = [];
%     for i = 1:length(filesMeasure3)
%         %     for i = 1:length(importedFiles{measures})
%         wvcase = filesMeasure3(i).name(1:3);
%         wavelengthString = [wavelengthString strcat(wvcase,',')];
%         data = importdata(filesMeasure3(i).name);
%         sumData(:,1) = data.data(:,1);
%         if strcmp(wvcase,'660')
%             sumData(:,2*i) = data.data(:,2);
%             sumData(:,2*i+1) = data.data(:,3);
%         elseif strcmp(wvcase, '690')
%             sumData(:,2*i) = data.data(:,4);
%             sumData(:,2*i+1) = data.data(:,5);
%         elseif strcmp(wvcase,'778')
%             sumData(:,2*i) = data.data(:,6);
%             sumData(:,2*i+1) = data.data(:,7);
%         elseif strcmp(wvcase,'800')
%             sumData(:,2*i) = data.data(:,8);
%             sumData(:,2*i+1) = data.data(:,9);
%         elseif strcmp(wvcase,'830')
%             sumData(:,2*i) = data.data(:,10);
%             sumData(:,2*i+1) = data.data(:,11);
%         end
%     end
%     
%     headerLine12 = 'Laser names: 657 779 798 829 *End of laser names';
%     headerLine16= {'Frequency (MHz)' 'phase' 'amp' 'phase' 'amp' 'phase' 'amp' 'phase' 'amp' 'phase' 'amp'};
%     cd(dirString)
%     fid = fopen(strcat(phantomName,'-3-dcswitch.asc'),'w');
%     for i = 1:11
%         fprintf(fid,data.textdata{i});
%         fprintf(fid,'\n');
%     end
%     fprintf(fid,headerLine12);
%     fprintf(fid,'\n');
%     for i = 13:15
%         fprintf(fid,data.textdata{i});
%         fprintf(fid,'\n');
%     end
%     for j = 1:length(headerLine16)
%         fprintf(fid, headerLine16{j});
%         fprintf(fid,'\t');
%     end
%     fprintf(fid,'\n');
%     for i=1:length(sumData(:,1))
%         fprintf(fid, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t', sumData(i,:));
%         fprintf(fid,'\n');
%     end
%     fclose('all');
%     
%     %% Match File
%     cd(pathString)
%     for i = 1:length(filesMatch)
%         wvcase = filesMatch(i).name(1:3);
%         wavelengthString = [wavelengthString strcat(wvcase,',')];
%         data = importdata(filesMatch(i).name);
%         sumData(:,1) = data.data(:,1);
%         if strcmp(wvcase,'660')
%             sumData(:,2*i) = data.data(:,2);
%             sumData(:,2*i+1) = data.data(:,3);
%         elseif strcmp(wvcase, '690')
%             sumData(:,2*i) = data.data(:,4);
%             sumData(:,2*i+1) = data.data(:,5);
%         elseif strcmp(wvcase,'778')
%             sumData(:,2*i) = data.data(:,6);
%             sumData(:,2*i+1) = data.data(:,7);
%         elseif strcmp(wvcase,'800')
%             sumData(:,2*i) = data.data(:,8);
%             sumData(:,2*i+1) = data.data(:,9);
%         elseif strcmp(wvcase,'830')
%             sumData(:,2*i) = data.data(:,10);
%             sumData(:,2*i+1) = data.data(:,11);
%         end
%     end
%     
%     headerLine12 = 'Laser names: 657 689 779 798 829 *End of laser names';
%     headerLine16= {'Frequency (MHz)' 'phase' 'amp' 'phase' 'amp' 'phase' 'amp' 'phase' 'amp' 'phase' 'amp'};
%     cd(dirString)
%     fid = fopen(strcat(phantomName,'-MATCH-dcswitch.asc'),'w');
%     for i = 1:11
%         fprintf(fid,data.textdata{i});
%         fprintf(fid,'\n');
%     end
%     fprintf(fid,headerLine12);
%     fprintf(fid,'\n');
%     for i = 13:15
%         fprintf(fid,data.textdata{i});
%         fprintf(fid,'\n');
%     end
%     for j = 1:length(headerLine16)
%         fprintf(fid, headerLine16{j});
%         fprintf(fid,'\t');
%     end
%     fprintf(fid,'\n');
%     for i=1:length(sumData(:,1))
%         fprintf(fid, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t', sumData(i,:));
%         fprintf(fid,'\n');
%     end
%     fclose('all');
% end
