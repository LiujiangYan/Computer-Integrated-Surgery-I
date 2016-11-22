%% initialization
clear;
clc;
format compact;
diary 'bound_box_log.txt';

%% addpath
addpath(genpath('ICP/'));
addpath('PA234 - Student Data/');
addpath('Parse/');

%% reading body information
body_A_filepath = strcat('PA234 - Student Data/Problem4-BodyA.txt');
[num_a, a, a_tip] = parseBody(body_A_filepath);

body_B_filepath = 'PA234 - Student Data/Problem4-BodyB.txt';
[num_b, b, b_tip] = parseBody(body_B_filepath);

mesh_filepath = 'PA234 - Student Data/Problem4MeshFile.sur';
triangle_set = parseMesh(mesh_filepath);

%% bounding box sphere and octree for triangle set
% radius and center for each bounding triangle
[radius, center_of_triangle] = radius_center_of_sphere(triangle_set);
% lower and upper bound for each bounding box
[triangle_box_lower, triangle_box_upper] = bound_of_box(triangle_set);
% lower and upper bound for the whole triangle set
lower_bound = min(triangle_box_lower, [], 1);
upper_bound = max(triangle_box_upper, [], 1);
% orctree
index_of_triangles = (1:size(center_of_triangle, 1))';
octree = octree_object...
    (upper_bound, lower_bound, center_of_triangle, index_of_triangles);
octree.enlarge_bound(triangle_set);

%% iterative closest point process
for char = ['A':'H','J']
    tic
    disp(strcat('data set:',char,' started'));
    
    if ismember(char, 'A':'F')
        sample_filepath = strcat('PA234 - Student Data/PA4-',char,'-Debug-SampleReadingsTest.txt');
    else
        sample_filepath = strcat('PA234 - Student Data/PA4-',char,'-Unknown-SampleReadingsTest.txt');
    end
    [num_samples, A_set, B_set] = parseSample(sample_filepath, num_a, num_b);

    % apply composition rule for sample points
    d_set = [];
    for i=1:num_samples
        A = A_set(:,:,i);
        B = B_set(:,:,i);
        [FA, residual_FA] = registration(A,a);
        [FB, residual_FB] = registration(B,b);
        d_set(:,i) = FB\FA*[a_tip';1];
    end
    disp(strcat('registration residual error FA:',num2str(residual_FA)));
    disp(strcat('registration residual error FB:',num2str(residual_FB)));
    
    % some preallocation
    s_set = zeros(num_samples, 3);
    c_set = zeros(num_samples, 3);
    error_set = zeros(num_samples, 1);
    output = zeros(num_samples, 7);
    
    % initial guess
    Freg = eye(4);
    delta_Freg = inf(4);
    
    max_iteration = 100;
    iteration = 0;
    error_max = inf;
    
    % draw the real time plot
    f = figure; 
    hold on;
    title(strcat('the real time plot of residual error of data set:',char));
    % x-axis label
    xlabel('ICP iteration counts');
    % y-axis label
    ylabel(' maximum points pair error'); 
    
    % combine two stopping criterias
    while error_max > 0.1 && iteration < max_iteration &&...
            norm(delta_Freg-eye(4)) > 0.001
        iteration = iteration + 1;
        
        for i=1:num_samples
            % compute the sample point by current registration
            s = Freg*d_set(:,i);
            s = s(1:3);
            
            % bounding sphere linear search
            % [c_sphere, triangle_index_sphere] = linear_search_bounding_spheres...
            %     (s, triangle_set, center_of_triangle, radius);            
            
            % bounding box linear search
            [c_box, triangle_index_box] = linear_search_bounding_boxes...
                (s, triangle_set, triangle_box_lower, triangle_box_upper);
            
            % find the cloest point in mesh octree search
            % [c_octree, triangle_index_octree]  = octree_main_search...
            %     (s, octree, triangle_set, center_of_triangle, radius);
            
            c = c_box;
            % pick up
            s_set(i,:) = s';
            c_set(i,:) = c';
            error_set(i) = norm(s-c);
            
            % output
            output(i,:) = [s', c', norm(s-c)];
        end
    
        delta_Freg = registration(c_set, s_set);
        Freg = delta_Freg*Freg;
        
        error_max = max(error_set);
        
        % update the real time plot figure
        plot(iteration, error_max, 'r*','MarkerSize',6);
        drawnow;
    end

    disp(strcat('data set:',char,' finished'));
    disp(strcat('experienced iterations:',num2str(iteration)));
    disp(strcat('final maximum points pair error:', num2str(error_max)));
    toc
    disp('--------------------------------------------------------------');
    
    % write the data to csv file
    % csvwrite(strcat('PA4OutputData/solved-PA4-',char,'-output.txt'), output);
    
    % store and clear the figure
    pause(1);
    % saveas(f,strcat('PA4OutputFig/errorplot',char,'.png'));
    close all;
end
diary off;