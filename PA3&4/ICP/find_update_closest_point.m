function [update_closest_point, update_bound, update_index] = ...
    find_update_closest_point(s, triangle, bound, closest_point, cur_point_index, point_index)
    
    % get the closest point in the certain given triangle
    current_closest_point = find_closest_point_in_triangle(s, triangle);
    
    % if the distance is smaller than current bound
    % update
    if norm(current_closest_point - s) < bound
        update_bound = norm(current_closest_point - s);
        update_closest_point = current_closest_point;
        update_index = cur_point_index;
        
    % else, keep the original information
    else
        update_bound = bound;
        update_closest_point = closest_point;
        update_index = point_index;
    end
    
end