%% Iteratively Checking MUa & MUs
warning('off'); %Keep off unless you want a lot of orange warning text
%cd('C:\Users\Jesse\Dropbox\Phantomless\phantomless_cal4\VTS'); %Directory of VTS
cd(vtsdir); %Directory of VTS
startup();

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
        
        if highfrqdata ==1         
            erramp_highf = abs(curramp2(402)-curramp_itr(402))./curramp2(402);
            errphi_highf = abs(currphi2(402)-currphi_itr(402))./currphi2(402);
            errtest = erramp+erramp;

        else
            errtest=erramp+errphi;
        end
            
        
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