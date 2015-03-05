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



%weighted_mua = mua_data.*conc_weight';
options = optimset('display', 'off');
fitted_bw = lsqnonlin('bw_residual_v3', fitted_bw, ...
                    -20, 20, options, wlength', mua_data', fitted_conc, wpeak, conc_weight, chroms, Lib_wlength, refwl);

