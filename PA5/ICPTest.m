% test update sphere

% mesh - triangle set and corresponding vertices index
Lambda = [15.5607   26.0878   23.9724  132.5250   51.5214 -137.8745]';

error_sc = inf;
triangle_set = deform_triangle_set...
        (Mode, Lambda, triangle_vertices_index);
[radius, center_of_triangle] = radius_center_of_sphere(triangle_set);

Freg = eye(4);    
ICP_iteration = 0;
while max(error_sc) > 0.1 && ICP_iteration < 100
    max(error_sc)
    ICP_iteration = ICP_iteration + 1;
    for i=1:num_samples
        s = Freg*d_set(:,i);
        s = s(1:3);

        % bounding sphere
        [c, triangle_index] = ...
            linear_search_bounding_spheres...
                (s, triangle_set, center_of_triangle, radius);

        s_set(i,:) = s';
        c_set(i,:) = c';
        error_sc = max(s_set-c_set);
        c_in_which_triangle(i) = triangle_index;
    end
    delta_Freg = registration(c_set, s_set);
    Freg = delta_Freg*Freg;
end    