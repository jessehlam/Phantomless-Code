function rawplot(plotraw,fcalc,fdpm)
    
    freq=fcalc.dark(:,1);
    
    if plotraw==1
        for p = 1:length(fdpm.diodes)
            tissue=20*log10(fcalc.msmt(:,2*p+1));
            cal=20*log10(fcalc.cal(:,2*p+1));
            dark=20*log10(fcalc.dark(:,2*p+1));
            
            figure(3);
            subplot(ceil(length(fdpm.diodes)/2),2,p)
            plot(freq,tissue,'b:','linewidth',2); %Plots the raw amplitudes
            hold on
            plot(freq,cal,'r--','linewidth',2);
            plot(freq,dark,'k-','linewidth',0.5);
            line([fdpm.freqrange(1) fdpm.freqrange(1)],[min(dark) max(cal)],'color','g','linewidth',4);
            line([fdpm.freqrange(2) fdpm.freqrange(2)],[min(dark) max(cal)],'color','g','linewidth',4)
            hold off
            name=strcat('Raw Signal:',num2str(fdpm.diodes(p)),'nm');
            title(name);
            xlabel('Frequency (MHz)');
            ylabel('Log Amplitude');
            
            figure(4);
            subplot(ceil(length(fdpm.diodes)/2),2,p)
            plot(freq,fcalc.caldat(:,p),'k');
            hold on;
            line([fdpm.freqrange(1) fdpm.freqrange(1)],[min(fcalc.caldat(:,p)) max(fcalc.caldat(:,p))],'color','g');
            line([fdpm.freqrange(2) fdpm.freqrange(2)],[min(fcalc.caldat(:,p)) max(fcalc.caldat(:,p))],'color','g')
            hold off
            name=strcat('Calibrated Signal:',num2str(fdpm.diodes(p)),'nm');
            title(name);
            xlabel('Frequency (MHz)');
        end
        figure(3)
        legend('Measurement','Calibrator','Dark','Cutoff','location','best');
        figure(4)
        legend('Calibrated Signal','Cutoff','location','best');
    end