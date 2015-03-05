col={'Frequency','PhiData','AmpData','RecovPhi','RecovAmp'};
filename=strcat('Processed\',num2str(diode),'_recovered','_',writenote);
freq=ft(frqnum2:frqnum);
ampdata=curramp(frqnum2:frqnum);
phidata=currphi(frqnum2:frqnum);
amprecov=curramp_fin(frqnum2:frqnum);
amprecov=amprecov/amprecov(1);
phirecov=currphi_fin(frqnum2:frqnum);
mu=[mu totalitr];
block1=[freq' phidata ampdata phirecov amprecov];

xlswrite(strcat(basepth,filename),mu,'Sheet1','A1') %Write recovered optical properties
xlswrite(strcat(basepth,filename),col,'Sheet1','A2'); %Write column headers to file
xlswrite(strcat(basepth,filename),block1,'Sheet1','A3'); %Write the data to file
