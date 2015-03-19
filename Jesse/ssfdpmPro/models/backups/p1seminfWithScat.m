%========================================================================================
%complete spectrum fitter (version 1.4)
%   P has form of [mua_1 mua_2 ... mua_n, prefactor, slope]
%   F is the frequency (MHz), of form [freq_1 freq_2 ... freq_n] (ie same
%           f's repeated as column vectors)
%   nind is index of refraction
%   rho1, rho2 are the distances (use rho2=0 for single distance)
%   Diodes is names of diodes (only the number are used)
%   WT are the fitting weights as same format
%
%
%   NOTES
%       modified AEC 03/03


function Y = p1seminfWithScat(P,F,nind,rho1,rho2,Diodes,WT, reim_flag);

% DEFINITIONS----------------------------------------------------------
if nargin<7  %equivalent to no weights
   WT = ones(length(F)*2*Diodes,1);
end;
if nargin<8  %equivalent to real/imaginary fit
   reim_flag = 0;
end;
num_diodes = length(Diodes);
for a=1:num_diodes
   Mua(a) = P(a);
end;
preft = P(a+1);
slope = P(a+2);

%Power law
Mus=preft.*Diodes'.^slope; %.*wt;

Mutr = Mua+Mus;
Ltr = 1./Mutr;
D=1/3.*Ltr;			%diffusion coefficient, uses the mua for kicks

reff=-1.440/nind^2+0.710/nind+0.668+0.0636*nind;			%assumes air-tissue interface
%reff=.493;
Zb = 2/3*(1+reff)/(1-reff).*Ltr;									%extrapolated boundary
Ro1 = sqrt(Ltr.*Ltr+rho1*rho1);  	            %s-d separation for source, dist 1   
Rb1 = sqrt((2.*Zb+Ltr).*(2.*Zb+Ltr)+rho1*rho1);	%s-d separation for image, dist 1
   
c = 2.99792458e11/nind;				% now in mm/s
Freq = (1.0e6*2*pi/c).*F;			% now in MHZ for omega.  col=diodes, row=freq

if(rho2~=0),		%flag for single distance = real and imaginary
   R02 = sqrt(Ltr.*Ltr+rho2*rho2);  	            %s-d separation for source, dist 2   
   RB2 = sqrt((2.*Zb+Ltr)*(2.*Zb+Ltr)+rho2*rho2);	%s-d separation for image, dist 2
end;

%ALPHA =3*Freq*D;		%Josh definition, such that alpha is 2pi*Tcoll/Tmod (page 109).
for a = 1:num_diodes
    ALPHA(:,a) =3*Freq(:,a)*D(a);		%Josh definition, such that alpha is 2pi*Tcoll/Tmod (page 109).

    Kjosh=sqrt((Mua(a) - Freq(:,a).*ALPHA(:,a) - i.*(Freq(:,a)+Mua(a).*ALPHA(:,a)))./D(a));	%complete P1 wavevector
	KR=abs(real(Kjosh));		%real part of the Josh Thesis K vector, write as positive
	KI=abs(imag(Kjosh));		%imaginary part of the same, write as positive
	
	%(3) PHOTON DENSITY WAVES
	ER01 = exp(-KR.*Ro1(a));					%exponentials in form e(-kr)/r
	ERB1 = exp(-KR.*Rb1(a));
	RE1(:,a) = (+(ER01./Ro1(a)).*cos(KI.*Ro1(a)) - (ERB1./Rb1(a)).*cos(KI.*Rb1(a)))./D(a);
	IM1(:,a) = (+(ER01./Ro1(a)).*sin(KI.*Ro1(a)) - (ERB1./Rb1(a)).*sin(KI.*Rb1(a)))./D(a);  
	if(rho2~=0),		%flag for single distance = real and imaginary
		ER02 = exp(-KR.*R02(a));					%exponentials in form e(-kr)/r
		ERB2 = exp(-KR.*RB2(a));
		RE2(:,a) = (+(ER02./R02(a)).*cos(KI.*R02(a)) - (ERB2./RB2(a)).*cos(KI.*RB2(a)))./D(a);
		IM2(:,a) = (+(ER02./R02(a)).*sin(KI.*R02(a)) - (ERB2./RB2(a)).*sin(KI.*RB2(a)))./D(a);  
	end;
end;


% CALCULATE REAL AND IMAGINARY OR PHASE AND AMPLITUDE--------------
if reim_flag
	FA=RE1;
	FB=IM1; %past error
else
	FA=sqrt(RE1.*RE1 +IM1.*IM1);
	FB=unwrap(atan2(IM1,RE1));		%in radians
end;	
	
if(rho2~=0),		%flag for two distance = real and imaginary
	%if reim_flag,
		%FA=FA+RE2; %%%THIS IS ALMOST CERTAINLY WRONG.
		%FB=FB+IM2;
        %else
        disp('Multi-R only valid with phase/amplitude')
		FA=FA./sqrt(RE2.^2+IM2.^2);
		FB=FB-unwrap(atan2(IM2,RE2));		%in radians
        %end;
end;

Y=[FA; FB];
%Y = Y(:).*WT;
Y = Y.*WT;