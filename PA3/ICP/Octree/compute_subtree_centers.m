function [sub_centers, sub_index] = compute_subtree_centers...
    (upper_bound, lower_bound, center_of_triangle, index_of_triangles)
    
    % given the boundary of box
    % return the centers/index that belong to it
    log_vector = ones(size(center_of_triangle,1), 1);
    for i=1:3
        lower_log_vector = center_of_triangle(:,i) >= lower_bound(i);
        upper_log_vector = center_of_triangle(:,i) <= upper_bound(i);
        log_vector = log_vector & lower_log_vector;
        log_vector = log_vector & upper_log_vector;
    end
    
    sub_centers = center_of_triangle(log_vector,:);
    sub_index = index_of_triangles(log_vector);
end