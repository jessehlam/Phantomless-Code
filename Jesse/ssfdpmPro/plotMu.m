%PLOT_MU
%   graph of all phase and amplitudes
%
%
%NOTES
%   DJ

function   plotMu(final, fit, diodes, name, g,p)

if nargin<5 || g==0,
	g=figure;
else
	figure(g);
end;

fit.title=name;

nDiodes = length(diodes);
set(g, 'Name', char(fit.title)); clf;
mu_figure.Position= [10 100 400 600];
mu_figure.DefaultAxesFontSize= 7;
mu_figure.DefaultAxesXTick= [];
mu_figure.DefaultAxesXLim= [final.freq(1)-50 final.freq(length(final.freq))+50];
mu_figure.DefaultAxesYLim= [-Inf Inf];
% mu_figure.DefaultAxesLineStyleOrder='*|o|^';
mu_figure.DefaultAxesLineStyleOrder='-';
mu_figure.DefaultLineMarkerSize= 5;
%mu_figure.DefaultAxesColorOrder=[]; %[1.0 0 0; 0 1.0 1.0; 0 0 1.0];
set(g, mu_figure);

% disp(['Chance there is another mua mus that will fit as well: ' sprintf('%3.2f%%',100*(1-conf(a)))  ] )
for a=1:nDiodes,
	if a == nDiodes
		set(g, 'DefaultAxesXTickMode', 'auto');
	end;
	
	%AMP
	subplot( nDiodes, 2, 1 + 2*(a-1));
	plot(final.freq, (final.AC(:,a)./final.AC(1,a))); % [haxes, hline1, hline2] = plotyy   ..  fit.freq, (fit.rawamp(:,a) - fit.amp(:,a)), 'plot',
%   	plot(final.freq, (final.AC(:,a)./final.AC(1,a))); % [haxes, hline1, hline2] = plotyy   ..  fit.freq, (fit.rawamp(:,a) - fit.amp(:,a)), 'plot',

	haxes = gca;
	axes_pos = get(haxes, 'Position');
	set(haxes, 'Position', [axes_pos(1)+0.05 axes_pos(2)-.01 axes_pos(3) axes_pos(4)]); %with plot why, for each axes_pos , replace with axes_pos{1}
	hold on;
	plot(final.freq, fit.amp(:,a), 'r-','linewidth',2);
	axes('Position', axes_pos,'Visible','off');
	text(.025,.3,int2str(diodes(a)),'FontSize',10, 'Rotation', 90);
	if a == 1, 
		text(200, axes_pos(2)+0.6,'AMPLITUDE(arb)','FontSize',8); % & RESIDUE
	elseif a == nDiodes, 
		xlabel('FREQUENCY (MHz)');  
	end;
	
	%PHASE
	subplot( nDiodes, 2, 2 + 2*(a-1));
	plot(final.freq, final.phase(:,a)); %[haxes, hline1, hline2] = fit.freq, (fit.rawphi(:,a) - fit.phi(:,a)), 'plot'
	haxes = gca;
	axes_pos = get(haxes, 'Position');
	set(haxes, 'Position', [axes_pos(1)+0.05 axes_pos(2)-.01 axes_pos(3) axes_pos(4)]);
	hold on;
	plot(final.freq, fit.phi(:,a), 'r-','linewidth',2);
	if a == 1, 
		axes('Position', axes_pos,'Visible','off');
		text(200, axes_pos(2)+0.6,'PHASE (rad)','FontSize',8); %& RESIDUE
	elseif a == nDiodes, 
		xlabel('FREQUENCY (MHz)');  
	end;
  

    if p.savefitgraphs
        p.processed_dir=strcat(p.rootdir,p.patientID,'\PROCESSED\');
        cd(p.processed_dir)
        mkdir('Graphs\')
        if p.savefitgraphs
            naampje = [p.processed_dir 'Graphs\' p.outLabel '-' fit.title '_plotMU.jpg'];
            saveas(figure(1),naampje,'jpg')
        end
    end
end