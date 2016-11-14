%% initialization
clear;
clc;
format compact;

%% add the path
addpath('PA234 - Student Data/');
addpath('PA3output/');
addpath('Parse/');

%% validate the algorithm
diff_s = zeros(15,3,size('A':'F',2));
max_s = [];
ssd_s = [];
diff_c = zeros(15,3,size('A':'F',2));
max_c = [];
ssd_c = [];
distance_set = zeros(15,size('A':'F',2));

i = 1;
for char = ['A':'F']
    if ismember(char, 'A':'F');
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
    diff_s(:,:,i) = difference_s;
    max_s = [max_s; max(sum(difference_s.^2, 2).^1/2)];
    ssd_s = [ssd_s; sum(sum(difference_s.^2, 2).^1/2)];
    
    difference_c = validation_set(:,4:6) - computed_set(:,4:6);
    diff_c(:,:,i) = difference_c;
    max_c = [max_c; max(sum(difference_c.^2, 2).^1/2)];
    ssd_c = [ssd_c; sum(sum(difference_c.^2, 2).^1/2)];
    
    distance = validation_set(:,7) - computed_set(:,7);
    distance_set(:,i) = distance;
    
    i = i+1;
end