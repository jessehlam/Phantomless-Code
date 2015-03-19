%========================================================================================
%PHASE AND AMPLITUDE CALCULATOR FOR TELEGRAPHER MODEL, v 2.0
%========================================================================================

% Returns phase (radians) and amplitude of P1 seminfinite PDW
% Solution is now written as U(r)-U(rb) for image problem with extrapolated boundary
% Accepts MHz,1/mm, and mmm, both multi-frequency and multi-distance 
% This version can work with 2-distance too
% 
%
%========================================================================================
%Modifications
%========================================================================================
%2/00 AEC	Now will work at all frequencies since MATLAB I don't use RE, IM with branch points
%2/00 AEC	Now includes 1/D as it should
%1/00 AEC	Uses emperical value for reflection coefficient from 
%				R.A.J. Groenhuis et al. Appl. Opt. 22 2463 (1983).		
%1/00 AEC	Modified the Kr and Ki functions to eliminate the branch point at high
%				frequencies by entering Josh's Thesis P1 value for k (page 109) and letting
%				MATLAB take the real and imaginary parts.				
%

%========================================================================================
%Variables
%========================================================================================
%INPUT:	accepts an array of Nx1 frequencies (one r) or an array of Nx1 distances (one f)
%				f		frequency in MHz
%				fx		decide what to use; see (1) below
%				p		p(1) is mua, p(2) is mus', both in 1/mm
%				nind	index of refraction
%				rho	source-detector separation on surface in mm
%OUTPUT:	returns a 2Nx1 matrix for, where 
%				fa		row 1..N    is amplitude P1 approximation PDW
%				fb		row N+1..2N is phase P1 approximation PDW (radians)


function y = telegrapher(p,f,fx,nind,rho1,rho2, wt, reim_flag);

%========================================================================================
%(1) DECIDE WHAT MUST BE CALCULATED
%========================================================================================

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


%========================================================================================
%(2) DEFINITIONS
%========================================================================================

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

fbcsqr = fbc.*fbc;
psidenom = (mua*mutr-fbcsqr);
psi = (fbc*(mua+mutr))./psidenom;
t0 = sqrt(1+psi.*psi);
alpha=3*fbc*D;		%Josh definition, such that alpha is 2pi*Tcoll/Tmod (page 109).
%alpha=0;


%========================================================================================
%(3) K VECTOR
%========================================================================================


k_tele=sqrt(mua*(mua+3*mus)-fbc.^2 - I.*fbc.*(2*mua+3*mus)  );

kr=abs(real(k_tele));
ki=abs(imag(k_tele));


%(3) PHOTON DENSITY WAVES
er01 = exp(-kr.*r01);					%exponentials in form e(-kr)/r
erb1 = exp(-kr.*rb1);

Re1 = (+(er01./r01).*cos(ki.*r01) - (erb1./rb1).*cos(ki.*rb1))./D;
Im1 = (+(er01./r01).*sin(ki.*r01) - (erb1./rb1).*sin(ki.*rb1))./D;  



%========================================================================================
%(4) CALCULATE REAL AND IMAGINARY OR PHASE AND AMPLITUDE
%========================================================================================

%the unwrap eliminates discontinuities in radian phases
if(rho2==0),		%flag for single distance = real and imaginary
   fa=Re1;
   fb=Im1;
   if(reim_flag == 0)
   		fa=sqrt(Re1.^2+Im1.^2);
   		fb=unwrap(atan2(Im1,Re1));		%in radians
	end;

	%fb=180/pi*angle(U1);
else					%in phase and amplitude
   r02 = sqrt(ltr*ltr+rho2.*rho2);  	            %s-d separation for source, dist 2   
   rb2 = sqrt((2*zb+ltr)*(2*zb+ltr)+rho2.*rho2);	%s-d separation for image, dist 2
   er02 = exp(-kr.*r02);					%exponentials in form e(-kr)/r
   erb2 = exp(-kr.*rb2);
   Re2 = (+(er02./r02).*cos(ki.*r02) - (erb2./rb2).*cos(ki.*rb2))./D;
   Im2 = (+(er02./r02).*sin(ki.*r02) - (erb2./rb2).*sin(ki.*rb2))./D;  
   
   fa=sqrt(Re1.^2+Im1.^2)./sqrt(Re2.^2+Im2.^2);
   fb=unwrap(atan2(Im1,Re1))-unwrap(atan2(Im2,Re2));		%in radians
end;



%y = [[dkrdmua dkrdmus]; [dkidmua dkidmus]];	
%figure(100);plot(f,unwrap(atan2(Im,Re)))
%unwrap(atan2(Im,Re))

y=[fa; fb];		%final return
y = y.*wt;  %Weight for the curvefitting