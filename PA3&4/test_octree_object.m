center_of_triangle = [];
for i=0:5
    for j=0:5
        for k=0:5
            center_of_triangle = [center_of_triangle; [i,j,k]];
        end
    end
end


index_of_triangles = (1:size(center_of_triangle, 1))';
lower_bound = min(center_of_triangle, [], 1);
upper_bound = max(center_of_triangle, [], 1);

octree = octree_object...
    (upper_bound, lower_bound, center_of_triangle, index_of_triangles);


for i=1:size(center_of_triangle,1)
    x_offset = center_of_triangle(i,:) + [0.1 0 0];
    y_offset = center_of_triangle(i,:) + [0 0.1 0];
    triangle_set(i,:) = [center_of_triangle(i,:), x_offset, y_offset];
end
bound = inf;
closest_point = [10,10,10];
s = [5.1; 0.1; 5.1];
[update_closest_point, update_bound] = ...
    octree_search(s, octree, triangle_set, bound, closest_point);
    