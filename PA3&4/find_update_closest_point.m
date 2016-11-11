function [update_closest_point, update_bound] = ...
    find_update_closest_point(s, triangle, bound, closest_point)

    current_closest_point = find_closest_point_in_triangle(s, triangle);
    if norm(current_closest_point - s) < bound
        update_bound = norm(current_closest_point - s);
        update_closest_point = current_closest_point;
    else
        update_bound = bound;
        update_closest_point = closest_point;
    end
end