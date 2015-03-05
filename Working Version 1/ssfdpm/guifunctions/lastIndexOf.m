function buf = lastIndexOf( pat, str )
%% lastIndexOf( pat, str )
%% finds the last instance of PAT in STR( if any )

pat = char( pat );
str = char( str );

if isempty( pat ) | isempty( str )
    buf = [];
    return;
end

arr = findstr( pat, str );
if isempty( arr )
    buf = [];
    return;
else 
    buf = arr( length( arr ) );
end
