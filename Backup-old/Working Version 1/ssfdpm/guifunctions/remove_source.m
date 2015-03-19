function buf = remove_source( list, source )
if length( list ) == 0
    buf = list;
    return;
end

% tis = '-tis';
zzz = 'zzzzzz';
len = length( list );
for i = 1:len
    str = list{i};
    if ~isempty( findstr( str, source ) )
        str = str( 1:lastIndexOf( source, str ) - 2 );
    end
    if( ~isAlphaNumeric( str( length(str) ) ) )
        str = str(1: length(str) - 1 );
    end
    list{i} = str;
end
list = unique( list );

if isequal( list{ length(list) }, zzz )
    list = list( 1:len - 1 );
end
buf = list;