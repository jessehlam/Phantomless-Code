%% Plotting

if plots==1
    figure
    set(gcf,'Position', [800 75 500 600]); %setting position and size of plot
    subplot(2,1,1);
    plot(FDPM.F(frqnum2:frqnum),curramp(frqnum2:frqnum),'b*'); %Plotting modulation
    hold on;
    plot(FDPM.F(frqnum2:polyfrq),amppolyN,'r'); %plotting amp fit
    legend('Calibrated Data','Poly Fit','location','best')
    hold off;
    ylabel('Normalized Amplitude');
    title('Calibrated, Normalized');
    axis auto
    
    subplot(2,1,2);
    plot(FDPM.F(frqnum2:frqnum),currphi(frqnum2:frqnum),'b*','HandleVisibility','off'); %Plotting the phase
    hold on;
    if plotfit==1
        plot(FDPM.F(frqnum2:polyfrq),phipolyN,'r'); %plotting phi fit
        hold off;
    end
    axis auto
    ylabel('Phase (Degrees)');
    xlabel('Frequency (Mhz)');
    
if plotraws==1
    plotraw;
end

end

cd(defaultdir)