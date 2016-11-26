function [c_tree, triangle_index_tree] = tree_main_search...
    (s, tree, triangle_set, center_of_triangle, radius)
   
    % some initial parameters
    bound = inf;
    closest_point = [0, 0, 0];
    point_index = 0;
    
    % octree depth first search
    [c_tree, ~, triangle_index_tree] = tree_search...
        (s, tree, triangle_set, bound, closest_point, point_index, center_of_triangle, radius);
            
end