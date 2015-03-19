% Calculates the bound water shift of a target from it's spectral data using a library of optical data.
% Input:
%     Lib_wlength ... indices for the rows of Lib_data
%     Lib_temp ...... indices for the cols of Lib_data   
%     Lib_data ...... 3D matrix of mua data for different components (row-wavelength col-temp depth-components)
%     chroms..........2D matrix of mua data for different components
%                     (row-wavelength col-components), derived from Lib_data
%     wlength ....... indices for mua_data
%     mua_data ...... vector of measured mua data
%     conc_weight ... the weighting used for fitting concentration
%    
% Output:
%     fitted_bw ... the calculated bound water of the target
%     fitted_conc ... the calculated concentration of the components
%     water_mua ... the water mua determined by subtracting out the
%                           contributions from the other chomophores from the mua_data
%     converged ... 

function [fitted_bw, fitted_conc, wpeak, converged] = bw_fitting1v3(Lib_wlength, chroms, ...
                                    wlength, mua_data, conc_weight,conc_guess, bw_guess, peak_guess, refwl)
fitted_conc = conc_guess;
fitted_bw= bw_guess;
wpeak = peak_guess;

%disp('Fitting # 1');

fit_conc_v3
fit_bw_v3

fitted_bw_old = -999; fitnum=1;
while (abs(fitted_bw - fitted_bw_old) > 0.1) && (fitnum < 15)

    fitted_bw_old = fitted_bw;
    fitnum = fitnum+1;
    if fitnum==15;
        converged=0;
    else
        converged=1;
    end
 %   disp(['Fitting # ' int2str(fitnum)]);
    fit_conc_v3
    fit_bw_v3
    
end

