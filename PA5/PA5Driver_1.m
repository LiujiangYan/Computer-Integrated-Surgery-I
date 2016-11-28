%% initialization
clc;
clear;
close all;
format compact;

%% addpath
addpath('PlotFigure/');
addpath('Parse/');
addpath(genpath('IterativeClosestPoint/'));
addpath('DeformableRegistration/');

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
figure_ICP = figure(1);
figure_Lambda = figure(2);
for char = ['A':'H','J','K']
    tic
    disp(strcat('data set:',char,' started'));
    
    % read sample' points
    if ismember(char, 'A':'F')
        sample_filepath = strcat('PA234 - Student Data/PA5-',char,...
            '-Debug-SampleReadingsTest.txt');
    else
        sample_filepath = strcat('PA234 - Student Data/PA5-',char,...
            '-Unknown-SampleReadingsTest.txt');
    end
    [num_samples, A_set, B_set] = parseSample(sample_filepath, num_a, num_b);

    % get the sample points' position d
    d_set = zeros(4, num_samples);
    parfor i=1:num_samples
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
    updated_Freg = eye(4);
    
    % initial guess for lambda
    num_modes = 6;
    update_Lambda = zeros(1,6);
    
    % maximum iteration
    maxiteration = 1000;
    maxICPiteration = 1;
    
    for iteration = 1:maxiteration
        
        % deform the mesh based on current Lambda
        triangle_set = deform_triangle_set...
                (Mode, update_Lambda, triangle_vertices_index);
        % compute the radius and center of triangle for triangle set
        [radius, center_of_triangle] = radius_center_of_sphere(triangle_set);
        
        figure(1);
        plot_figure_ICP(char);
        % Iterative Closest Point
        Freg = updated_Freg;
        for ICP_iteration = 1:maxICPiteration
            
            parfor i=1:num_samples
                s = updated_Freg*d_set(:,i);
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
            delta_Freg = registration(c_set, s_set);
            updated_Freg = delta_Freg*updated_Freg; 
            
            figure(1);
            plot(iteration, max(error_set), 'r*','MarkerSize',6);
            drawnow;
            if max(error_set) < 0.01
                break;
            elseif norm(delta_Freg-eye(4)) < 0.001
                break;
            end
        end
        
        figure(2);
        plot_figure_Lambda(char);
        % Deformable Registration
        Lambda = update_Lambda;
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
        
        % plot the lambda
        figure_Lambda;
        plot(iteration, update_Lambda(1), 'yo','MarkerSize',6);
        plot(iteration, update_Lambda(2), 'm+','MarkerSize',6);
        plot(iteration, update_Lambda(3), 'c*','MarkerSize',6);
        plot(iteration, update_Lambda(4), 'r.','MarkerSize',6);
        plot(iteration, update_Lambda(5), 'gx','MarkerSize',6);
        plot(iteration, update_Lambda(6), 'bs','MarkerSize',6);
        
        % check if meets the stopping condition
        if norm(Freg - updated_Freg)<0.01 &&...
                norm(Lambda - update_Lambda)<0.1
            disp('convergence reached');
            break;
        end
        
    end
    disp(strcat('data set:',char,' finished'));
    disp(strcat('experienced iterations:',num2str(iteration)));
    disp(strcat('final maximum points pair error:', num2str(max(error_set))));
    disp(strcat('final Lambda:',num2str(Lambda')));
    toc
    disp('--------------------------------------------------------------');

    % clean the figures
    saveas(figure(1),strcat('PA5OutputFig/Method-1/ErrorPlot/ErrorPlot-1',char,'.png'));
    saveas(figure(2),strcat('PA5OutputFig/Method-1/Lambdaplot/Lambdaplot-1',char,'.png'));
    clf(figure_ICP);
    clf(figure_Lambda);
    
    % store the result to txt file
    output(1,2:7) = update_Lambda;
    output(2:end,1:3) = s_set;
    output(2:end,4:6) = c_set;
    output(2:end,7) = error_set;
    output_filepath = strcat('PA5OutputData/Method-1/PA5-', char, '-Output-1.txt');
    csvwrite(output_filepath, output);
    
end
close all;