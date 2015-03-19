function conc_weight = calc_conc_weightv3(wlength, mua_data, weighdata, ubc, lbc)

if (weighdata)
%     waterweight = (Lib_data(:,1,2)-min(Lib_data(:,1,2)));
%     lipidweight = (Lib_data(:,1,3)-min(Lib_data(:,1,3)));
%     nigrosinweight = (Lib_data(:,1,4)-min(Lib_data(:,1,4)));
%     waterweight = waterweight/sum(waterweight);
%     lipidweight = lipidweight/sum(lipidweight);
%     nigrosinweight = nigrosinweight/sum(nigrosinweight);
% 
%     conc_weight = waterweight + lipidweight + nigrosinweight;
%     conc_weight = conc_weight/max(conc_weight);

%     [peak_mua ipeak] = max(Lib_data(:,5,2))
%     pwl = Lib_wlength(ipeak);
%     conc_weight = ones(1, length(Lib_wlength));
%     for aa = ipeak - 26 : ipeak + 7
%         conc_weight(aa) = 1000;
%     end

    conc_weight = ones(1, length(mua_data(:,1)));
    for aa = 1:length(conc_weight)
        if wlength(aa) < lbc
            conc_weight(aa) = .001;
        end
        if wlength(aa) > ubc
            conc_weight(aa) = .001;
        end
    end
else
    conc_weight = ones(1, length(mua_data(:,1)));
end

% figure(2)
% %subplot(2,1,2)
% plot(wlength, conc_weight)
% title('Weighting for Concentration Fitting');
% ylabel('Weight');
% xlabel('Wavelength (nm)');