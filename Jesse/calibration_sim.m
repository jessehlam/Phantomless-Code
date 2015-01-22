%% Generating VTS Simulated Data
cd(vtsdir);
startup();

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
mod_amp = abs(vtsmod); %Recovering amplitude
curramp = mod_amp./mod_amp(1); %Normalizing the VTS model
mod_phi = -angle(vtsmod); %Recovering the phase
currphi = mod_phi*180/pi; %Convert from radians to degrees
currphi = currphi-currphi(1); %Normalizing the phase