%% initialization
clear;
clc;
format compact;

%% add the path
addpath('PA234 - Student Data/');
addpath('PA3output/');
addpath('Parse/');

%% some validation criteria
% the difference of s
diff_s = zeros(15,3,size('A':'F',2));
% the maximum difference of each pair of files
max_s = [];
% the sum of difference of each pair of files
ssd_s = [];
% the difference of c
diff_c = zeros(15,3,size('A':'F',2));
max_c = [];
ssd_c = [];
% the difference of closest distance from point to mesh
distance_set = zeros(15,size('A':'F',2));

%% validation process
i = 1;
for char = ['A':'H','J']
    if ismember(char, 'A':'F')
        validation_set_path = strcat('PA3-', char, '-Debug-Output.txt');
    else
        validation_set_path = strcat('PA3-', char, '-Unknown-Output.txt');
    end
    FID = fopen(validation_set_path);
    file = fgetl(FID);
    datasize = [7, Inf];
    validation_set = transpose(fscanf(FID, '%f\t%f\t%f\n', datasize));
    fclose(FID);
    
    computed_set_path = strcat('solved-PA3-',char,'-output.txt');
    computed_set = csvread(computed_set_path);
    
    difference_s = validation_set(:,1:3) - computed_set(:,1:3);
    difference_s;
    max_s = [max_s; max(sum(difference_s.^2, 2).^1/2)];
    ssd_s = [ssd_s; sum(sum(difference_s.^2, 2).^1/2)];
    
    difference_c = validation_set(:,4:6) - computed_set(:,4:6);
    difference_c;
    max_c = [max_c; max(sum(difference_c.^2, 2).^1/2)];
    ssd_c = [ssd_c; sum(sum(difference_c.^2, 2).^1/2)];
    
    distance = validation_set(:,7) - computed_set(:,7);
    
    i = i+1;
end

%% list some difference by uncommenting certain lines
% the difference of samples points' coordinates
% diff_s
% the maximum difference of esamples points' coordinates
% max_s
% the sum of difference of samples points' coordinates
% ssd_s
% the difference of closest points' coordinates
% diff_c
% max_c
% ssd_c
% the difference of distance from closest point to mesh
% distance_set