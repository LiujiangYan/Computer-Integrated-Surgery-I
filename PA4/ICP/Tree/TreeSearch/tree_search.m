function [update_closest_point, update_bound, update_index] = ...
    tree_search(s, tree, triangle_set, bound, closest_point, point_index, center, radius)
    
    % needed parameter lists for tree object
    % upper
    % lower
    % centers
    % index
    % child
    
    % if the distance from given point to the boundary of box
    % is larger than current bound
    % skip!
    if (s(1) > tree.upper(1)+bound) ||...
            (s(1) < tree.lower(1)-bound)
        % keep the original information
        update_closest_point = closest_point;
        update_bound = bound;
        update_index = point_index;
        return;
        
    elseif (s(2) > tree.upper(2)+bound) ||...
            (s(2) < tree.lower(2)-bound)
        % keep the original information
        update_closest_point = closest_point;
        update_bound = bound;
        update_index = point_index;
        return;
        
    elseif (s(3) > tree.upper(3)+bound) ||...
            (s(3) < tree.lower(3)-bound)
        % keep the original information
        update_closest_point = closest_point;
        update_bound = bound;
        update_index = point_index;
        return;
    
    % depth first search
    % if this subtree has child, keeping recursion
    elseif ~isempty(tree.child)
        for i=1:size(tree.child,2)
            child = tree.child{i};
            [closest_point, bound, point_index] = tree_search...
                (s, child, triangle_set, bound, closest_point, point_index, center, radius);
        end
        % update the paratmeters
        update_bound = bound;
        update_index = point_index;
        update_closest_point = closest_point;
        
    % else if this subtree does not have child
    % iterating each triangle and updating the bound and closet point
    else 
        for index = 1:size(tree.index,1)
            % if the distance from the point to the nearest point in sphere
            % larger than current bound, skip
            % else find the closest point
            cur_triangle_index = tree.index(index);
            if norm(center(cur_triangle_index, :)' - s) - radius(cur_triangle_index) < bound
                cur_closest_point = find_closest_point_in_triangle...
                    (s, triangle_set(cur_triangle_index,:));
                % if smaller than current bound, update
                if norm(cur_closest_point - s) < bound
                    closest_point = cur_closest_point;
                    bound = norm(cur_closest_point - s);
                    point_index = cur_triangle_index;
                else
                end
            end
        end 
        % update the paratmeters
        update_bound = bound;
        update_index = point_index;
        update_closest_point = closest_point;
    end
end