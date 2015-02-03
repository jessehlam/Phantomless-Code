%%
% Phantomless Fit test script
clear
clc
dataPath = 'C:\Users\Kyle\Documents\GitHub\150202\150202\ACRIN2';
for testnum = 1:10;
    for wavelength = 778 
cd('C:\Users\Kyle\Documents\GitHub\Phantomless-Code\Kyle')
rhoPhantom = 17.5;
rhoSetup = 95;
glassThick = 5;
caldataname = strcat(num2str(wavelength),'ACRIN2_19MM_50-1000MHZ_MATCH.xls');
dataname = strcat(num2str(wavelength),'ACRIN2_19MM_50-1000MHZ.xls');
dataFreqRange = [.05 1];
% fitFreqRange = [.05,1];
% muaRange = [.005 .015 ];
% musRange = [.6 1.3 ];
% muaRes = .0005;
% musRes = .01;
muaRange = [.005 .02 ];
musRange = [.5 1.3 ];
muaRes = .0002;
musRes = .005;

fitFreqRange = [.05,1-(testnum-1)*.05];
[fitFreqRange,muaPredict,musPredict,ampPredict,phasePredict,freqset,dataAmp,dataPhi] = phantomlessFit( rhoPhantom, rhoSetup, glassThick, ...
    wavelength, dataPath,dataname,caldataname,dataFreqRange,fitFreqRange,muaRange,muaRes,musRange,musRes );
cd('C:\Users\Kyle\Documents\GitHub\Phantomless-Code\Kyle')
save(strcat('test4',num2str(testnum),'wavelength',num2str(wavelength)))
    end
end

%{
clear
clc
for testnum = 1:10;
cd('C:\Users\Kyle\Documents\GitHub\Phantomless-Code\Kyle')
rhoPhantom = 23;
rhoSetup = 95;
glassThick = 5;
wavelength = 660;
dataPath = 'C:\Users\Kyle\Documents\GitHub\150128';
caldataname = '660nmACRIN2_23MM_50-1000MHZ_MATCH.xls';
dataname = '660nmACRIN2_23MM_50-1000MHZ.xls';
dataFreqRange = [.05 1];
% fitFreqRange = [.05,1];
% muaRange = [.005 .015 ];
% musRange = [.6 1.3 ];
% muaRes = .0005;
% musRes = .01;
muaRange = [.005 .02 ];
musRange = [.5 1.3 ];
muaRes = .0002;
musRes = .005;

fitFreqRange = [.05,1-(testnum-1)*.05];
[fitFreqRange,muaPredict,musPredict,ampPredict,phasePredict,freqset,dataAmp,dataPhi] = phantomlessFit( rhoPhantom, rhoSetup, glassThick, ...
    wavelength, dataPath,dataname,caldataname,dataFreqRange,fitFreqRange,muaRange,muaRes,musRange,musRes );
cd('C:\Users\Kyle\Documents\GitHub\Phantomless-Code\Kyle')
save(strcat('test',num2str(testnum),'wavelength',num2str(660)))
end
clear
clc
for testnum = 1:10;
cd('C:\Users\Kyle\Documents\GitHub\Phantomless-Code\Kyle')
rhoPhantom = 23;
rhoSetup = 95;
glassThick = 5;
wavelength = 690;
dataPath = 'C:\Users\Kyle\Documents\GitHub\150128';
caldataname = '690nmACRIN2_23MM_50-1000MHZ_MATCH.xls';
dataname = '690nmACRIN2_23MM_50-1000MHZ.xls';
dataFreqRange = [.05 1];
% fitFreqRange = [.05,1];
% muaRange = [.005 .015 ];
% musRange = [.6 1.3 ];
% muaRes = .0005;
% musRes = .01;
muaRange = [.005 .02 ];
musRange = [.5 1.3 ];
muaRes = .0002;
musRes = .005;

fitFreqRange = [.05,1-(testnum-1)*.05];
[fitFreqRange,muaPredict,musPredict,ampPredict,phasePredict,freqset,dataAmp,dataPhi] = phantomlessFit( rhoPhantom, rhoSetup, glassThick, ...
    wavelength, dataPath,dataname,caldataname,dataFreqRange,fitFreqRange,muaRange,muaRes,musRange,musRes );
cd('C:\Users\Kyle\Documents\GitHub\Phantomless-Code\Kyle')
save(strcat('test',num2str(testnum),'wavelength',num2str(690)))
end
clear
clc
for testnum = 1:10;

cd('C:\Users\Kyle\Documents\GitHub\Phantomless-Code\Kyle')
rhoPhantom = 23;
rhoSetup = 95;
glassThick = 5;
wavelength = 779;
dataPath = 'C:\Users\Kyle\Documents\GitHub\150128';
caldataname = '779nmACRIN2_23MM_50-1000MHZ_MATCH.xls';
dataname = '779nmACRIN2_23MM_50-1000MHZ.xls';
dataFreqRange = [.05 1];
% fitFreqRange = [.05,1];
% muaRange = [.005 .015 ];
% musRange = [.6 1.3 ];
% muaRes = .0005;
% musRes = .01;
muaRange = [.005 .02 ];
musRange = [.5 1.3 ];
muaRes = .0002;
musRes = .005;

fitFreqRange = [.05,1-(testnum-1)*.05];
[fitFreqRange,muaPredict,musPredict,ampPredict,phasePredict,freqset,dataAmp,dataPhi] = phantomlessFit( rhoPhantom, rhoSetup, glassThick, ...
    wavelength, dataPath,dataname,caldataname,dataFreqRange,fitFreqRange,muaRange,muaRes,musRange,musRes );
cd('C:\Users\Kyle\Documents\GitHub\Phantomless-Code\Kyle')
save(strcat('test',num2str(testnum),'wavelength',num2str(779)))
end
clear
clc
for testnum = 1:10;

cd('C:\Users\Kyle\Documents\GitHub\Phantomless-Code\Kyle')
rhoPhantom = 23;
rhoSetup = 95;
glassThick = 5;
wavelength = 830;
dataPath = 'C:\Users\Kyle\Documents\GitHub\150128';
caldataname = '830nmACRIN2_23MM_50-1000MHZ_MATCH.xls';
dataname = '830nmACRIN2_23MM_50-1000MHZ.xls';
dataFreqRange = [.05 1];
% fitFreqRange = [.05,1];
% muaRange = [.005 .015 ];
% musRange = [.6 1.3 ];
% muaRes = .0005;
% musRes = .01;
muaRange = [.005 .02 ];
musRange = [.5 1.3 ];
muaRes = .0002;
musRes = .005;

fitFreqRange = [.05,1-(testnum-1)*.05];
[fitFreqRange,muaPredict,musPredict,ampPredict,phasePredict,freqset,dataAmp,dataPhi] = phantomlessFit( rhoPhantom, rhoSetup, glassThick, ...
    wavelength, dataPath,dataname,caldataname,dataFreqRange,fitFreqRange,muaRange,muaRes,musRange,musRes );
cd('C:\Users\Kyle\Documents\GitHub\Phantomless-Code\Kyle')
save(strcat('test',num2str(testnum),'wavelength',num2str(830)))
end
%}