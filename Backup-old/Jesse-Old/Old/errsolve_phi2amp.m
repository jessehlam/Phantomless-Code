warning('off'); %Keep off unless you want a lot of orange warning text
cd(vtsdir); %Directory of VTS
startup();
itr=0; %Counter for iteration number
errmatphi=100000*ones(1,10); %Default error value. Make it ridiculously large.
errmat=100000; %Default error value for the phase. Make it ridiculously large.
mu=[0 0]; %Preparing empty matrix to hold optical properties
muguess=zeros(10,2); %Preparing empty matrix to hold top 10 mua
besttot=10; %How many mua/mus pairs to save?
best=0; %Initializing the counter to save the 10 best mua/mus pair
totalitr=length(mua)*length(mus); %Total number of iterations (for the progress bar)
waitb = waitbar(0,strcat('0/',num2str(totalitr))); %Opening progress bar

for i=1:length(mua)
        
    for j=1:length(mus)
        phanop_itr=[mua(i) mus(j)]; %Sweep through MUa and MUs values
        op_itr = [phanop_itr 0.8 n]; %Phantom properties
        VtsSolvers.SetSolverType('PointSourceSDA'); %VTS to get model
        vtsmod_itr = VtsSolvers.ROfRhoAndFt(op_itr, rho, ft); %Solver type  
        mod_phi_itr = -angle(vtsmod_itr); %Recovering the phase
        currphi_itr = mod_phi_itr*180/pi; %Convert from radians to degrees
        wrapper=sign(currphi_itr);

        for p=1:length(wrapper);
            wraptest=wrapper(p);
            if wraptest==-1
                currphi_itr(p)=currphi_itr(p)+360;
            end
        end

        currphi_itr = currphi_itr-currphi_itr(frqnum2); %Normalizing the phase
        errphitest=sum(abs((currphi(frqnum2:frqnum)-currphi_itr(frqnum2:frqnum)))./currphi(frqnum2:frqnum)); %Phase error
        errtest=errphitest;    
        
%Saving top 10 optical properties
        if best < besttot %Looping from 1 to 10
            best=best+1; %If less than 10, adds 1 to current value
        else
            best=1; %If 10, then loops back to 1
        end
        
        if best == 1 %Saving the top 10 mua/mus pairs
            
            if errtest<errmatphi(besttot)
                errmatphi(best)=errtest; %Saving the minimum error
                muguess(best,:)=phanop_itr;
            end
            
        else
            
            if errtest<errmatphi(best-1)
                errmatphi(best)=errtest; %Saving the minimum error
                muguess(best,:)=phanop_itr;
            end
            
        end
        
        itr=itr+1; %Counter for iteration
        progress=itr/totalitr; %Updating progress so user doesn't think MATLAB froze
        progtxt=strcat(num2str(itr),'/',num2str(totalitr));
        waitbar(progress,waitb,sprintf(progtxt));
    end
    
end

for j = 1:length(muguess) %Now that we have our top 10 amplitude fits
    bestop=[muguess(j,:) 0.8 n]; %Of these, find the best phase fit
    vtsmod_itr = VtsSolvers.ROfRhoAndFt(bestop, rho, ft); %Solver type   
    mod_amp_itr = abs(vtsmod_itr); %Recovering amplitude
    curramp_itr = mod_amp_itr./mod_amp_itr(1); %Normalizing the VTS model
%     mod_phi_itr = -angle(vtsmod_itr); %Recovering the phase
%     currphi_itr = mod_phi_itr*180/pi; %Convert from radians to degrees
%     wrapper=sign(currphi_itr);
%     
%     for p=1:length(wrapper);
%         wraptest=wrapper(p);
%         if wraptest==-1
%             currphi_itr(p)=currphi_itr(p)+360;
%         end
%     end
%     
%     currphi_itr = currphi_itr-currphi_itr(frqnum2); %Normalizing the phase
%     errphitest=sum(abs((currphi(frqnum2:frqnum)-currphi_itr(frqnum2:frqnum)))./currphi(frqnum2:frqnum)); %Phase error
    erramp=sum(abs((curramp(frqnum2:frqnum)-curramp_itr(frqnum2:frqnum)))./curramp(frqnum2:frqnum)); %Amplitude error
    errtest=erramp;   
    
    if errtest<errmat
        errmat=errtest; %Saving the minimum error
        mu=muguess(j,:);
    end
    
    progress=itr/totalitr; %Updating progress so user doesn't think MATLAB froze
    progtxt=strcat(num2str(itr),'/',num2str(totalitr));
    waitbar(progress,waitb,sprintf(progtxt));
end

waitbar(progress,waitb,'Finalizing...');