
figure(2)
plot(freq,msmtdat,'b:','linewidth',3); %Plots the raw amplitudes
hold on
plot(freq,phandat,'r--','linewidth',3);
plot(freq,darkdat,'k-','linewidth',0.5);
line([fdpm.freqrange(1) fdpm.freqrange(1)],[min(darkdat) max(phandat)],'color','g','linewidth',4);
line([fdpm.freqrange(2) fdpm.freqrange(2)],[min(darkdat) max(phandat)],'color','g','linewidth',4)
hold off
title('Raw Signals');
legend('Measurement','Calibrator','Dark','Cutoff','location','best');
xlabel('Frequency (MHz)');
ylabel('Log Amplitude');

figure(3)
plot(freq,caldat,'k');
hold on;
line([fdpm.freqrange(1) fdpm.freqrange(1)],[min(caldat) max(caldat)],'color','g');
line([fdpm.freqrange(2) fdpm.freqrange(2)],[min(caldat) max(caldat)],'color','g')
hold off
legend('Calibrated Signal','Cutoff');
title('Calibrated Signal');
xlabel('Frequency (MHz)');

% figure(4)
% plot(freq,snrmsmt); %Plots the SNR ratios
% hold on
% plot(freq,snrphan,'r');
% line([down down],[min(snrphan) max(snrphan)],'color','g');
% line([up up],[min(snrphan) max(snrphan)],'color','g')
% hold off
% title('Dark to Signal Ratio');
% legend('Measurement','Calibrator','Cutoff','location','best');