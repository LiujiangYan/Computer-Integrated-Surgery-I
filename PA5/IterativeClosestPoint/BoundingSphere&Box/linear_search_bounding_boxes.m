function [closest_point_in_mesh, triangle_index, sum_of_triangles_visited] = linear_search_bounding_boxes...
    (s, triangle_set, L_box, U_box)
    
    % linear search by bounding box
    bound = inf;
    sum_of_triangles_visited = 0;
    % iterate each triangle
    for index=1:size(triangle_set, 1)
        % if the boundary is beyond current bound, skip
        % else find the closest point
        if (L_box(index,1)-bound) < s(1) && s(1) < (U_box(index,1)+bound) && ...
                (L_box(index,2)-bound) < s(2) && s(2) < (U_box(index,2)+bound) && ...
                (L_box(index,3)-bound) < s(3) && s(3) < (U_box(index,3)+bound)
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