function ret = determine_old_system( dir_path )

%%determines which filing system is in use with the files in the passed directory.
%% 0 means this directory contains the consolidated data.
%% 1 means this directory contains old data.

cur_dir = cd;
cd \;
cd( dir_path );
temp = dir( '*.asc' );
arr1 = { temp.name };
arr2 = {};
for i = 1:length( arr1 )
    str = arr1{ i };
    x = length( str );
    arr2(i) = { str( x-6 : x-4 ) };
    % so now all entries are (possibly) the 3-digit diode name (if this is the old system)
end

arr2 = unique( arr2 );
index = 1;
found_diode = 0;
while( index <= length( arr2 ) & ~found_diode )
    if( ~isempty( str2double( arr2{index} ) ) )
        ret = 1;    %yes, this is using the old data
        return;     %do not need to continue with the test.
    else
        index = index + 1;   %proceed to the next entry.
    end
end

ret = 0;