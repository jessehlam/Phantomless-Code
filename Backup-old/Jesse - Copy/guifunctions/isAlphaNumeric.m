function ret = isalphanumeric( c )

if ( c >= 48 & c <= 57 ) | ( c >= 65 & c <= 90 ) | ( c >= 97 & c <= 122 )
    ret = 1;
else
    ret = 0;
end