function closest_point_in_mesh = find_closest_point_in_mesh_brute_force(s, triangle_set)
    
    closest_point_in_mesh = zeros(3,1);
    minimum_distance = inf;
    
    for index = 1:size(triangle_set,1)
        triangle = triangle_set(index,:);
        cloest_point_in_triangle = find_closest_point_in_triangle(s, triangle);
        distance = norm(s-cloest_point_in_triangle);
        if minimum_distance > distance
            minimum_distance = distance;
            closest_point_in_mesh = cloest_point_in_triangle;
        end
    end
    
end