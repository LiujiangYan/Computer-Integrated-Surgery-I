%% initialization
clear;
clc;
format compact;

%% add the path
addpath('PA234 - Student Data/');
addpath('Parse/');
addpath(genpath('ICP/'));

%% read mesh files
mesh_filepath = 'PA234 - Student Data/Problem3MeshFile.sur';
triangle_set = parseMesh(mesh_filepath);

%% get the bounding sphere, boxes, octree for triangle set 
% radius and center for each bounding triangle
[radius, center_of_triangle] = radius_center_of_sphere(triangle_set);
% lower and upper bound for each bounding box
[triangle_box_lower, triangle_box_upper] = bound_of_box(triangle_set);
% lower and upper bound for the whole triangle set
lower_bound = min(triangle_box_lower, [], 1);
upper_bound = max(triangle_box_upper, [], 1);

index_of_triangles = (1:size(center_of_triangle, 1))';
% build tree
octree = octree_object...
    (upper_bound, lower_bound, center_of_triangle, index_of_triangles);
% enlarge the bound
octree.enlarge_bound(triangle_set);

%% double check
difference = [];
for char = 'A':'F'
    if ismember(char, 'A':'F');
        validation_set_path = strcat('PA3-', char, '-Debug-Output.txt');
    else
        validation_set_path = strcat('PA3-', char, '-Unknown-Output.txt');
    end
    
    FID = fopen(validation_set_path);
    file = fgetl(FID);
    datasize = [7, Inf];
    validation_set = transpose(fscanf(FID, '%f\t%f\t%f\n', datasize));
    fclose(FID);

    d_set = validation_set(:,1:3);
    c_set = validation_set(:,4:6);
    
    for i=1:size(d_set,1)
        closest_point(i,:) = linear_search_brute_force...
            (d_set(i,:)', triangle_set)';
    end
    
    distance_control = ...
        (sum((d_set - c_set).^2,2).^1/2)';
    distance_experiment = ...
        (sum((d_set - closest_point).^2,2).^1/2)';
    
    disp(strcat('the difference of distance from closest point to mesh in ', char));
    disp(sum(distance_control - distance_experiment));
    
    % the difference of distance from closest point to mesh
    difference = [difference; sum(distance_control - distance_experiment)];
end