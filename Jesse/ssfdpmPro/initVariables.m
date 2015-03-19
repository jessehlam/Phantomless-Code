clear ssfdpmfit
clear fdpmchrom
clear ssfdpmchrom

if ~spec.on
    ssfdpmfit=0;
end
if ~physio.fdpm.fit
    fdpmchrom=0;
end
if ~physio.spec.fit || ~spec.on
    ssfdpmchrom=0;
end
if ~spec.on || ~bw.fit
    bwfit=0;
end

%do check for variables before proceeding
fdpmarray={'cal','source','diodes','n','model_to_fit','stderr','freqrange','opt','boundary_option'};
if find(isfield(fdpm,fdpmarray)==0)
    error=1;
    display(['Error: Field not found. Please set fdpm.' fdpmarray{find(isfield(fdpm,fdpmarray)==0)}]);
    return
end
fdpm.ndiodes = length(fdpm.diodes);
nFiles = length(fdpm.files);

fdpmcalarray={'which','phantoms','n','model_to_fit','rfixed','phantomdir'};
if find(isfield(fdpm.cal,fdpmcalarray)==0)
    error=1;
    display(['Error: Field not found. Please set fdpm.cal.' fdpmcalarray{find(isfield(fdpm.cal,fdpmcalarray)==0)}]);
    return
end
fdpmoptarray={'rfixed','param','mus_robust','imagfit','err','jumps','chisqok'};
if find(isfield(fdpm.opt,fdpmoptarray)==0)
    error=1;
    display(['Error: Field not found. Please set fdpm.opt.' fdpmoptarray{find(isfield(fdpmopt,fdpmoptarray)==0)}]);
    return
end
physioarray={'fdpm','spec','chrom','fittype'};
if find(isfield(physio,physioarray)==0)
    error=1;
    display(['Error: Field not found. Please set physio.' physioarray{find(isfield(physio,physioarray)==0)}]);
    return
end
physiofdpmarray={'fit'};
if find(isfield(physio.fdpm,physiofdpmarray)==0)
    error=1;
    display(['Error: Field not found. Please set physio.fdpm.' physiofdpmarray{find(isfield(physio.fdpm,physiofdpmarray)==0)}]);
    return
end
physiospecarray={'fit','baseline'};
if find(isfield(physio.spec,physiospecarray)==0)
    error=1;
    display(['Error: Field not found. Please set physio.spec.' physiospecarray{find(isfield(physio.spec,physiospecarray)==0)}]);
    return
end
physiochromarray={'file','names','units','mult','mins','maxs','selected'};
if find(isfield(physio.chrom,physiochromarray)==0)
    error=1;
    display(['Error: Field not found. Please set physio.chrom.' physiochromarray{find(isfield(physio.chrom, physiochromarray)==0)}]);
    return
end
specarray={'on','source','suffix','usediodes','cal','dark','opt','wvrange','mua_guess'};
if find(isfield(spec,specarray)==0)
    error=1;
    display(['Error: Field not found. Please set spec.' specarray{find(isfield(spec,specarray)==0)}]);
    return
end
speccalarray={'sphere','dark'};
if find(isfield(spec.cal,speccalarray)==0)
    error=1;
    display(['Error: Field not found. Please set spec.cal.' speccalarray{find(isfield(spec.cal, speccalarray)==0)}]);
    return
end
specoptarray={'rfixed','spike','spikewindow','boxcar','lambdashift','docal','baseline','mua_robust'};
if find(isfield(spec.opt,specoptarray)==0)
    error=1;
    display(['Error: Field not found. Please set spec.opt.' specoptarray{find(isfield(spec.opt,specoptarray)==0)}]);
    return
end
proarray={'files','repnum','rootdir','patientID','date','outLabel','verbose','graphing','fileWrite'};
if find(isfield(pro,proarray)==0)
    error=1;
    display(['Error: Field not found. Please set p.' proarray{find(isfield(pro,proarray)==0)}]);
    return
end




error=0;
