%========================================================================================
%PHASE AND AMPLITUDE CALCULATOR FOR P1 MODEL, v 2.0
%========================================================================================

% Returns phase (radians) and amplitude of P1 seminfinite PDW
\%INPUT:	accepts an array of Nx1 frequencies (one r) or an array of Nx1 distances (one f)
%				f		frequency in MHz
%				fx		decide what to use; see (1) below
%				p		p(1) is mua, p(2) is mus', both in 1/mm
%				nind	index of refraction
%				rho	source-detector separation on surface in mm
%OUTPUT:	returns a 2Nx1 matrix for, where 
%				fa		row 1..N    is amplitude P1 approximation PDW
%				fb		row N+1..2N is phase P1 approximation PDW (radians)

function Y = P1SeminfPlusSpectrum(P,F,nind,rho1,rho2,DIODES,WT, reim_flag);

%========================================================================================
%(1) DECIDE WHAT MUST BE CALCULATED
%========================================================================================

if nargin<7  %equivalent to no weights
   wt = ones(length(F)*2,1);
end;
if nargin<8  %equivalent to real/imaginary fit
   reim_flag = 0;
end;

% DEFINITIONS----------------------------------------------------------
num_diodes = length(DIODES);
for a=1:num_diodes
   MUA(a) = P(a);
end;
preft = P(a+1);
slope = P(a+2);

MUS=preft.*DIODES'.^slope; %.*wt;

MUTR = MUA+MUS;
LTR = 1./MUTR;
D=1/3.*LTR;			%diffusion coefficient, uses the mua for kicks
I=sqrt(-1);

reff=-1.440/nind^2+0.710/nind+0.668+0.0636*nind;			%assumes air-tissue interface
%reff=.493;
ZB = 2/3*(1+reff)/(1-reff).*LTR;									%extrapolated boundary

R01 = sqrt(LTR.*LTR+rho1*rho1);  	            %s-d separation for source, dist 1   
RB1 = sqrt((2.*ZB+LTR).*(2.*ZB+LTR)+rho1*rho1);	%s-d separation for image, dist 1
   
c = 2.99792458e11/nind;				% now in mm/s
FBC = (1.0e6*2*pi/c).*F;			% now in MHZ for omega

if(rho2~=0),		%flag for single distance = real and imaginary
   R02 = sqrt(LTR.*LTR+rho2*rho2);  	            %s-d separation for source, dist 2   
   RB2 = sqrt((2.*ZB+LTR)*(2.*ZB+LTR)+rho2*rho2);	%s-d separation for image, dist 2
end;

for i = 1:num_diodes
   ALPHA =3*D(i).*FBC;		%Josh definition, such that alpha is 2pi*Tcoll/Tmod (page 109).
   
   % K VECTOR----------------------------------------------------------
   K_JOSH=sqrt((MUA(i) - FBC.*ALPHA - I.*(FBC+MUA(i)*ALPHA))./D(i));	%complete P1 wavevector
   
   KR=abs(real(K_JOSH));		%real part of the Josh Thesis K vector, write as positive
   KI=abs(imag(K_JOSH));		%imaginary part of the same, write as positive
   
   %(3) PHOTON DENSITY WAVES
   ER01 = exp(-KR.*R01(i));					%exponentials in form e(-kr)/r
   ERB1 = exp(-KR.*RB1(i));
   RE1 = (+(ER01./R01(i)).*cos(KI.*R01(i)) - (ERB1./RB1(i)).*cos(KI.*RB1(i)))./D(i);
   IM1 = (+(ER01./R01(i)).*sin(KI.*R01(i)) - (ERB1./RB1(i)).*sin(KI.*RB1(i)))./D(i);  
   
   % CALCULATE REAL AND IMAGINARY OR PHASE AND AMPLITUDE--------------
   if(rho2==0),		%flag for single distance = real and imaginary
	   if(reim_flag == 0)
		   FA=sqrt(RE1.*RE1 +IM1.*IM1);
		   FB=unwrap(atan2(IM1,RE1));		%in radians
	   else,
		   FA=RE1;
      	   FB=IM1;
	   end;
   else					%in phase and amplitude
      ER02 = exp(-KR.*R02(i));					%exponentials in form e(-kr)/r
      ERB2 = exp(-KR.*RB2(i));
      RE2 = (+(ER02./R02(i)).*cos(KI.*R02(i)) - (ERB2./RB2(i)).*cos(KI.*RB2(i)))./D(i);
      IM2 = (+(ER02./R02(i)).*sin(KI.*R02(i)) - (ERB2./RB2(i)).*sin(KI.*RB2(i)))./D(i);  
	   if(reim_flag == 0)
		   FA=sqrt(RE1.^2+IM1.^2)./sqrt(RE2.^2+IM2.^2);
		   FB=unwrap(atan2(IM1,RE1))-unwrap(atan2(IM2,RE2));		%in radians
	   else,  
		   FA=RE1+RE2; %%%THIS IS ALMOST CERTAINLY WRONG.
      	   FB=IM1+IM2;
	   end;
   end;
   Y(:,i)=[FA; FB];		%final return
end;

Y = Y(:);
Y = Y.*WT;  %Weight for the curvefitting