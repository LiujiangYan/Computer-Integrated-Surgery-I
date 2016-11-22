function [c_octree, triangle_index_octree] = octree_main_search...
    (s, octree, triangle_set, center_of_triangle, radius)
   
    % some initial parameters
    bound = inf;
    closest_point = [0, 0, 0];
    point_index = 0;
    
    % octree depth first search
    [c_octree, ~, triangle_index_octree] = octree_search...
        (s, octree, triangle_set, bound, closest_point, point_index, center_of_triangle, radius);
            
end