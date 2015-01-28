% Plot Noise Floor
cd C:\Users\Kyle\Documents\GitHub\150122
[samp1, pth1, filterindex1] = uigetfile('*.asc','Select Dark Count File','MultiSelect', 'off',pwd);
noiseFloor = importdata(strcat(pth1,samp1));
noiseFloor.f = noiseFloor.data(:,1)/1000;
noiseFloor.phi = noiseFloor.data(:,2);
noiseFloor.amp = noiseFloor.data(:,3);
noiseFloor.amp2 = noiseFloor.amp/calfavg.amp;
noiseFloor.cal_amp = noiseFloor.amp./amppoly(1);
plot(noiseFloor.f,noiseFloor.cal_amp)
cd C:\Users\Kyle\Documents\GitHub\Phantomless-Code\Kyle