function [update_closest_point, update_bound, update_index, update_triangle_visited] = ...
    octree_search(s, octree, triangle_set, bound, closest_point, point_index, triangle_visited)
    
    % parameter lists for octree object
    % split_point
    % upper
    % lower
    % centers
    % index
    % child
    % depth
    
    % if the distance from given point to the boundary of box
    % is larger than current bound
    % skip!
    if (s(1) > octree.upper(1)+bound) ||...
            (s(1) < octree.lower(1)-bound)
        % keep the original information
        update_closest_point = closest_point;
        update_bound = bound;
        update_index = point_index;
        update_triangle_visited = triangle_visited;
        return;
        
    elseif (s(2) > octree.upper(2)+bound) ||...
            (s(2) < octree.lower(2)-bound)
        % keep the original information
        update_closest_point = closest_point;
        update_bound = bound;
        update_index = point_index;
        update_triangle_visited = triangle_visited;
        return;
        
    elseif (s(3) > octree.upper(3)+bound) ||...
            (s(3) < octree.lower(3)-bound)
        % keep the original information
        update_closest_point = closest_point;
        update_bound = bound;
        update_index = point_index;
        update_triangle_visited = triangle_visited;
        return;
    
    % depth first search
    % if this subtree has child, keeping recursion
    elseif ~isempty(octree.child)
        for i=1:size(octree.child,2)
            child = octree.child{i};
            [update_closest_point, update_bound, update_index, update_triangle_visited] = ...
                octree_search(s, child, triangle_set, bound, closest_point, point_index, triangle_visited);
            
            % update the paratmeters
            bound = update_bound;
            closest_point = update_closest_point;
            point_index = update_index;
            triangle_visited = update_triangle_visited;
        end
        
    % else if this subtree does not have child
    % iterating each triangle and updating the bound and closet point
    else
        % record the number of visited triangles
        update_triangle_visited = triangle_visited  + size(octree.index, 1);
        for i=1:size(octree.index, 1)
            triangle = triangle_set(octree.index(i), :);
            cur_point_index = octree.index(i);
            [update_closest_point, update_bound, update_index] = find_update_closest_point...
                (s, triangle, bound, closest_point, cur_point_index, point_index);
            
            % update the paratmeters
            bound = update_bound;
            closest_point = update_closest_point;
            point_index = update_index;
        end        
    end
end