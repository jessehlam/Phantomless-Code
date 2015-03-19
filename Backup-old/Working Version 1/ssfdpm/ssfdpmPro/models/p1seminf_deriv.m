%========================================================================================
%PHASE AND AMPLITUDE CALCULATOR FOR P1 MODEL, v 2.0
%========================================================================================
% Returns phase (radians) and amplitude of P1 seminfinite PDW
% Accepts MHz,1/mm, and mmm, both multi-frequency and multi-distance 
% This version can work with 2-distance too
% 
%
%1/00 AEC	Uses emperical value for reflection coefficient from 
%				R.A.J. Groenhuis et al. Appl. Opt. 22 2463 (1983).		
%1/00 AEC	Modified the Kr and Ki functions to eliminate the branch point at high
%				frequencies by entering Josh's Thesis P1 value for k (page 109) and letting
%				MATLAB take the real and imaginary parts.				
%
%INPUT:	accepts an array of Nx1 frequencies (one r) or an array of Nx1 distances (one f)
%				f		frequency in MHz
%				fx		decide what to use; see (1) below
%				p		p(1) is mua, p(2) is mus', both in 1/mm
%				nind	index of refraction
%				rho	source-detector separation on surface in mm
%OUTPUT:	returns a 2Nx1 matrix for, where 
%				fa		row 1..N    is amplitude P1 approximation PDW
%				fb		row N+1..2N is phase P1 approximation PDW (radians)
function y = p1seminf_deriv(p,f,fx,nind,rho1,rho2, wt, reim_flag);

if nargin<6  %equivalent to one distance
   rho2=0;
end;
if nargin<7  %equivalent to no weights
   wt = ones(length(f)*2,1);
end;
if nargin<8  %equivalent to phase/amp fit
   reim_flag = 0;
end;

if(fx==0)			%fit both mua and mus
   mua=p(1);				%taken in mm-1
   mus=p(2);				%taken in mm-1 
elseif(p(1)>=fx),	%fix mua then fit mus
	mua = fx;				%fixed, and taken in mm-1
	mus = p(1);				%fitted, taken in mm-1   
else					%fix mus then fit mua
   mua = p(1);			   %fixed, and taken in mm-1
	mus = fx;				%fitted, taken in mm-1
end;   

%=the function=============================================================================
mutr = mua+mus;
ltr = 1/mutr;
D=1/3*ltr;			%diffusion coefficient, uses the mua for kicks
I=sqrt(-1);

reff=-1.440/nind^2+0.710/nind+0.668+0.0636*nind;			%assumes air-tissue interface
%reff=.493;
zb = 2/3*(1+reff)/(1-reff)*ltr;									%extrapolated boundary

r01 = sqrt(ltr*ltr+rho1.*rho1);  	            %s-d separation for source, dist 1   
rb1 = sqrt((2*zb+ltr)*(2*zb+ltr)+rho1.*rho1);	%s-d separation for image, dist 1

c = 2.99792458e11/nind;				% now in mm/s
fbc = 1.0e6*2*pi*f./c;			% now in MHZ for omega
alpha=3*fbc*D;		%Josh definition, such that alpha is 2pi*Tcoll/Tmod (page 109).

%===kvector=====================================================================================
k_josh=sqrt((mua-fbc.*alpha-I.*(fbc+mua*alpha))./D);	%complete P1 wavevector
kr=abs(real(k_josh));	
ki=abs(imag(k_josh));		

%==photon density wave===========================================================================
er01 = exp(-kr.*r01);					%exponentials in form e(-kr)/r
erb1 = exp(-kr.*rb1);
ski1 = sin(ki.*(rb1-r01));                  
cki1 = cos(ki.*(rb1-r01));                  

Real = er01./r01 - (cki1.*erb1)./rb1;         %Haskell BC, not the true RE/IM parts just yet
Imag = (ski1.*erb1)./rb1;    

phi=unwrap(ki.*r0-atan(Imag./Real));
amp=sqrt(Re.^2+Im.^2)./D;

Re1=amp.*cos(180/pi*phi);   %true RE
Im1=amp.*sin(180/pi*phi);   %True IM


%==derivatives===========================================================================
dk=-(2*alpha+I.*(1+3*mua*D))./(2*k_josh*c*D);
dkrdw=real(dk);
dkidw=-imag(dk);  %dont know why the minus

dRedw=dkrdw.*(-er01+erb1.*cki1) + dkidw.*(erb1.*ski1.*(rb1-r01)./rb1);
dImdw=erb1.*(dkidw.*cki1.*(rb1-r01)./rb1 - dkrdw.*ski1);

dadw=(Re1.*dRedw+Im1.*dImdw)./sqrt(Re1.^2+Im1.^2)./D;	
dadf=2*pi*dadw;

%===decide output=========================================================================
if(rho2==0),		%flag for single distance = real and imaginary
	if(reim_flag == 0)
		fa=dadf;
        fb=unwrap(atan2(Im1,Re1));		%in radians    
    else   %fit real and imag
        fa=dRedw*2*pi;
        fb=dImdw*2*pi;            
    end;
else					%DO NOT USE YET in phase and amplitude
   r02 = sqrt(ltr*ltr+rho2.*rho2);  	            %s-d separation for source, dist 2   
   rb2 = sqrt((2*zb+ltr)*(2*zb+ltr)+rho2.*rho2);	%s-d separation for image, dist 2
   er02 = exp(-kr.*r02);		
   erb2 = exp(-kr.*rb2);
   ski2 = sin(ki.*(rb2-r02));                  
   cki2 = cos(ki.*(rb1-r02));                  
   
   if(reim_flag==0),
	   fa=sqrt(Re1.^2+Im1.^2)./sqrt(Re2.^2+Im2.^2);
	   fb=unwrap(atan2(Im1,Re1))-unwrap(atan2(Im2,Re2));		%in radians
   else
	   fa=Re2;
	   fb=Im2;
   end;
end;


%y = [[dkrdmua dkrdmus]; [dkidmua dkidmus]];	
%figure(100);plot(f,unwrap(atan2(Im,Re)))
%unwrap(atan2(Im,Re))

y=[fa; fb];		%final return
y = y.*wt;  %Weight for the curvefitting