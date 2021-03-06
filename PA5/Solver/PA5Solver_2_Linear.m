%% simple deformable registration - extend the rigid ICP
for char = ['A':'H','J','K']
    tic
    disp(strcat('data set:',char,' started'));
    
    % titles, xy labels, etc.
    figure(1);
    plot_figure_ICP(char);
    figure(2);
    plot_figure_Lambda(char);
 
    % read sample' points
    if ismember(char, 'A':'F')
        sample_filepath = strcat(inputDataFilepath, 'PA5-', char,...
            '-Debug-SampleReadingsTest.txt');
    else
        sample_filepath = strcat(inputDataFilepath, 'PA5-', char,...
            '-Unknown-SampleReadingsTest.txt');
    end
    [num_samples, A_set, B_set] = parseSample(sample_filepath, num_a, num_b);

    % get the sample points' position d
    d_set = zeros(4, num_samples);
    for i=1:num_samples
        A = A_set(:,:,i);
        B = B_set(:,:,i);
        % registration
        [FA, residual_FA(i)]= registration(A,a);
        [FB, residual_FB(i)] = registration(B,b);
        % d in homogeneous form
        d_set(:,i) = FB\FA*[a_tip';1];
    end
    disp(strcat('registration residual error FA:',num2str(sum(residual_FA))));
    disp(strcat('registration residual error FB:',num2str(sum(residual_FB))));
    
    % some preallocation
    s_set = zeros(num_samples, 3);
    c_set = zeros(num_samples, 3);
    error_set = zeros(num_samples, 1);
    c_in_which_triangle = inf(num_samples, 1);
    output = inf(num_samples+1, 7);

    % initial guess for registration matrix
    Freg = eye(4);
    
    % initial guess for lambda
    num_modes = 6;
    Lambda = zeros(1,6);
    
    maxIteration = 100;
    for iteration=1:maxIteration
        % deform the mesh based on current Lambda
        triangle_set = deform_triangle_set...
                (Mode, Lambda, triangle_vertices_index);
        % compute the radius and center of triangle for triangle set
        [radius, center_of_triangle] = radius_center_of_sphere(triangle_set);
        
        % find s and c respectively
        parfor i=1:num_samples
            s = Freg*d_set(:,i);
            s = s(1:3);

            % bounding sphere
            [c, triangle_index] = ...
                linear_search_bounding_spheres...
                    (s, triangle_set, center_of_triangle, radius);

            s_set(i,:) = s';
            c_set(i,:) = c';
            error_set(i) = norm(s'-c');
            c_in_which_triangle(i) = triangle_index;
        end
        
        % Deformable Registration
        % vertices index of corresponding triangles to each closest point
        t_index = triangle_vertices_index(c_in_which_triangle,1)+1;
        u_index = triangle_vertices_index(c_in_which_triangle,2)+1;
        v_index = triangle_vertices_index(c_in_which_triangle,3)+1;
        
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

        Q = [];
        for i=1:num_samples
            % samples' position - mode 0
            m_t0 = Mode(t_index(i),:,1);
            m_u0 = Mode(u_index(i),:,1);
            m_v0 = Mode(v_index(i),:,1);
            qi0 = para(i,1)*m_t0 + para(i,2)*m_u0 + para(i,3)*m_v0;

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
        
        [dF, dLambda] = solve_F_Lambda(s_set, c_set, Q);
        % update registration matrix
        Freg = dF*Freg;
        Lambda = Lambda + dLambda';
        
        % check if meets the stopping condition
        if norm(dF-eye(4))<0.001 &&...
                norm(dLambda)<0.1
            disp(strcat('data set:',char,' convergence reached'));
            break;
        end
        
        % update figure
        figure(1);
        update_figure_Freg(iteration, max(error_set));
        figure(2);
        update_figure_Lambda(iteration, Lambda);
    end
    disp(strcat('experienced iterations:',num2str(iteration)));
    disp(strcat('final maximum points pair error:', num2str(max(error_set))));
    disp(strcat('final Lambda:'))
    disp(num2str(Lambda));
    toc
    disp('--------------------------------------------------------------');
    
    % store the figure, clean the figure
    saveas(figure(1),strcat(outputFigureFilepath, ...
        'Method-2/ErrorPlot/ErrorPlot-2',char,'.png'));
    saveas(figure(2),strcat(outputFigureFilepath, ...
        '/Method-2/LambdaPlot/Lambdaplot-2',char,'.png'));
    clf(figure(1));
    clf(figure(2));
    
    % store the result to txt file
    savedata(Lambda, s_set, c_set, error_set, char, '2', '', outputDataFilepath);
end
close all;