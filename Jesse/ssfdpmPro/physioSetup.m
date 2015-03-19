function chrom = physioSetup(physio, diodes, baseline)
%%%byh Loads chromophore extinction coefficientsa and sets up variables for file writing.  

if nargin<3
    baseline = 0;
end

nChrom = sum(physio.chrom.selected);
%%%byh Loads specified chromophore file.  
chromophoresTemp = load(physio.chrom.file);
used_chrom = find(physio.chrom.selected);
chromophores = chromophoresTemp(:,used_chrom+1);

[chrom.names, chrom.units, chrom.mult, chrom.mins, chrom.maxs] = deal(physio.chrom.names(used_chrom), ...
        physio.chrom.units(used_chrom), physio.chrom.mult(used_chrom), physio.chrom.mins(used_chrom), physio.chrom.maxs(used_chrom));

chrom.hbO2_i = find(strcmp('HbO2',chrom.names)>0);  %chrom.sat holds the indexes of Hb and HbO2
chrom.hb_i = find(strcmp('Hb',chrom.names)>0);
chrom.h2o_i = find(strcmp('h2oFrac',chrom.names)>0);
chrom.fat_i = find(strcmp('fatFrac',chrom.names)>0);

if  (~isempty(chrom.hbO2_i) &&  ~isempty(chrom.hb_i)), chrom.saton = 1; else chrom.saton = 0; end
if (~isempty(chrom.hb_i) && ~isempty(chrom.h2o_i) && ~isempty(chrom.fat_i)), chrom.toion = 1; else chrom.toion = 0; end

chrom.E = zeros(length(diodes),nChrom);
%%%byh Interpolates extinction coefficents to either the fdpm or broadband
%%%diode wavelengths
for j=1:nChrom
    chrom.E(:,j)=  interp1(chromophoresTemp(:,1),chromophores(:,j), diodes, 'cubic');
end

if baseline
    chrom.E=[chrom.E ones(size(chrom.E(:,1)))];
    chrom.names = {chrom.names{:} 'Baseline'};
    chrom.units = {chrom.units{:} ' '};
    chrom.mult = [chrom.mult; 1];
end

if  chrom.saton,
    chrom.names = {chrom.names{:} 'THC' 'O2Sat'};
    chrom.units = {chrom.units{:} chrom.units{chrom.hb_i} '%'};
end
if chrom.toion
    chrom.names = {chrom.names{:} 'TOI'};
    chrom.units = {chrom.units{:} '-'};
end