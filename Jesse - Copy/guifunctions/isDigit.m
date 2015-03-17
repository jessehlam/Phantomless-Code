function ret = isDigit( chr )
%% Determines if the input character is a digit or not
%% Values from 0 - 9 return TRUE, all eles return false.


if ~ischar( chr )
    ret = 0;
    return;
elseif isnumeric( chr )
    ret = 1;
    return;
end

ret = chr >= 48 & chr <= 57 ; %% Character.isDigit( str(i) )