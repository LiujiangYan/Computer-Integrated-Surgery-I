function octree = construct_octree_cell...
    (upper_bound, lower_bound, parent_node, center_of_triangle, index_of_triangles)
    
    '1'
    % mid_point;
    mid_point = (upper_bound + lower_bound)/2;
    octree{1} = {mid_point};
    % upper_bound;
    octree{2} = {upper_bound};
    % lower_bound;
    octree{3} = {lower_bound};
    % parent_node;
    octree{4} = {parent_node};

    if size(center_of_triangle, 1) > 20
        % center_of_triangle;
        octree{5} = {};
        % index_of_triangles;
        octree{6} = {};
        for i=[0,1] %x
            for j=[0,1] %y
                for k=[0,1] %z
                    lower(1) = lower_bound(1) + i*(mid_point(1)-lower_bound(1));
                    upper(1) = mid_point(1) + i*(upper_bound(1)-mid_point(1));
                    
                    lower(2) = lower_bound(2) + j*(mid_point(2)-lower_bound(2));
                    upper(2) = mid_point(2) + j*(upper_bound(2)-mid_point(2));
                    
                    lower(3) = lower_bound(3) + k*(mid_point(3)-lower_bound(3));
                    upper(3) = mid_point(3) + k*(upper_bound(3)-mid_point(3));
                
                sub_centers = [];
                sub_index = [];
                for n=1:size(center_of_triangle, 1)
                    if sum(center_of_triangle(n,:) >= lower) == 3 &&...
                       sum(center_of_triangle(n,:) <= upper) == 3
                        sub_centers = [sub_centers; center_of_triangle(n,:)];
                        sub_index = [sub_index; index_of_triangles(n)];
                    end
                end
                % child
                octree{7}(i+1, j+1, k+1) = ... 
                    construct_octree(lower, upper, octree, sub_centers, sub_index);
                end
            end
        end
    else
        % child
        % center_of_triangle;
        octree{5} = {center_of_triangle};
        % index_of_triangles;
        octree{6} = {index_of_triangles};
        octree{7} = {};
    end

end