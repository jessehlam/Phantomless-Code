function ret = getSubdirectories( directory )
ret = {};
cd_cur = cd;
cd( directory );

temp = dir;
idx = 1;
for i = 1:length( temp )
    if( temp(i).isdir & ~( isequal( temp(i).name, '.' ) | isequal( temp(i).name, '..' ) ) )
        ret{ idx } = temp(i).name;
        idx = idx + 1;
    end
end
        
      