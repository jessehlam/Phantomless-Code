col={'Frequency','PhiData','AmpData','RecovPhi','RecovAmp'};
filename=strcat('Processed\',num2str(diode),'_recovered','_',writenote);
freq=ft(frqnum2:frqnum);
ampdata=curramp(frqnum2:frqnum);
phidata=currphi(frqnum2:frqnum);
amprecov=curramp_fin(frqnum2:frqnum);
phirecov=currphi_fin(frqnum2:frqnum);
mu=[mu totalitr];
block1=[freq' phidata ampdata phirecov amprecov];

xlswrite(strcat(pth,filename),mu,'Sheet1','A1') %Write recovered optical properties
xlswrite(strcat(pth,filename),col,'Sheet1','A2'); %Write column headers to file
xlswrite(strcat(pth,filename),block1,'Sheet1','A3'); %Write the data to file
