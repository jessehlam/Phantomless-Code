clear
clc
cd('C:\Users\Kyle\Documents\GitHub\Phantomless-Code\Kyle');
k  = dir('PH010_830_Test_18\*.mat');
filesnames = {k.name}';
cd PH010_830_Test_18
testData = [];
testProps = [];
amplitudes=[];
phases=[];
for i = 1:length(filesnames)
    load(filesnames{i})
%     mu = [muaPredict musPredict];
%     op_fin = [mu .8 1.43];
%     VtsSolvers.SetSolverType('PointSourceSDA');
%     vtsmod = VtsSolvers.ROfRhoAndFt(op_fin, 19, freqset);
%     mod_amp = abs(vtsmod)/(abs(vtsmod(1)));
%     mod_phi_raw = unwrap(-angle(vtsmod)*180/pi);
%     mod_phi = mod_phi_raw-mod_phi_raw(1);
%     muaPredict = mu(1);
%     musPredict = mu(2);
%     ampPredict = mod_amp;
%     phasePredict = mod_phi;
    testData = [testData ampPredict dataAmp phasePredict dataPhi];
    testProps = [ testProps; fitFreqRange(1) fitFreqRange(2) muaPredict musPredict];
    amplitudes = [amplitudes ampPredict];
    phases = [phases phasePredict];
end

%% Plot Results
% figure(1);
% subplot(2,1,1)
% hold on
% plot(freqset,dataAmp);
% for i=1:length(filesnames)
%     hold on
%     plot(freqset,testData(:,4*(i-1)+1));
% end

plot(freqset,testData(:,4),freqset,phases);
legend('Data','0.550','0.500','1','0.950','0.900','0.850','0.800','0.750','0.700','0.650','0.600');
title('Freq Range Fits PH010 at 830nm'), xlabel('Freq in GHz'),ylabel('Normalized Phase')
%,0.00710000000000000,0.980000000000000;0.500000000000000,0.00720000000000000,0.985000000000000;1,0.00870000000000000,1.30000000000000;0.950000000000000,0.00880000000000000,1.30000000000000;0.900000000000000,0.00850000000000000,1.23500000000000;0.850000000000000,0.00800000000000000,1.14500000000000;0.800000000000000,0.00730000000000000,1.01500000000000;0.750000000000000,0.00740000000000000,1.03500000000000;0.700000000000000,0.00710000000000000,0.970000000000000;0.650000000000000,0.00710000000000000,0.970000000000000;0.600000000000000,0.00710000000000000,0.970000000000000]
% cd('C:\Users\Kyle\Documents\GitHub\Phantomless-Code\Kyle');
% k  = dir('FreqRangeTest\*.mat');
% filesnames = {k.name}';
% cd FreqRangeTest
% testData = [];
% testProps = [];
% for i = 1:length(filesnames)
%     load(filesnames{i})
%     mu = [muaPredict musPredict];
%     op_fin = [mu .8 1.43];
%     VtsSolvers.SetSolverType('PointSourceSDA');
%     vtsmod = VtsSolvers.ROfRhoAndFt(op_fin, 23, freqset);
%     mod_amp = abs(vtsmod)/(abs(vtsmod(1)));
%     mod_phi_raw = unwrap(-angle(vtsmod)*180/pi);
%     mod_phi = mod_phi_raw-mod_phi_raw(1);
%     muaPredict = mu(1);
%     musPredict = mu(2);
%     ampPredict = mod_amp;
%     phasePredict = mod_phi;
%     testData = [testData ampPredict dataAmp phasePredict dataPhi];
%     testProps = [ testProps; wavelength fitFreqRange(1) fitFreqRange(2) muaPredict musPredict];
% end