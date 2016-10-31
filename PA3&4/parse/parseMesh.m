function [N_vertices, P_vertices, N_tri, I_tri] = parseMesh(filepath)
    Matrix = dlmread(filepath);
    N_vertices = Matrix(1,1);
    P_vertices = Matrix(2:N_vertices+1, 1:3);
    N_tri = Matrix(N_vertices+2);
    I_tri = Matrix(N_vertices+3:end,:);
end