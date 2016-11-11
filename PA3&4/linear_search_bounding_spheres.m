function [closest_point_in_mesh, triangle_index] = linear_search_bounding_spheres...
    (s, triangle_set, center, radius)
    
    bound = inf;
    for index = 1:size(triangle_set,1)
        if norm(center(index, :)' - s) - radius(index) < bound
            cur_closest_point = find_closest_point_in_triangle...
                (s, triangle_set(index,:));
            if norm(cur_closest_point - s) < bound
                closest_point_in_mesh = cur_closest_point;
                bound = norm(cur_closest_point - s);
                triangle_index = index;
            end
        end
    end 
    
end