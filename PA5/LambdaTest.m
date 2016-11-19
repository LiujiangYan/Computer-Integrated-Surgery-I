addpath('PA234 - Student Data/');
file_path = 'PA5-A-Debug-Output.txt';

% vertices index of corresponding triangles to each closest point
t_index = triangle_vertices_index(c_in_which_triangle,1)+1;
u_index = triangle_vertices_index(c_in_which_triangle,2)+1;
v_index = triangle_vertices_index(c_in_which_triangle,3)+1;

update_Lambda = zeros(6,1);
Lambda_iteration = 0;
current_Lambda = inf(6,1);
while norm(update_Lambda - current_Lambda) > 0.1 && Lambda_iteration < 100

    current_Lambda = update_Lambda;
    Lambda_iteration = Lambda_iteration + 1;
    
    triangle_set = deform_triangle_set...
        (Mode, current_Lambda, triangle_vertices_index);
    for i=1:num_samples
        m_t(i,:) = triangle_set(c_in_which_triangle(i), 1:3);
        m_u(i,:) = triangle_set(c_in_which_triangle(i), 4:6);
        m_v(i,:) = triangle_set(c_in_which_triangle(i), 7:9);

        m = [[m_t(i,:),1]',[m_u(i,:),1]',[m_v(i,:),1]'];
        c = [c_set(i,:),1]';
        para(i,:) = linsolve(m,c);
    end

    S = [];
    Q = [];
    for i=1:num_samples
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
end