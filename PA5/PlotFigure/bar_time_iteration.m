% get the figure handle
f = figure;

% elapsed time for each method
time_method_1 = [44.538887 57.191296 54.078868 56.899327 113.972195 117.562467 59.514505 74.863948 97.024606 46.720932];
time_method_2 = [23.685871 41.313625 27.115053 34.222493 66.736268 56.775678 35.177137 45.515077 57.494990 48.132418]; 
time_method_2_tree = [27.4753 50.3823 33.8718 40.7353 78.1699 66.9529 45.4652 49.9650 67.9114 59.7651];
iteration_method_1 = [65 90 84 89 94 93 92 63 80 74];
iteration_method_2 = [28 49 32 41 46 41 44 31 43 57];

%% time
% draw bar
b = bar([time_method_1' time_method_2']);
% highlight the minimun elapsed time search method
b(2).LineWidth = 2;
b(2).EdgeColor = 'red';

% title
title('elapsed time for two methods');
% x-axis label
xlabel('Data Frame');
% y-axis label
ylabel('Elapsed Time'); 
% legend
legend('method 1', 'method 2');

% store the image
saveas(f,'PA5OutputFig/elapsed_time_method_12.png');

%% iteration
% draw bar
b = bar([iteration_method_1' iteration_method_2']);
% highlight the minimun elapsed time search method
b(2).LineWidth = 2;
b(2).EdgeColor = 'red';

% title
title('experienced iterations for two methods');
% x-axis label
xlabel('Data Frame');
% y-axis label
ylabel('Experienced Iterations'); 
% legend
legend('method 1', 'method 2');

% store the image
saveas(f,'PA5OutputFig/taken_iteration_method_12.png');

%% time per iteration
% draw bar
b = bar([(time_method_1./iteration_method_1)'...
    (time_method_2./iteration_method_2)']);
% highlight the minimun elapsed time search method
b(2).LineWidth = 2;
b(2).EdgeColor = 'red';

% title
title('time per iteration for two methods');
% x-axis label
xlabel('Data Frame');
% y-axis label
ylabel('Time per Iteration'); 
% legend
legend('method 1', 'method 2');

% store the image
saveas(f,'PA5OutputFig/time_per_iteration_method_12.png');

%% time for different search method
% draw bar
b = bar([time_method_2' time_method_2_tree']);
% highlight the minimun elapsed time search method
b(1).LineWidth = 2;
b(1).EdgeColor = 'red';

% title
title('time consumed for two search methods');
% x-axis label
xlabel('Data Frame');
% y-axis label
ylabel('Time Consumed'); 
% legend
legend('Linear Search by Bounding Sphere', 'Octree Search');

% store the image
saveas(f,'PA5OutputFig/elapsed_time_search_method.png');