function dat = getDiodes( dir_name, source )
%% Determines which diodes were used in the measurement taking
%% getDiodes( dir_name, sample );
%% dir_name := directory path for the sample
%% sample   := sample file name

%OPEN FILES========================================================
fw = [];
cur_dir = cd;
cd( dir_name );

temp = dir( [ '*' source '*.asc' ] );

files = { temp.name };
dat = [];   idx = 1;

for idx = 1:length( files )
    %disp( files(idx) );
    found = 0;
    fid = fopen( files{idx} );
    
    if fid==-1 ,
        disp([sprintf('Could not open file %s.', fname)]);
        return;
    end;
    
    %SCAN FILE========================================================
    l = '';    
    found_diodes = 0;
    found_end_of_header = 0;
    %header information
    while ~found_diodes && ~found_end_of_header;		% skip all lines until data starts
        l = rline(fid); 			% read one line into array l
        [fw rl] = strtok(l);   		% take first word of line    
        if strcmp( fw, 'Laser' )
            %             disp( 'FOUND LASER' );
            found_diodes = 1;
        end
        if contains( 'end of header', l )
            %             disp( 'FOUND END OF HEADER' );
            found_end_of_header = 1;
        end            
    end
    
    %dat = str2num( rl( findstr( rl, ':' ) + 1:findstr( rl, '*' ) - 1 ) );
    diodes = str2num( rl( findstr( rl, ':' ) + 1:findstr( rl, '*' ) - 1 ) );
    %dat = addElement( dat, diodes );       %%use this if you want to generate a list of diodes that  covers all the diodes used in all the measurements of this data-set.
    %thes 5 lines give you the intersection of all the diodes that were used for that data set.
    if isempty( dat )
        dat = diodes;
    else
        dat = intersect( dat, diodes );
    end
    
    fclose( fid );
end

dat = sort( dat );
% dat = unique(dat);
cd \;
cd( cur_dir );