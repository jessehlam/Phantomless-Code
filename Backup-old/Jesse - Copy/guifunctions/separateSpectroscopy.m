function [ norm, sub_black, black_norm ] = separateSpectroscopy( base )

norm = {};  sub_black = {}; black_norm = {};
idx1 = 1;   idx2 = 1;   idx3 = 1;
for i = 1:length( base )
    temp = base{i};
    if( contains( 'sph', temp ) && ( contains( 'dark', temp ) || contains( 'black', temp ) ) )
        black_norm( idx3 ) = base(i);
        idx3 = idx3 + 1;        
    end
    if( ( contains( 'dark', temp ) || contains( 'black', temp ) ) && contains( 'tis', temp ) )
        sub_black( idx2 ) = base(i);
        idx2 = idx2 + 1;
    end
    if( ( contains( 'white', temp ) || contains( 'sph', temp ) ) && ~contains( 'dark', temp ) )
        norm( idx1 ) = base(i);
        idx1 = idx1 + 1;
    end
end

