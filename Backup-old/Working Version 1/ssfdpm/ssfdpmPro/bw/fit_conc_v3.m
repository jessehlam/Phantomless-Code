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

weighted_mua = mua_data.*conc_weight';
bw_shift = fitted_bw;


%bound water correction
%[peak_mua wmaxi] = max(weighted_mua);

refwli=find(wlength == refwl);

%wlscalar = (wlength(wmaxi)-refwl-bw_shift)/(wlength(wmaxi)-refwl);
wlscalar = (wpeak-refwl-bw_shift)/(wpeak-refwl);
shift_wlength = wlength;
for ww = refwli:length(wlength)
    shift_wlength(ww) = (wlength(ww)-refwl)*wlscalar + refwl;
end

new_chroms = chroms;
new_chroms(:,2) = interp1(wlength', chroms(:,2), shift_wlength', 'cubic');

P=[];
options = optimset('display', 'off');
numconc = size(chroms, 2);


for a = [1 2 3 4 5 6 7 8 9]
    weighted_lib(:,a)=new_chroms(:,a).*conc_weight';
end

fitted_conc = lsqnonneg(weighted_lib, weighted_mua);
water = weighted_mua;

for a=[1 3 4 5 6 7 8 9] 
    water = water - fitted_conc(a)*weighted_lib(:,a);  %subtracts non-water chromophores
end

[wmax pwl] = max(water);
wpeak = wlength(pwl);


fit_mua = new_chroms*fitted_conc;
figure(3);
subplot(2,1,1)
plot(wlength, fit_mua, wlength, mua_data) 
%             teal              purp
title('Chromophore Fit')
ylabel('Absorption')
xlabel('Wavelength (nm)')
