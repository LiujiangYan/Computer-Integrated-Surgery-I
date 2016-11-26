function [closest_point_in_mesh, triangle_index, sum_of_triangles_visited] = ...
    linear_search_bounding_spheres(s, triangle_set, center, radius)
    
    % linear search by bounding sphere
    bound = inf;
    sum_of_triangles_visited = 0;
    % iterate each triangle
    for index = 1:size(triangle_set,1)
        % if the distance from the point to the nearest point in sphere
        % larger than current bound, skip
        % else find the closest point
        if norm(center(index, :)' - s) - radius(index) < bound
            cur_closest_point = find_closest_point_in_triangle...
                (s, triangle_set(index,:));
            sum_of_triangles_visited = sum_of_triangles_visited + 1;
            % if smaller than current bound, update
            if norm(cur_closest_point - s) < bound
                closest_point_in_mesh = cur_closest_point;
                bound = norm(cur_closest_point - s);
                triangle_index = index;
            end
        end
    end 
    
end