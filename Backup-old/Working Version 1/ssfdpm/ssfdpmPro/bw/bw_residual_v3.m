%========================================================================================
%Temperature and chromophore concentration predictive model 
%========================================================================================
%


        
%function res = bw_residual(fitted_bw, weighted_mua, fitted_conc, chroms, Lib_wlength,wlength);
function bw_res = bw_residual(fitted_bw, wlength, mua_data, fitted_conc, wpeak, conc_weight, chroms, Lib_wlength, refwl);

weighted_mua = mua_data.*conc_weight;

bw_shift = fitted_bw;

bw_weight = conc_weight;
% for i=1:length(bw_weight)
%     if (bw_weight(i) == 1);
%         
%     else
%         bw_weight(i) == 0;
%     end
% end


refwli=find(wlength == refwl);

wlscalar = (wpeak-refwl-bw_shift)/(wpeak-refwl);
shift_wlength = wlength;
for ww = refwli:length(wlength)
    shift_wlength(ww) = (wlength(ww)-refwl)*wlscalar + refwl;
end


new_chroms = chroms;
new_chroms(:,2) = interp1(wlength, chroms(:,2), shift_wlength, 'cubic');


bw_res=weighted_mua;
fit_mua = new_chroms*fitted_conc;

subplot(2,1,2)
plot(wlength, fit_mua.*bw_weight', wlength, mua_data);
hold off
pause(.1)
%

bw_res = abs(weighted_mua - fit_mua');
bw_res = bw_weight.*bw_res;

