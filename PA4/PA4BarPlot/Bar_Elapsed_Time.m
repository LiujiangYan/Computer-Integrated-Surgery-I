% get the figure handle
f = figure;

% elapsed time for each method
elapsed_time_box = [1.460306 39.673639 75.132291 64.093246 120.635146 110.777648 57.140650 63.791903 82.458022];
elapsed_time_sphere = [0.990574 25.529654 52.073329 43.266838 77.094668 64.687723 33.358215 37.570704 46.172744];
elapsed_time_octree = [0.922707 20.704475 43.528195 38.502979 62.694150 53.275849 31.164352 31.789115 41.856239];
elapsed_time_octree_parallel = [0.657100 9.132671 18.517580 15.745998 27.388155 21.797327 12.742534 14.095144 17.670262];
elapsed_time = [elapsed_time_box', elapsed_time_sphere', elapsed_time_octree', elapsed_time_octree_parallel'];

elapsed_time_kdtree_parallel = [0.671334 9.346859 17.835189 16.405274 26.847305 21.902070 13.347253 13.809111 17.234014];
elapsed_time_balanced_octree_parallel = [0.667803 8.943853 17.294256 14.647966 25.525726 20.990046 12.088673 13.121335 16.652906];
elapsed_time_tree = [elapsed_time_octree_parallel' elapsed_time_kdtree_parallel' elapsed_time_balanced_octree_parallel'];
%% linear search against tree search
% draw bar
b = bar(elapsed_time);
% highlight the minimun elapsed time search method
b(4).LineWidth = 2;
b(4).EdgeColor = 'red';

% title
title('elapsed time for three search methods');
% x-axis label
xlabel('Data Frame');
% y-axis label
ylabel('Elapsed Time'); 
% legend
legend('bounding box','bounding sphere','octree','octree (parallel)');

% store the image
saveas(f,'PA4OutputFig/elapsedtime/elapsed_time.png');

%% kd tree against octree
% draw bar
b = bar(elapsed_time_tree);
% highlight the minimun elapsed time search method
b(3).LineWidth = 2;
b(3).EdgeColor = 'red';

% title
title('elapsed time for tree search');
% x-axis label
xlabel('Data Frame');
% y-axis label
ylabel('Elapsed Time'); 
% legend
legend('octree', 'kdtree', 'balanced octree');

% store the image
saveas(f,'PA4OutputFig/elapsedtime/elapsed_time_tree.png');