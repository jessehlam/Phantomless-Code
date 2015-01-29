errsolve_amp2phi

% Run the model to get the final amplitude and phase as well as model prediction
op_fin = [mu 0.8 n]; %Phantom properties
VtsSolvers.SetSolverType('PointSourceSDA'); %VTS to get model
vtsmod_fin = VtsSolvers.ROfRhoAndFt(op_fin, rho, ft); %Solver type
mod_amp_fin = abs(vtsmod_fin); %Recovering amplitude
curramp_fin = mod_amp_fin./mod_amp_fin(1); %Normalizing the VTS model
mod_phi_fin = -angle(vtsmod_fin); %Recovering the phase
currphi_fin = mod_phi_fin*180/pi; %Convert from radians to degrees
currphi_fin = currphi_fin-currphi_fin(frqnum2); %Normalizing the phase

%% User reports
disp(strcat('Top Guesses [MUa MUs]:',num2str(muguess)))
disp(strcat('Best Fitting [MUa MUs]:',num2str(mu))) %Displaying recovered optical properties

if highfrqdata == 1
    ftf=[ft .6];
    curramp_fin=[curramp_fin; currampf_itr];
    curramp=[curramp; modfavg.amp];
    figure
    subplot(2,1,1) %Plotting the "tissue" and optimized amplitude
    plot(ftf(frqnum2:frqnum+1),curramp(frqnum2:frqnum+1),'b*');
    hold on;
    plot(ftf,curramp_fin,'r*');
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
    
else
    
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
    
end