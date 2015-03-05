function buf = validate_list( list, directory )
max = -9999;
buf = {};

cur_dir = cd;
cd( directory );

temp = dir( '*.asc' );
temp = { temp.name };

% for i = 1:length( list )
%     tmp1 = dir( [ list{i}, '*.asc' ] );
%     max = maximum( max, length( tmp1 ) );    
% end
% 
% for i = 1:length( list )
%     tmp2 = dir( [ list{i}, '*.asc' ] );
%     if length( tmp2 ) == max
%         buf{i} = list{i};
%     else
%         buf{i} = ''
%     end
% end

for i = 1:length( list )
    tmp = dir( [ list{i} '*.asc' ] );
    if length( tmp ) > max
        buf = {};
        max = length( tmp );
    end
    buf{ length( buf ) + 1 } = list{i};
end

buf = unique( buf );
if isempty(buf) || isempty( buf{1} )
    buf = buf( 2:length( buf ) );
end

return;

    

function ret  = maximum( int1, int2 )
if( int1 > int2 )
    ret = int1;
    return;
end
ret = int2;
return;
