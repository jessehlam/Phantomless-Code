
figure(2)
plot(freq,msmtdat); %Plots the raw amplitudes
hold on
plot(freq,phandat,'r');
plot(freq,darkdat,'k');
line([down down],[min(darkdat) max(phandat)],'color','g');
line([up up],[min(darkdat) max(phandat)],'color','g')
hold off
title('Raw Signals');
legend('Measurement','Calibrator','Dark','Cutoff','location','best');

% figure(3)
% plot(freq,snrmsmt); %Plots the SNR ratios
% hold on
% plot(freq,snrphan,'r');
% line([down down],[min(snrphan) max(snrphan)],'color','g');
% line([up up],[min(snrphan) max(snrphan)],'color','g')
% hold off
% title('Dark to Signal Ratio');
% legend('Measurement','Calibrator','Cutoff','location','best');