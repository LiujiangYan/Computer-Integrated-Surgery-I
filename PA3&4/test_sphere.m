% center_of_triangle = [0 0 0;1 1 1;2 2 2;3 3 3;4 4 4];
center_of_triangle = [];
for i=1:10
    for j=1:10
        for k=1
            center_of_triangle = [center_of_triangle; [i,j,k]];
        end
    end
end

index_of_triangles = (1:size(center_of_triangle, 1));
parent_node = struct([]);
lower_bound = min(center_of_triangle, [], 1);
upper_bound = max(center_of_triangle, [], 1);

octree = construct_octree_cell...
    (upper_bound, lower_bound, parent_node, center_of_triangle, index_of_triangles);

% triangle_set = [0 0 0 0.1 0 0 0 0.1 0;
%                 1 1 1 1.1 1 1 1 1.1 1
%                 2 2 2 2.1 2 2 2 2.1 2
%                 3 3 3 3.1 3 3 3 3.1 3
%                 4 4 4 4.1 4 4 4 4.1 4];
% bound = inf;
% closest_point = [0, 0, 0];
% s = [-1 -1 -1]';
% [update_closest_point, update_bound] = ...
%     octree_search(s, octree, triangle_set, bound, closest_point);