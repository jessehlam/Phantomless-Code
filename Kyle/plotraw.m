%% Plotting
figure
set(gcf,'Position', [800 75 500 600]); %setting position and size of plot
plot(FDPM.F(1:334),FDPM.AMP(1:334),'b*'); %Plotting raw tissue amplitude
hold on;
plot(FDPM.F(1:334),CAL.AMP(1:334),'r*'); %plotting raw calibrator amplitude
hold off;
title('Raw Amplitudes');
xlabel('Frequency (MHz)');
ylabel('Amplitude');
legend('Raw "Tissue" Amplitude','Raw Calibrator Amplitude','location','best')

hold on
plot(noiseFloor.f*1000,noiseFloor.amp,'c*')
plot(highffile.data(1,1),mean(highf.amp),'g*','MarkerSize',20)


% figure
% plot(FDPM.F(1:334),FDPM.PHI(1:334),'b-');
% hold on;
% plot(FDPM.F(1:334),CAL.PHI(1:334),'r-');
% title('Raw Phase');
% xlabel('Frequency (MHz)');
% ylabel('Phase');
% legend('Raw "Tissue" Phase','Raw Calibrator Phase','location','best')


if plotrawcal==1
    figure
    plot(FDPM.F(1:334),rawamp(1:334),'b*'); %Plotting the non-normalized amp
    ylabel('Amplitude');
    title('Calibrated, Not Normalized');
    xlabel('Frequency (Mhz)');
end

axis auto