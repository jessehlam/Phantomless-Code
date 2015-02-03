% clear
% clc
% cd('C:\Users\Kyle\Documents\GitHub\Phantomless-Code\Kyle');
% k  = dir('PH010_830_Test\*.mat');
% filesnames = {k.name}';
% cd PH010_830_Test
% testData = [];
% testProps = [];
% for i = 1:length(filesnames)
%     load(filesnames{i})
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
%     testData = [testData ampPredict dataAmp phasePredict dataPhi];
%     testProps = [ testProps; fitFreqRange(1) fitFreqRange(2) muaPredict musPredict];
% end

% %% Plot Results
% figure(1);
% subplot(2,1,1)
% hold on
% plot(freqset,dataAmp);
% for i=1:length(filesnames)
%     plot(freqset,testData(:,1));


cd('C:\Users\Kyle\Documents\GitHub\Phantomless-Code\Kyle');
k  = dir('FreqRangeTest\*.mat');
filesnames = {k.name}';
cd FreqRangeTest
testData = [];
testProps = [];
for i = 1:length(filesnames)
    load(filesnames{i})
    mu = [muaPredict musPredict];
    op_fin = [mu .8 1.43];
    VtsSolvers.SetSolverType('PointSourceSDA');
    vtsmod = VtsSolvers.ROfRhoAndFt(op_fin, 23, freqset);
    mod_amp = abs(vtsmod)/(abs(vtsmod(1)));
    mod_phi_raw = unwrap(-angle(vtsmod)*180/pi);
    mod_phi = mod_phi_raw-mod_phi_raw(1);
    muaPredict = mu(1);
    musPredict = mu(2);
    ampPredict = mod_amp;
    phasePredict = mod_phi;
    testData = [testData ampPredict dataAmp phasePredict dataPhi];
    testProps = [ testProps; wavelength fitFreqRange(1) fitFreqRange(2) muaPredict musPredict];
end