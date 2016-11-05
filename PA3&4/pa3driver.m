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
        c = find_closest_point_in_mesh_brute_force(s, triangle_set);
        error = norm(s-c);
        
        % store
        output(i,:) = [d',c',error];
    end
    
    csvwrite(strcat('solvedoutput/solved-PA3-',char,'-output.csv'), output);
end