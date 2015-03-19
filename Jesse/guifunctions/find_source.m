function ret = find_source( source_list_path, array )
%Looks through fname to determine which source was used 
%in the measurement taking.
%-find_source( source_path, array )
%-source_path := path of source.txt
%-array := array of names to traverse

found_source = 0;
%index = 0;
%while( ~found_source )
idx = 1;
fid = fopen( source_list_path );
% tmp = rline( fid );
len = length( array );
while( (idx <= len) && ~found_source )
    index = 1;
    tmp = rline( fid );
    while( length( tmp ) > 0 && ~found_source && index <= len )
        if ~isempty( findstr( array{ index }, goodtrim( tmp ) ) )
            ret = goodtrim( tmp );
            found_source = 1;
        else
            index = index + 1;
        end
    end
    idx = idx + 1;% try the next file if this file does not have the source information.
end
fclose( fid );
%end
