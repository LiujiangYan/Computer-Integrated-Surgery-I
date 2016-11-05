function [d_set, c_set, error_set] = compute_sample_points...
    (num_samples, A_set, B_set, a, b, a_tip, triangle_set)
    
    d_set = zeros(num_samples, 3);
    c_set = zeros(num_samples, 3);
    error_set = zeros(num_samples, 1);
    
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
        c = find_closest_point_in_mesh(s, triangle_set);
        error = norm(s-c);
        
        % pick up
        d_set(i,:) = d';
        c_set(i,:) = c';
        error_set(i,:) = error;
    end
    
end