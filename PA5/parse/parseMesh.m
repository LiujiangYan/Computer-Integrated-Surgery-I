function [triangle_set, triangle_vertices_index] = parseMesh(filepath)
    
    Matrix = dlmread(filepath);
    
    N_vertices = Matrix(1,1);
    P_vertices = Matrix(2:N_vertices+1, 1:3);
    N_tri = Matrix(N_vertices+2);
    I_tri = Matrix(N_vertices+3:end,:);
    
    triangle_set = zeros(N_tri, 9);
    for i=1:N_tri
        index = I_tri(i,:);
        triangle_set(i,:) = [P_vertices(index(1)+1,:),...
                             P_vertices(index(2)+1,:),...
                             P_vertices(index(3)+1,:)];
    end
    triangle_vertices_index = I_tri(:,1:3);
end