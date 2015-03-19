function [ mlist, plist, slist,blist,alist ] = separate_base_list_filter( array )

mlist = {}; plist = {}; slist = {};blist={};alist={};
phantom = 'ph0';    sph = 'sph';    tis = 'tis';
pidx = 1;       sidx = 1;       midx = 1;
bidx=1;
aidx=1;

for i = 1:length( array );
    found = 0;
    tmp = char( array(i) );
    tmp2 = lower( tmp );
    if ~isempty( findstr( tmp2, sph ) ) 
        found = 1;
        slist( sidx ) = { tmp };
        sidx = sidx + 1;
    elseif ~isempty( findstr( tmp2, tis ) )
        found = 1;
        slist( sidx ) = { tmp };
        sidx = sidx + 1;

    elseif ~isempty( findstr( tmp2, 'cal' ) )
        found = 1;
        plist( pidx ) = { tmp };
        pidx = pidx + 1;
    else
        mlist( midx ) = { tmp };
        midx = midx + 1;
        
        if ~isempty(findstr(tmp2,'b-'))
            blist(bidx)={tmp};
            bidx=bidx+1;
        elseif ~isempty(findstr(tmp2,'s-'))
            alist(aidx)={tmp};
            aidx=aidx+1;
        end
        
        if ~isempty( findstr( tmp2, phantom ) ) || ~isempty( findstr( tmp2, 'match' ) ) || ~isempty( findstr( tmp2, 'ino' )) || ~isempty( findstr( tmp2, 'cavs' ))
            found = 1;
            plist( pidx ) = { tmp };
            plist2( pidx)= { tmp(1:5)};
            pidx = pidx + 1;
        end
    end
end

mlist = unique( mlist );
slist = unique( slist );
[a,b,c]=unique(plist2);
if(isempty(mlist) && size(a,2)==2)
    if(size(find(c==1),2)>size(find(c==2),2))
        mlist=plist(find(c==1));
        plist=plist(find(c==2));
        mlist = unique( mlist );
        plist = unique( plist );
    else
        mlist=plist(find(c==2));
        plist=plist(find(c==1));
        mlist = unique( mlist );
        plist = unique( plist );
    end
else
    plist = unique( plist );
end