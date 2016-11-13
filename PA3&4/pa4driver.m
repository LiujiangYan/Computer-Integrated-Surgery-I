clear;
clc;
format compact;
    
addpath('PA234 - Student Data/');
addpath('parse/');

body_A_filepath = strcat('PA234 - Student Data/Problem4-BodyA.txt');
[num_a, a, a_tip] = parseBody(body_A_filepath);

body_B_filepath = 'PA234 - Student Data/Problem4-BodyB.txt';
[num_b, b, b_tip] = parseBody(body_B_filepath);

mesh_filepath = 'PA234 - Student Data/Problem4MeshFile.sur';
triangle_set = parseMesh(mesh_filepath);

% radius and center for each bounding triangle
[radius, center_of_triangle] = radius_center_of_sphere(triangle_set);
% lower and upper bound for each bounding box
[triangle_box_lower, triangle_box_upper] = bound_of_box(triangle_set);
% lower and upper bound for the whole triangle set
lower_bound = min(triangle_box_lower, [], 1);
upper_bound = max(triangle_box_upper, [], 1);

index_of_triangles = (1:size(center_of_triangle, 1))';
octree = octree_object...
    (upper_bound, lower_bound, center_of_triangle, index_of_triangles);
octree.enlarge_bound(triangle_set);

for char = 'E':'F'
    
    sample_filepath = strcat('PA234 - Student Data/PA4-',char,'-Debug-SampleReadingsTest.txt');
    [num_samples, A_set, B_set] = parseSample(sample_filepath, num_a, num_b);

    s_set = zeros(num_samples, 3);
    c_set = zeros(num_samples, 3);
    error_set = zeros(num_samples, 1);
    output = zeros(num_samples, 7);

    % initial guess
    Freg = eye(4);
    
    max_iteration = 100;
    iteration = 0;
    error_max = inf;
    while error_max > 0.1 && iteration < max_iteration
        tic
        % disp(char);
        % disp(error_max);
        iteration = iteration + 1;
        % disp(iteration);

        for i=1:num_samples
            A = A_set(:,:,i);
            B = B_set(:,:,i);
            FA = registration(A,a);
            FB = registration(B,b);
            d = FB\FA*[a_tip';1];

            % find the cloest point in mesh    
            s = Freg*d;
            s = s(1:3);
            d = d(1:3);
            
            % bounding sphere linear search
            [c_sphere, triangle_index_sphere] = linear_search_bounding_spheres...
                (s, triangle_set, center_of_triangle, radius);            
            
            %octree search
            
            bound = inf;
            closest_point = [0, 0, 0];
            point_index = 0;
            [c_octree, update_bound, update_index] = octree_search...
                (s, octree, triangle_set, bound, closest_point, point_index);
              
            if norm(c_octree-c_sphere)>0
                norm(c_octree-c_sphere)
            end
            
            c = c_octree;
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
        toc
    end
    
    csvwrite(strcat('solvedoutput/solved-PA4-',char,'-output.txt'), output);
end