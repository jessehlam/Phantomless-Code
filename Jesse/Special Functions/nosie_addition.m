%%
close all
subplot(2,1,1)
scatter(1:length(vtsmod),abs(vtsmod))
subplot(2,1,2)
scatter(1:length(vtsmod),-angle(vtsmod))

