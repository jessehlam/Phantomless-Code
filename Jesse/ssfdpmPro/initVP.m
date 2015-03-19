if(strcmp(fdpm.cal.model_to_fit,'vpSDA') || strcmp(fdpm.cal.model_to_fit,'vpMCBasic') || strcmp(fdpm.cal.model_to_fit,'vpMCNurbs') || strcmp(fdpm.model_to_fit,'vpSDA') || strcmp(fdpm.model_to_fit,'vpMCBasic') || strcmp(fdpm.model_to_fit,'vpMCNurbs')) 
    pp = which('dosi_startup');
    ppp = fileparts(pp);
    cd(ppp);
    dosi_startup;
    %loadAssemblies();     
end