%% initialization
clear;
clc;
format compact;

%% add the path
addpath('PA234 - Student Data/');
addpath('PA4OutputData/');
addpath('Parse/');

%% validate the algorithm
s_diff_norm = zeros(6,1);
c_diff_norm = zeros(6,1);
distance_diff_norm = zeros(6,1);
for char = 'A':'F'
    % read the given debug result file
    validation_set_path = strcat('PA4-', char, '-Debug-Output.txt');
    FID = fopen(validation_set_path);
    file = fgetl(FID);
    datasize = [7, Inf];
    validation_set = transpose(fscanf(FID, '%f\t%f\t%f\n', datasize));
    fclose(FID);
    
    % read the computed resul file
    computed_set_path = strcat('solved-PA4-',char,'-output.txt');
    computed_set = csvread(computed_set_path);
    
    % get the difference of three terms
    s_diff = sum((validation_set(:,1:3) - computed_set(:,1:3)).^2, 2).^1/2;
    s_diff_norm(abs(char)-64) = sum(s_diff.^2, 1).^1/2;
    
    c_diff = sum((validation_set(:,4:6) - computed_set(:,4:6)).^2, 2).^1/2;
    c_diff_norm(abs(char)-64) = sum(c_diff.^2, 1).^1/2;
    
    distance_diff = validation_set(:,7) - computed_set(:,7);
    distance_diff_norm(abs(char)-64) = sum(distance_diff.^2, 1).^1/2;

    % display the results
    disp(strcat('data set:', char));
    disp(strcat('the difference of sample points coordinates:', ...
        num2str(s_diff_norm(abs(char)-64))));
    disp(strcat('the difference of closest points coordinates:', ...
        num2str(c_diff_norm(abs(char)-64))));
    disp(strcat('the difference of closest distance:', ...
        num2str(distance_diff_norm(abs(char)-64)))); 
    disp('--------------------------------------------------------------');
end

%% plot the bar
f = figure;

b = bar(s_diff_norm, 'b');
% title
title('\fontsize{16}differce of sample points coordinates');
% x-axis label
xlabel('Data Frame');
% y-axis label
ylabel('norm of difference'); 
saveas(f,'PA4OutputFig/diffnorm/s_diff_norm.png');

bar(c_diff_norm,'y');
% title
title('\fontsize{16}differce of closest points coordinates');
% x-axis label
xlabel('Data Frame');
% y-axis label
ylabel('norm of difference'); 
saveas(f,'PA4OutputFig/diffnorm/c_diff_norm.png');

bar(distance_diff_norm, 'r');
% title
title('\fontsize{16}differce of closest distance');
% x-axis label
xlabel('Data Frame');
% y-axis label
ylabel('norm of difference'); 
saveas(f,'PA4OutputFig/diffnorm/distance_diff_norm.png');
