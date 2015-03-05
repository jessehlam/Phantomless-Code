function [rep, none, ave] = getMeasurementList( list )
% [rep, none, ave] = getMeasurementList( list )
% 
% list = guiVal.measurement_list_base
% 
% rep = number of repetitions
% none = NO AVERAGING
% averging = AVERAGING

% cur_dir = cd;
% cd( directory );
% temp = dir( '*.asc' );
% list = { temp.name };

%%removine the irrelavent stuff at the end of the measurement name
len = length( list );
templist=list;
clear list;
list={};
count=1;
for i = 1:len
    str = templist{i};
    str = str(1: lastIndexOf( '-', str ) - 1 );
    if(isempty(str)==0)
        list{count} = str;
        count=count+1;
    end
end
len=length(list);
%%initialize the return parameters
rep = -1;
ave = {};
none= {};


for i = 1:len       %for each element in the list
    str = list{i};  
    character = str( length(str) ); %single out the last character in the name
    
    none{ length(none) + 1 } = str;
    if( isDigit( character ) )  %if the last character is a digit
        rep = max( rep, str2num(character) );   %%max( all end numbers ) ==> rep_num 
        
        idx = length(str);
        
        temp = idx;
        while( idx > 0 && isDigit( str(idx) ) )
            idx = idx - 1;
        end
        if( idx < 1 )
            idx = temp;
            rep = 0;
        end
       
        
%           disp( sprintf( 'length of %s is %d', str, length(str) ) );
%         if( length(str) == 7 )
%             pause
%         end
        
        if( isAlphaNumeric( str(length(str) ) ) )
            ave{ length(ave) + 1 } = str( 1:idx  );
        else
            ave{ length(ave) + 1 } = str( 1:idx-1 );
        end
    end
end

for i = 1:length( ave )
    str = ave{i};
    if( ~isAlphaNumeric( str( length(str) ) ) )
        ave{i} = str( 1:length(str) - 1 );
    end
end
    
none = unique( none );
ave  = unique(  ave );
%%byh 4/04 not all measurements have same number of repititions, but
%%current methold assumes that.  Change ave here to create a different list
%%based on the repitition number.
clear ave;
ave={};
for i=1:length(none)
    str=none{i};
    character=str(length(str));
    if(isDigit(character))
        if(isequal(str2num(character),1))
            ave(length(ave)+1)={str};
        end
    end
end
for j=2:rep
    temp=0;
    ave(j,1)={[]};
    for i=1:size(ave,2)
        str=ave{j-1,i};
        if(str)    
            str(length(str))=num2str(j);
            if(strmatch(str,none))
                ave(j,temp+1)={str};
                temp=temp+1;
            end
        end
    end
end
%%now remove the repitition number
for i=1:size(ave,2)
    for j=1:size(ave,1)
        str=ave{j,i};
        str=str(1:lastIndexOf('-',str)-1);
        ave{j,i}=str;
    end
end
                
% cd( cur_dir );