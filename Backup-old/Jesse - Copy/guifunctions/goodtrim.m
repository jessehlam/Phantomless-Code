function ret = goodtrim( str )

head = 1;
if isspace( str( head ) )
    while( isspace( str( head ) ) )
        head = head + 1;
    end
end

tail = length( str );
if isspace( str( length( str ) ) )
    while( isspace( str( tail ) ) )
        tail = tail - 1;
    end
end
ret = str(head:tail);