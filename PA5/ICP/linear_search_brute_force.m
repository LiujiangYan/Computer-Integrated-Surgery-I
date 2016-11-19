function [closest_point_in_mesh, triangle_index] = linear_search_brute_force(s, triangle_set)
    
    % linear search by brute force 
    closest_point_in_mesh = zeros(3,1);
    minimum_distance = inf;
    
    % loop each triangle and find the closest point
    % update if the distance is smaller than current bound
    for index = 1:size(triangle_set,1)
        triangle = triangle_set(index,:);
        closest_point_in_triangle = find_closest_point_in_triangle(s, triangle);
        distance = norm(s-closest_point_in_triangle);
        if minimum_distance > distance
            minimum_distance = distance;
            closest_point_in_mesh = closest_point_in_triangle;
            triangle_index = index;
        end
    end
    
end