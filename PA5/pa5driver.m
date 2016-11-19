%% initialization
clc;
clear;
format compact;

%% addpath
addpath('PA234 - Student Data/');
addpath('parse/');
addpath(genpath('ICP/'));

%% read Body A B, mesh and mode files
% body A
body_A_filepath = 'PA234 - Student Data/Problem5-BodyA.txt';
[num_a, a, a_tip] = parseBody(body_A_filepath);
% body B
body_B_filepath = 'PA234 - Student Data/Problem5-BodyB.txt';
[num_b, b, b_tip] = parseBody(body_B_filepath);
% mesh - triangle set and corresponding vertices index
mesh_filepath = 'PA234 - Student Data/Problem5MeshFile.sur';
[triangle_set, triangle_vertices_index] = parseMesh(mesh_filepath);
% mode from 0 to 6
mode_filepath = 'PA234 - Student Data/Problem5Modes.txt';
Nvertices = 1568;
Nmodes = 7;
[Mode] = parseMode(mode_filepath, Nvertices, Nmodes);

%% simple deformable registration - extend the rigid ICP
char = 'B';
sample_filepath = strcat('PA234 - Student Data/PA5-', char,...
        '-Debug-SampleReadingsTest.txt');
[num_samples, A_set, B_set] = parseSample(sample_filepath, num_a, num_b);

% some allo
s_set = inf(num_samples, 3);
c_set = zeros(num_samples, 3);
c_in_which_triangle = inf(num_samples, 1);
output = inf(num_samples, 7);

% get the sample points' position d
for i=1:num_samples
    A = A_set(:,:,i);
    B = B_set(:,:,i);
    % registration
    FA = registration(A,a);
    FB = registration(B,b);
    % d in homogeneous form
    d_set(:,i) = FB\FA*[a_tip';1];
end

% initial guess for registration matrix
Freg = inf(4);
updated_Freg = eye(4);
% initial guess for lambda
num_modes = 6;
Lambda = inf(6,1);
update_Lambda = zeros(6,1);

deform_ICP_iteration = 0;
while norm(Freg - updated_Freg)> 0.01 || norm(Lambda - update_Lambda)>0.01
    % add the iteration
    deform_ICP_iterationion = deform_ICP_iteration + 1;
    % deform the mesh firstly
    triangle_set = deform_triangle_set...
            (Mode, update_Lambda, triangle_vertices_index);
    [radius, center_of_triangle] = radius_center_of_sphere(triangle_set);
    
    % ICP
    disp('update Freg - ICP');
    
    Freg = updated_Freg;    
    ICP_iteration = 0;
    while sum(max(s_set - c_set)) > 0.1 && ICP_iteration < 10
        ICP_iteration = ICP_iteration + 1;
        for i=1:num_samples
            s = updated_Freg*d_set(:,i);
            s = s(1:3);
            
            % bounding sphere
            [c, triangle_index] = ...
                linear_search_bounding_spheres...
                    (s, triangle_set, center_of_triangle, radius);

            s_set(i,:) = s';
            c_set(i,:) = c';
            c_in_which_triangle(i) = triangle_index;
        end
        delta_Freg = registration(c_set, s_set);
        updated_Freg = delta_Freg*updated_Freg;
    end    

    % deformable registration
    disp('update Lambda');
    
    % vertices index of corresponding triangles to each closest point
    t_index = triangle_vertices_index(c_in_which_triangle,1)+1;
    u_index = triangle_vertices_index(c_in_which_triangle,2)+1;
    v_index = triangle_vertices_index(c_in_which_triangle,3)+1;
            
    Lambda = update_Lambda;
    Lambda_iteration = 0;
    current_Lambda = inf(6,1);
    % while norm(update_Lambda - current_Lambda) > 1 && Lambda_iteration < 10
        
        current_Lambda = update_Lambda;
        Lambda_iteration = Lambda_iteration + 1;
        
        % update the triangle set by updated Lambda
        triangle_set = deform_triangle_set...
            (Mode, current_Lambda, triangle_vertices_index);
        
        % compute the coefficients of three vertices to the closest point
        for i=1:num_samples
            m_t(i,:) = triangle_set(c_in_which_triangle(i), 1:3);
            m_u(i,:) = triangle_set(c_in_which_triangle(i), 4:6);
            m_v(i,:) = triangle_set(c_in_which_triangle(i), 7:9);
            
            % linear system for a b c
            m = [[m_t(i,:),1]',[m_u(i,:),1]',[m_v(i,:),1]'];
            c = [c_set(i,:),1]';
            para(i,:) = linsolve(m,c);
        end

        S = [];
        Q = [];
        for i=1:num_samples
            % samples' position - mode 0
            m_t0 = Mode(t_index(i),:,1);
            m_u0 = Mode(u_index(i),:,1);
            m_v0 = Mode(v_index(i),:,1);
            qi0 = para(i,1)*m_t0 + para(i,2)*m_u0 + para(i,3)*m_v0;
            S = [S; s_set(i,:)'-qi0'];
            
            Q_row = [];
            for j=1:num_modes
                m_tj = Mode(t_index(i),:,j+1);
                m_uj = Mode(u_index(i),:,j+1);
                m_vj = Mode(v_index(i),:,j+1);
                qij =  para(i,1)*m_tj + para(i,2)*m_uj + para(i,3)*m_vj;
                Q_row = [Q_row, qij'];
            end
            Q = [Q; Q_row];
        end
        update_Lambda = linsolve(Q,S);
    % end
    update_Lambda
end