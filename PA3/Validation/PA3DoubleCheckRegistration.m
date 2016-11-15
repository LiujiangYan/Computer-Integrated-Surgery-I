%% initialization
clear;
clc;
format compact;

%% add the path
addpath('PA234 - Student Data/');
addpath('Parse/');
addpath(genpath('ICP/'));

%% read Body A B and mesh files
body_A_filepath = 'PA234 - Student Data/Problem3-BodyA.txt';
[num_a, a, a_tip] = parseBody(body_A_filepath);

body_B_filepath = 'PA234 - Student Data/Problem3-BodyB.txt';
[num_b, b, b_tip] = parseBody(body_B_filepath);

%% iterative closest point process
ssd_d = [];
for char = ['A':'F']
    % read the samples' information
    if ismember(char, 'A':'F')
        experiment_filepath = strcat('PA234 - Student Data/PA3-', char,...
            '-Debug-SampleReadingsTest.txt');
        control_filepath = strcat('PA3-', char, '-Debug-Output.txt');
    else
        experiment_filepath = strcat('PA234 - Student Data/PA3-', char,...
            '-Unknown-SampleReadingsTest.txt');
        control_filepath = strcat('PA3-', char, '-Unknown-Output.txt');
    end
    [num_samples, A_set, B_set] = parseSample(experiment_filepath, num_a, num_b);
    
    FID = fopen(control_filepath);
    file = fgetl(FID);
    datasize = [7, Inf];
    validation_set = transpose(fscanf(FID, '%f\t%f\t%f\n', datasize));
    fclose(FID);

    control_d_set = validation_set(:,1:3);

    for i=1:num_samples
        A = A_set(:,:,i);
        B = B_set(:,:,i);
        [FA, residual_FA] = registration(A,a);
        [FB, residual_FB] = registration(B,b);
        d = FB\FA*[a_tip';1];
        
        experiment_d_set(i,:) = d(1:3)'; 
    end
    
    disp(strcat('the residual of of FA ', num2str(residual_FA)));
    disp(strcat('the residual of of FB ', num2str(residual_FB)));
    disp('the norm of difference of samples points coordinates');
    disp(norm(experiment_d_set - control_d_set));
    
    % uncomment the following lines to see the results
    % residual_FA
    % residual_FB
    
    % the norm of difference of samples points' coordinates
    ssd_d = [ssd_d; norm(experiment_d_set - control_d_set)];
end