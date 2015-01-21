%Triple commented lines are used for generating test data
%ACRIN7 @690	0.016521307	0.826354605
%INO5 @690	0.008723295	0.793225574
%INO5 @778  0.009314095	0.801617501

warning('off'); %Keep off unless you want a lot of orange warning text
cd('C:\Users\Jesse\Dropbox\Phantomless\phantomless_cal4\VTS'); %Directory of VTS
startup();

%% Iteratively Checking MUa & MUs
itr=0; %Counter for iteration number
errmat=100000; %Default error value. Make it ridiculously large.
mu=[0 0]; %Preparing empty matrix to hold optical properties
totalitr=length(mua)*length(mus); %Total number of iterations (for the progress bar)
h = waitbar(0,strcat('0/',num2str(totalitr))); %Opening progress bar

for i=1:length(mua)
        
    for j=1:length(mus)
        itr=itr+1; %Counter for iteration #
        phanop_itr=[mua(i) mus(j)]; %Sweep through MUa and MUs values
        op_itr = [phanop_itr 0.8 n]; %Phantom properties
        VtsSolvers.SetSolverType('PointSourceSDA'); %VTS to get model
        vtsmod_itr = VtsSolvers.ROfRhoAndFt(op_itr, rho, ft); %Solver type
        mod_amp_itr = abs(vtsmod_itr); %Recovering amplitude
        curramp_itr = mod_amp_itr./mod_amp_itr(1); %Normalizing the VTS model
        mod_phi_itr = -angle(vtsmod_itr); %Recovering the phase
        currphi_itr = mod_phi_itr*180/pi; %Convert from radians to degrees
        currphi_itr = currphi_itr-currphi_itr(1); %Normalizing the phase
        
        erramp=sum(abs((curramp(frqnum2:frqnum)-curramp_itr(frqnum2:frqnum)))./curramp(frqnum2:frqnum)); %Amplitude error
        errphi=sum(abs((currphi(frqnum2+1:frqnum)-currphi_itr(frqnum2+1:frqnum)))./currphi(frqnum2+1:frqnum)); %Phase error
        errtest=erramp+errphi;
        
        if errtest<errmat
            errmat=errtest; %Saving the minimum error
            mu=phanop_itr;
        else
            errmat=errmat; %Else, keep it the same.
            mu=mu;
        end
        
        progress=itr/totalitr; %Updating progress so user doesn't think MATLAB froze
        progtxt=strcat(num2str(itr),'/',num2str(totalitr));
        waitbar(progress,h,sprintf(progtxt));
    end
    
end

close(h) %Closing progress bar

%% Run the model one last time to get the final amplitude and phase as well as model prediction
op_fin = [mu 0.8 n]; %Phantom properties
VtsSolvers.SetSolverType('PointSourceSDA'); %VTS to get model
vtsmod_fin = VtsSolvers.ROfRhoAndFt(op_fin, rho, ft); %Solver type
mod_amp_fin = abs(vtsmod_fin); %Recovering amplitude
curramp_fin = mod_amp_fin./mod_amp_fin(1); %Normalizing the VTS model
mod_phi_fin = -angle(vtsmod_fin); %Recovering the phase
currphi_fin = mod_phi_fin*180/pi; %Convert from radians to degrees
currphi_fin = currphi_fin-currphi_fin(1); %Normalizing the phase

%% User reports (move this section to plotter.m?)

disp(strcat('Recovered [MUa MUs]:',num2str(mu))) %Displaying recovered optical properties
% disp(strcat('Recovered MUs:',num2str(recoveredmus)))

figure
subplot(2,1,1) %Plotting the "tissue" and optimized amplitude
plot(ft(frqnum2:frqnum),curramp(frqnum2:frqnum),'b*','linewidth',2);
hold on;
plot(ft(frqnum2:frqnum),curramp_fin(frqnum2:frqnum),'r*');
ylabel('Normalized Amplitude');
legend('Data','Recovered','Location','Best');
hold off

subplot(2,1,2) %Plotting the "tissue" and optimized phase
plot(ft(frqnum2:frqnum),currphi(frqnum2:frqnum),'b*','linewidth',2); 
hold on;
plot(ft(frqnum2:frqnum),currphi_fin(frqnum2:frqnum),'r*');
xlabel('Frequency (GHz)');
ylabel('Phase (Degrees)');
legend('Data','Recovered','Location','Best');
hold off