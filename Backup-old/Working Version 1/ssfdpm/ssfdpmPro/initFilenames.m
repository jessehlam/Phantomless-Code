%Create paths (using full paths for files)
for i=1:length(fdpm.cal.phantoms)
    fdpm.cal.phantoms_short{i}=fdpm.cal.phantoms{i};
    fdpm.cal.phantoms{i} = strcat(pro.rootdir,'\',pro.patientID,'\',pro.date,'\',fdpm.cal.phantoms{i},'-',fdpm.source,'.asc');
end
if isempty(spec.cal.dark)
    spec.cal.dark = strcat(pro.rootdir,'\',pro.patientID,'\',pro.date,'\',spec.cal.sphere,'-dark','.asc');
end
for i=1:length(spec.cal.sphere) %don't need to loop, should only be one right now
    spec.cal.sphere{i} = strcat(pro.rootdir,'\',pro.patientID,'\',pro.date,'\',spec.cal.sphere{i},'.asc');
end

for i=1:length(pro.files)
    if pro.repnum>0
        for j=1:pro.repnum
            fdpm.files{pro.repnum*i+j-pro.repnum} = strcat(pro.rootdir,'\',pro.patientID,'\',pro.date,'\',pro.files{i},'-',num2str(j),'-',fdpm.source,'.asc');
            spec.files{pro.repnum*i+j-pro.repnum} = strcat(pro.rootdir,'\',pro.patientID,'\',pro.date,'\',pro.files{i},'-',num2str(j),'-',spec.source,'.asc');
            pro.prefixes{pro.repnum*i+j-pro.repnum} = strcat(pro.files{i},'-',num2str(j));
        end
    else 
        fdpm.files{i} = strcat(pro.rootdir,'\',pro.patientID,'\',pro.date,'\',pro.files{i},'-',fdpm.source,'.asc');
        spec.files{i} = strcat(pro.rootdir,'\',pro.patientID,'\',pro.date,'\',pro.files{i},'-',spec.source,'.asc');
        pro.prefixes{i} = pro.files{i};
    end
end
outdir = ['PROCESSED\' pro.patientID '_' pro.date '\' ];
pro.processed_dir = [pro.rootdir '\' outdir];
try
    cd(pro.processed_dir);
catch 
    mkdir(pro.processed_dir);
end
pro.fitbase = sprintf('%s%s_',pro.processed_dir,pro.outLabel);
if pro.savefitgraphs==1;
    fitgraph_dir=[pro.processed_dir '\recon graphs'];
    try
        cd(fitgraph_dir);
    catch
        mkdir(fitgraph_dir);
    end
end
