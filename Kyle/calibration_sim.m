%% Generating VTS Simulated Data
cd C:\Users\Kyle\Documents\GitHub\Phantomless-Code\VTS
startup

testdefault={'.01','1'};
testdiag={'MUa (1/mm)',... %Text in the dialog
    'MUs (1/mm)'};
testboxdisp=''; %Dialog title
lines=1; %Number of lines per input box
output=inputdlg(testdiag,testboxdisp,lines,testdefault); %Output variable

testmua=str2double(output{1}); %Input mua
testmus=str2double(output{2}); %Input mus

phanop=[testmua testmus]; %Optical properties for generating test data in [mua mus]
op = [phanop 0.8 n]; %Optical properties. vts assumed g=0.8 by default
VtsSolvers.SetSolverType('PointSourceSDA'); %VTS to get model
vtsmod = VtsSolvers.ROfRhoAndFt(op, rho, ft); %Solver type

% Noise Options
% Base noise
% vtsmod = awgn(vtsmod,137); % Add noise at SNR of ~140 (reasonable may be changed)

% Options for adding complex noise
% vtsmod = vtsmod+sin(45*(ft'+.3)).*abs(randn(length(vtsmod),1))*2.5e-7;
% vtsmod = vtsmod+sin(100*(ft'+rand))*2.5e-7%+(randn(length(vtsmod),1))*1e-7;

vtsfit = polyfit(ft',abs(vtsmod),3); %Option to change order of poly fit
vtspoly = polyval(vtsfit,ft');
vts_curramp = abs(vtsmod)/vtspoly(1);

% Amplitude Noise
% Added sin wave with amplitude related to Freq, random phase shift
% curramp = vts_curramp+(sin(100*ft'+2*pi*rand).*((rand/8+ft')*.1));

mod_phi = -angle(vtsmod); %Recovering the phase
currphi = mod_phi*180/pi; %Convert from radians to degrees
currphi = currphi-currphi(1); %Normalizing the phase

% % Plot signal
% subplot(2,1,1)
% scatter(ft,curramp)
% subplot(2,1,2)
% scatter(ft,currphi)

% mod_amp = abs(vtsmod); %Recovering amplitude
% curramp = mod_amp./mod_amp(1); %Normalizing the VTS model
% mod_phi = -angle(vtsmod); %Recovering the phase
% currphi = mod_phi*180/pi; %Convert from radians to degrees
% currphi = currphi-currphi(1); %Normalizing the phase

cd(pth)
