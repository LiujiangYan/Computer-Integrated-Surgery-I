%% add the path
addpath('PA234 - Student Data/');
addpath('PA5OutputData/');
addpath('Parse/');

%% validate the algorithm
lambda_diff_norm = zeros(6,2);
s_diff_max = zeros(6,2);
c_diff_max = zeros(6,2);
distance_diff_max = zeros(6,2);
for index = 1:2
    for char = 'A':'F'
        % read the given debug result file
        validation_set_path = strcat('PA234 - Student Data/PA5-', char, '-Debug-Output.txt');
        [lambda, s_set, c_set, dist_set] = ...
            parseOutput(validation_set_path);

        % read the computed resul file
        computed_set_path = strcat('PA5OutputData/Method-',num2str(index),'/PA5-',char,'-Output-',num2str(index),'.txt');
        [computed_lambda, computed_s_set, computed_c_set, computed_dist_set] = ...
            parseComputedOutput(computed_set_path);

        % get the difference of three terms
        lambda_diff_norm(abs(char)-64,index) = norm(lambda - computed_lambda);

        s_diff = sum((s_set - computed_s_set).^2, 2).^1/2;
        s_diff_max(abs(char)-64,index) = max(s_diff);

        c_diff = sum((c_set - computed_c_set).^2, 2).^1/2;
        c_diff_max(abs(char)-64,index) = max(c_diff);

        distance_diff = dist_set - computed_dist_set;
        distance_diff_max(abs(char)-64,index) = max(distance_diff);

        % display the results
        disp(strcat('data set:', char));
        disp(strcat('the difference of Lambda:', ...
            num2str(lambda_diff_norm(abs(char)-64))));
        disp(strcat('the difference of sample points coordinates:', ...
            num2str(s_diff_max(abs(char)-64))));
        disp(strcat('the difference of closest points coordinates:', ...
            num2str(c_diff_max(abs(char)-64))));
        disp(strcat('the difference of closest distance:', ...
            num2str(distance_diff_max(abs(char)-64)))); 
        disp('--------------------------------------------------------------');
    end
    
end

f = figure;
b = bar(lambda_diff_norm);
b(2).LineWidth = 2;
b(2).EdgeColor = 'red';
% title
title('\fontsize{16}differce of Lambda');
% x-axis label
xlabel('Data Frame');
% y-axis label
ylabel('norm of difference'); 
% legend
legend('Method 1', 'Method 2');
saveas(f,strcat('PA5OutputFig/DiffNorm/lambda_diff_max.png'));

f = figure;
b = bar(s_diff_max);
b(2).LineWidth = 2;
b(2).EdgeColor = 'red';
% title
title('\fontsize{16}differce of sample points coordinates');
% x-axis label
xlabel('Data Frame');
% y-axis label
ylabel('norm of difference'); 
% legend
legend('Method 1', 'Method 2');
saveas(f,strcat('PA5OutputFig/DiffNorm/s_diff_max.png'));

f = figure;
b = bar(c_diff_max);
b(2).LineWidth = 2;
b(2).EdgeColor = 'red';
% title
title('\fontsize{16}differce of closest points coordinates');
% x-axis label
xlabel('Data Frame');
% y-axis label
ylabel('norm of difference'); 
% legend
legend('Method 1', 'Method 2');
saveas(f,strcat('PA5OutputFig/DiffNorm/c_diff_max.png'));

f = figure;
b = bar(distance_diff_max);
b(2).LineWidth = 2;
b(2).EdgeColor = 'red';
% title
title('\fontsize{16}differce of closest distance');
% x-axis label
xlabel('Data Frame');
% y-axis label
ylabel('norm of difference'); 
% legend
legend('Method 1', 'Method 2');
saveas(f,strcat('PA5OutputFig/DiffNorm/dist_diff_max.png'));
