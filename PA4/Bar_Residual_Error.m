% get the figure handle
f = figure;
b = bar([FA_set(1:6), FB_set(1:6)]);
% title
title('\fontsize{16}Registration Residual Error of FA and FB');
% x-axis label
xlabel('Data Frame');
% y-axis label
ylabel('Registration Residual Error'); 
% legend
legend('FA','FB');
% store the image
saveas(f,'PA4OutputFig/ResidualError.png');