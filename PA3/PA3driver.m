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

mesh_filepath = 'PA234 - Student Data/Problem3MeshFile.sur';
triangle_set = parseMesh(mesh_filepath);

%% get the bounding sphere, boxes, octree for triangle set 
% radius and center for each bounding triangle
[radius, center_of_triangle] = radius_center_of_sphere(triangle_set);
% lower and upper bound for each bounding box
[triangle_box_lower, triangle_box_upper] = bound_of_box(triangle_set);
% lower and upper bound for the whole triangle set
lower_bound = min(triangle_box_lower, [], 1);
upper_bound = max(triangle_box_upper, [], 1);

index_of_triangles = (1:size(center_of_triangle, 1))';
% build tree
octree = octree_object...
    (upper_bound, lower_bound, center_of_triangle, index_of_triangles);
% enlarge the bound
octree.enlarge_bound(triangle_set);

%% iterative closest point process
for char = ['A':'H','J']
    % read the samples' information
    char
    if ismember(char, 'A':'F')
        sample_filepath = strcat('PA234 - Student Data/PA3-', char, '-Debug-SampleReadingsTest.txt');
    else
        sample_filepath = strcat('PA234 - Student Data/PA3-', char, '-Unknown-SampleReadingsTest.txt');
    end
    [num_samples, A_set, B_set] = parseSample(sample_filepath, num_a, num_b);
    
    % registration
    % [d_set, c_set, error_set] = compute_sample_points...
    %     (num_samples, A_set, B_set, a, b, a_tip, triangle_set);
    output = zeros(num_samples, 7);

    for i=1:num_samples
        A = A_set(:,:,i);
        B = B_set(:,:,i);
        FA = registration(A,a);
        FB = registration(B,b);
        d = FB\FA*[a_tip';1];

        % find the cloest point in mesh
        Freg = eye(4);
        s = Freg*d;
        s = s(1:3);
        d = d(1:3);
        
        [c, triangle_index] = linear_search_brute_force(s, triangle_set);
        
        % bounding sphere
%         [c_sphere, triangle_index_sphere, sphere_triangles_visited] = ...
%             linear_search_bounding_spheres(s, triangle_set, center_of_triangle, radius);
%         
        % octree
%         bound = inf;
%         closest_point = [1000, 1000, 1000];
%         point_index = 0;
%         triangle_visited = 0;
%         [c_octree, update_bound, update_index, update_triangle_visited] = octree_search...
%             (s, octree, triangle_set, bound, closest_point, point_index, triangle_visited);
        
        % bounding box
        % [c_box, triangle_index_box, box_triangles_visited] = ...
        %     linear_search_bounding_boxes(s, triangle_set, triangle_box_lower, triangle_box_upper);
       
        % error = norm(c_box - c_sphere);

        error = norm(s-c);
        output(i,:) = [d',c',error];
    end
    
    csvwrite(strcat('Output_data/solved-PA3-',char,'-output.txt'), output);
end