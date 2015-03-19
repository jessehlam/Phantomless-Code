
function F=powerlaw(p,x, wt)

if nargin<3
   F=(p(1))*x.^p(2);
else
	F=((p(1))*x.^p(2)).*wt;
end;


