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
[radius, center] = radius_center_of_sphere(triangle_set);
[triangle_box_lower, triangle_box_upper] = bound_of_box(triangle_set);

for char = 'A':'B'
    
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
    error_sum = inf;
    while error_sum > 0.01 && iteration < max_iteration
        iteration = iteration + 1;
        disp(iteration);

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
            [c, triangle_index_box] = linear_search_bounding_boxes...
                (s, triangle_set, triangle_box_lower, triangle_box_upper);

            % pick up
            s_set(i,:) = s';
            c_set(i,:) = c';
            error_set(i,:) = norm(s-c);
            
            % output
            output(i,:) = [s', c', norm(s-c)];
        end
    
        error_sum = norm(error_set);
        delta_Freg = registration(c_set, s_set);
        Freg = delta_Freg*Freg;
        
    end
    
    csvwrite(strcat('solvedoutput/solved-PA4-',char,'-output.csv'), output);
end