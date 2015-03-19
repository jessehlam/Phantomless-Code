function ret = contains( pattern, str )
ret = ~isempty( findstr( pattern, str ) );