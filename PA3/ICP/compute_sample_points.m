function [d_set, c_set, error_set] = compute_sample_points...
    (num_samples, A_set, B_set, a, b, a_tip, triangle_set, type)
    
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
        
        switch type
            case 'brute'
                [c, ~] = linear_search_brute_force(s, triangle_set);
            case 'sphere'
                [c, ~, ~] = linear_search_bounding_spheres...
                    (s, triangle_set, center_of_triangle, radius);
            case 'box'
                [c, ~, ~] =  linear_search_bounding_boxes...
                   (s, triangle_set, triangle_box_lower, triangle_box_upper);
            case 'octree'
        end
        
        error = norm(s-c);
        
        % pick up
        d_set(i,:) = d';
        c_set(i,:) = c';
        error_set(i,:) = error;
    end
    
end