%% initialization
clear;
clc;
format compact;

%% add the path
addpath('PA234 - Student Data/');
addpath('PA4output/');
addpath('Parse/');

%% validate the algorithm
difference_norm = [];
for char = 'A':'F'
    validation_set_path = strcat('PA4-', char, '-Debug-Output.txt');
    FID = fopen(validation_set_path);
    file = fgetl(FID);
    datasize = [7, Inf];
    validation_set = transpose(fscanf(FID, '%f\t%f\t%f\n', datasize));
    fclose(FID);
    
    computed_set_path = strcat('solved-PA4-',char,'-output.txt');
    computed_set = csvread(computed_set_path);
    
    difference = validation_set(:,6) - computed_set(:,6);
    difference_norm = [difference_norm; sum(sum(difference.^2, 2).^1/2)];
end