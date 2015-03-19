%TRUNC
%
%Usage: a=trunc(name)
%   name = character string 
%  
%   a = truncated form of name where everything to the left of '\' will be
%   gone and everything to the right of '-'
%   
%
%   Watchout for multiple hits!
%   Modified to cut at furthest right for mutliple hits  byh 4/2005
%   Modified to not cut if - is not in filename  (- is in path)

function a=phtrunc(name)

    lng=length(name);
    
    cutplace = findstr(name,'\');
    if size(cutplace,1)>0
        tname = name((cutplace(size(cutplace,2))+1):lng);    %right most \
    else
        tname = name;
    end
    
    newcut = findstr(tname,'-');
    if size(newcut,1)>0
        a = tname(1:(newcut(1)-1));     %left most -
    else
        a = tname;
    end