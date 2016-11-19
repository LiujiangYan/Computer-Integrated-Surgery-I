function [triangle_set] = ...
    deform_triangle_set(Mode, Lambda, triangle_vertices_index)
    
    % update the vertices set by considering current deformation
    vertices_set = Mode(:,:,1);
    for i=2:size(Mode,3)
        vertices_set = vertices_set + Lambda(i-1)*Mode(:,:,i);
    end
    
    % update the triangle set
    for i=1:size(triangle_vertices_index,1)
        triangle_set(i,:) = [vertices_set(triangle_vertices_index(i,1)+1,:),...
                             vertices_set(triangle_vertices_index(i,2)+1,:),...
                             vertices_set(triangle_vertices_index(i,3)+1,:)];
    end
end