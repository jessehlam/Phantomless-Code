function a = rexp_minus_rtheory(mua, Rexp, musp, rho, n_tissue, reff_option)

% global Rexp;
% global musp;
% global rho;
% global n_tissue;
% musp reduced scattering coefficient
% rho: source-detector separation
% Rexp: reflectance(rho) from experiment
%n: refractive index

a=Rexp-Rtheory(mua,musp,rho,n_tissue, reff_option);