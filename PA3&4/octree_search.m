function [update_closest_point, update_bound] = ...
    octree_search(s, octree, triangle_set, bound, closest_point)
    
    octree
    
    if (s(1) > octree.upper_bound(1)+bound) ||...
            (s(1) < octree.lower_bound(1)-bound)
        '1'
        update_closest_point = closest_point;
        update_bound = bound;
        return;
        
    elseif (s(2) > octree.upper_bound(2)+bound) ||...
            (s(2) < octree.lower_bound(2)-bound)
        '2'
        update_closest_point = closest_point;
        update_bound = bound;
        return;
        
    elseif (s(3) > octree.upper_bound(3)+bound) ||...
            (s(3) < octree.lower_bound(3)-bound)
        '3'
        update_closest_point = closest_point;
        update_bound = bound;
        return;
        
    elseif ~isempty(octree.child) 
        '4'
        for i=[1,2]
            for j=[1,2]
                for k=[1,2]
                    if size(octree.child(i,j,k).points, 1)>0
                        [update_closest_point, update_bound] = ...
                            octree_search(s, octree.child(i,j,k), ...
                                triangle_set, bound, closest_point);
                    else
                        update_closest_point = closest_point;
                        update_bound = bound;
                    end
                end
            end
        end
        
    else
        '5'
        if size(octree.points, 1) > 0
            'have points'
            for i=1:size(octree.index, 1)
                triangle = triangle_set(octree.index(i), :);
                [update_closest_point, update_bound] = find_update_closest_point...
                    (s, triangle, bound, closest_point);
                bound = update_bound;
            end
        else
            update_closest_point = closest_point;
            update_bound = bound;
        end
    end
    
    bound
    update_bound
end