% get the figure handle
f = figure;
b = bar([residual_FA_set, residual_FA_SVD_set]);
% title
title('\fontsize{16}FA: Registration Residual Error by Different Registration Methods');
% x-axis label
xlabel('Data Frame');
% y-axis label
ylabel('Registration Residual Error'); 
% legend
legend('FA: Least Square Problem','FA: Singular Vector Decomposition');
% store the image
saveas(f,'PA4OutputFig/registrationerror/RegistrationCompFA.png');

% get the figure handle
f = figure;
b = bar([residual_FB_set, residual_FB_SVD_set]);
% title
title('\fontsize{16}FB Registration Residual Error by Different Registration Methods');
% x-axis label
xlabel('Data Frame');
% y-axis label
ylabel('Registration Residual Error'); 
% legend
legend('FB: Least Square Problem','FB: Singular Vector Decomposition');
% store the image
saveas(f,'PA4OutputFig/registrationerror/RegistrationCompFB.png');