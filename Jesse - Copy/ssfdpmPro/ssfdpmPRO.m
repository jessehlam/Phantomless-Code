function error = ssfdpmPRO(fdpm,spec,physio, bw, pro)
%SSFDPMPRO Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initial check to see if variables are valid before running anything?
%
%need to preallocate variables
%loop over files but only run cals once and setups once
error=0;
initFilenames %Reconstructs file names and prepares/creates directories
initVariables %Reads dosiguiscript settings and checks for errors 
initVP %Initializes the virtual photonics MATLAB addon
if error==1; return; end
for j=1:nFiles
    if pro.verbose
        disp(sprintf('PROCESSING %s',pro.prefixes{:,j}));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% FDPM FIT
    if ((j==1)||(fdpm.cal.which==3))
       fdpmcal = getFDPMCal(fdpm.cal, fdpm.diodes, fdpm.stderr, fdpm.boundary_option,char(fdpm.files(:,j)),fdpm.glass);
       %Derives out the system response from the phantom:
           %Looks up phantom file and its "known" optical properties
           %Runs the model for the phantom amplitude/phase
           %Calibrates the phantom measurement using the phantom amp/phase to
                %get the system response
           %In the phantomless calibrator, the signal from the calibrator
                %is assumed to be the system response. As such, we only
                %then need to correct the phase shift using the photon pathlength through air
                %and glass materials in the system.
        
       if fdpmcal.error~=0, error=1; return; end
    end 
    
    fdpm.opt.itr=j;
    final(j) = initFDPM(fdpm, fdpmcal,char(fdpm.files(:,j)),j); % opens fdpm files, does calibration, windows to frequency range and filters phase jumps
    %Derives the tissue optical properties using the system response:
        %Reads the tissue measurement file
        %Calibrates the tissue response using the system reponse (derived
            %from the phantom)
        %Fixes the frequency range to the one the user specified
    
    fdpmfit(j) = fitFDPM(fdpm.diodes, final(j).freq, final(j).AC, final(j).damp, final(j).phase, final(j).dphi, fdpm.model_to_fit, fdpm.opt, pro.verbose, fdpm.n, final(j).dist, fdpm.boundary_option);
    %Normalizes the calibrated data, finds the best fitting model by
        %chi-squared minimization, and fits the scattering curve using the
        %power law
    
    plotMu(final(j), fdpmfit(j), fdpm.diodes,pro.prefixes{j},1,pro);
    %Plots the calibrated data and best fitting amplitude/phase
    plotSS(spec.wvrange, fdpmfit(j), ssfdpmfit, fdpm.diodes, pro.prefixes{j}, 2, spec.usediodes, pro);  %need to modify this function slightly since added argument
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% SPEC FIT
    if spec.on
        if j==1
            speccal = getSpecCal(char(spec.cal.sphere),char(spec.cal.dark),spec.opt);
            if speccal.error~=0, error=1; return; end
        end

        [r,diodR,spec.dist, fdpmsserr, error] = getReflectance(char(spec.files(:,j)),char(spec.dark),speccal,spec.opt,spec.wvrange,fdpm.diodes,fdpmfit(j).mua,fdpmfit(j).mus,spec.opt.rfixed,fdpm.n,fdpmfit(j).chi,spec.usediodes, fdpm.boundary_option); 
        if error~=0, error=1; return; end
        ssfdpmfit(j) = fitSSFDPM(fdpmfit(j),fdpm.diodes,spec.usediodes,spec.wvrange,fdpm.opt,spec.opt,pro.verbose,r,diodR,spec.dist,fdpm.n,spec.mua_guess,fdpmsserr, fdpm.boundary_option);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Physio Fit
    if physio.fdpm.fit
        if length(fdpm.diodes)>=sum(physio.chrom.selected)
            if j==1
                fdpmchrom = physioSetup(physio, fdpm.diodes);
            end
            [fdpmfit(j).phy, fdpmfit(j).fitmua, fdpmfit(j).ss] = physioFit(physio.fittype, fdpmchrom, fdpmfit(j).mua, fdpmfit(j).dmua, pro.verbose);
        else
            fdpmchrom=0;
            if pro.verbose
                disp('FDPM physio fit not run, not enough diodes');
            end
        end
    end
    if spec.on && physio.spec.fit
        if j==1
            ssfdpmchrom = physioSetup(physio, spec.wvrange,spec.opt.baseline);
        end
        [ssfdpmfit(j).phy, ssfdpmfit(j).fitmua, ssfdpmfit(j).ss] = physioFit(physio.fittype, ssfdpmchrom, ssfdpmfit(j).muaSPEC, ones(size(ssfdpmfit(j).muaSPEC)), pro.verbose);
%         if pro.graphing==1
%             plotSS(spec.wvrange, fdpmfit(j), ssfdpmfit(j), fdpm.diodes, pro.prefixes{j}, 2, spec.usediodes, pro);  %need to modify this function slightly since added argument
%         end
    end
    %% Bound Water Fit
    if bw.fit && spec.on
        if j==1
            [bwlib, waterlib, wlibcols,libwlength]=boundWaterInit(bw.specDir,bw.conc_en);
        end
        bwfit(j) = boundWaterFit(spec.wvrange,ssfdpmfit(j).muaSPEC',bw.ubc,bw.lbc,bwlib,bw.temp,waterlib,wlibcols,libwlength,bw.conc_guess,bw.bw_guess,bw.peak_guess,bw.refwl,pro.outLabel);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Write to File
if pro.fileWrite
    dat = summarize(spec,final,nFiles,fdpmfit,ssfdpmfit,fdpmchrom,ssfdpmchrom,physio,bw,bwfit);
    writeSummaryFiles(fdpm,spec,bw,pro,physio, dat, nFiles, final);
    if spec.on && (sum(spec.usediodes)==length(fdpm.diodes))
        writeFitReport(fdpm,dat,nFiles,ssfdpmfit, pro);
    end
    if pro.repnum > 0
        avedat = averageData(fdpm,spec,bw,dat,pro,physio);
        writeSummaryFiles(fdpm,spec,bw,pro,physio,avedat,avedat.nMatches);
    end
end
if pro.verbose
    disp('PROCESSING COMPLETE');
end
error = 0;
