function y = vpRofRhoandFt(p,f,fx,nind,rho1,rho2, wt, reim_flag,boundary_opt, reff)

ft=f/1000;
temp = VtsSolvers.ROfRhoAndFt([p .8 nind], rho1, ft);

if(reim_flag==0)
    amp = abs(temp);
    amp = amp./amp(1);
    phase = -angle(temp);
    y = [amp;phase];
else
    rp = real(temp);
    ip = abs(imag(temp));
    y = [rp;ip];
end

 if(wt~=0)
     y = y.*wt;  %Weight for the curvefitting
 end