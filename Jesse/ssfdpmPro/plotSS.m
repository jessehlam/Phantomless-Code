function plotSS(wvrange, fdpmdat, dat, diodes, name, fignum, usediodes,p)

%need to change nargin
diodes=diodes(usediodes==1);

dat.title=name;

if nargin<6 || fignum==0,
	fignum  = figure;
else
	 figure(fignum); clf;
 end;
Position= [10 100 600 600];
set(fignum,'Position',Position)
set(fignum, 'Name', dat.title); 
%errorbar(dat.diodes, dat.diodMus, dat.diodDmus,'r*');
subplot(2,1,1)
plot(diodes, fdpmdat.mus,'ro','markersize',4);
% hold on; plot(wvrange, dat.mus); 
legend('{\mu}_s spectrum','{\mu}_s fdpm',0,'Location','Best'); 
xlabel('Wavelength (nm)');
ylabel('Musp (1/mm)');
title('Musp');

% subplot(2,1,2);
% 
% title('Mua spectrum v fit');
% plot(wvrange,dat.muaSPEC,'b',wvrange,dat.fitmua','k');
% 
% hold on; 
% %errorbar(dat.diodes,dat.diodMua,dat.diodDmua,'r*'); % plotting mua from fdpm
% plot(diodes,fdpmdat.mua,'r*'); % plotting mua from fdpm
% %col = ['r' 'g' 'y' 'c'];
% %for chromohpore placement
% 
% %for i = 1:size(spec.chrom.E,2)
% %   plot(dat.wvrange,spec.chromophoresSPEC(:,i)*conc(i), col(i));
% %end
% legend('{\mu}_a spectrum','fit','{\mu}_a fdpm',0,'Location','SouthEast'); %'HbO_2','Hb','H2O','fat',0);
% %legend('{\mu}_a spectrum','fit','{\mu}_a fdpm',0);
% %graph: save?
% 
% % if p.savefitgraphs
% %     naampje = [p.processed_dir '\recon graphs\_' p.outLabel '_' name '_plotSS.jpg'];
% %     saveas(fignum,naampje,'jpg');
% % end

    