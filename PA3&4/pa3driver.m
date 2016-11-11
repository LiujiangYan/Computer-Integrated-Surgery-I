clear;
clc;
format compact;

addpath('PA234 - Student Data/');
addpath('parse/');

body_A_filepath = 'PA234 - Student Data/Problem3-BodyA.txt';
[num_a, a, a_tip] = parseBody(body_A_filepath);

body_B_filepath = 'PA234 - Student Data/Problem3-BodyB.txt';
[num_b, b, b_tip] = parseBody(body_B_filepath);

mesh_filepath = 'PA234 - Student Data/Problem3MeshFile.sur';
triangle_set = parseMesh(mesh_filepath);

% radius and center for each bounding triangle
[radius, center] = radius_center_of_sphere(triangle_set);
% lower and upper bound for each bounding box
[triangle_box_lower, triangle_box_upper] = bound_of_box(triangle_set);
% lower and upper bound for the whole triangle set
box_lower = min(triangle_box_lower, [], 1);
box_upper = max(triangle_box_upper, [], 1);

for char = 'A':'F'
    sample_filepath = 'PA234 - Student Data/PA3-A-Debug-SampleReadingsTest.txt';
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
        
        % brute force
        tic
        [c_brute, triangle_index_brute] = linear_search_brute_force...
            (s, triangle_set);
        toc
        % bounding sphere
        tic
        [c_sphere, triangle_index_sphere] = linear_search_bounding_spheres...
            (s, triangle_set, center, radius);
        toc
        % bounding box
        tic
        [c_box, triangle_index_box] = linear_search_bounding_boxes...
            (s, triangle_set, triangle_box_lower, triangle_box_upper);
        toc        
       
        % error = norm(s-c);
        % output(i,:) = [d',c',error];
    end
    
    % csvwrite(strcat('solvedoutput/solved-PA3-',char,'-output.csv'), output);
end