function lc = rline(fid)  % for reading one line
%% rline( fid )
%% reads in one line of text from a file.
%% 


c=0;l = [];

while c ~= 10  % 10 must be an ASCII delimiter or something???
  c = fread(fid,1,'char');  % read into c what fid has, one character at a time
  
  if c>127
    c = 256-c;
  end;
  l = [l c];
  
end;  

lc = char(l); % convert to character