classdef kdtree_object < handle
    properties
        split_point
        upper
        lower
        centers
        index
        child
        split_node
    end
    
    methods
        function this = kdtree_object...
                (split_node,upper_bound,lower_bound,center_of_triangle,index_of_triangle)
            this.upper = upper_bound;
            this.lower = lower_bound;
            this.centers = center_of_triangle;
            this.index = index_of_triangle;
            this.split_node = split_node;
            
            % limiting the size of each box under 7 points
            if size(this.centers, 1) < 7
                return;
            end
            
            % recursion and build the subtree
            [sub_upper, sub_lower] = kd_subtree_bound...
                (split_node, upper_bound, center_of_triangle, lower_bound);
            for index = 1:2
                upper_bound = sub_upper(index,:);
                lower_bound = sub_lower(index,:);
                [sub_center, sub_index] = kd_subtree_centers...
                    (upper_bound, lower_bound, center_of_triangle, index_of_triangle);
                if size(sub_center,1) > 0
                    sub_tree = kdtree_object...
                        (split_node+1, upper_bound, lower_bound, sub_center, sub_index);
                    this.child{index} = sub_tree;
                end
            end
        end
        
        function enlarge_bound(this, triangle_set)
            triangle_sub_set = triangle_set(this.index,:);
            % lower and upper bound for each bounding box
            [triangle_box_lower, triangle_box_upper] = bound_of_box(triangle_sub_set);
           
            % lower and upper bound for the whole triangle set
            lower_bound = min(triangle_box_lower, [], 1);
            upper_bound = max(triangle_box_upper, [], 1);
            this.upper = upper_bound;
            this.lower = lower_bound;
            
            % recursion
            if size(this.child, 2) > 0
                for i=1:size(this.child, 2)
                    subtree = this.child{i};
                    subtree.enlarge_bound(triangle_set);
                end
            end
        end
    end   
end

function [sub_upper, sub_lower] = kd_subtree_bound...
            (split_node, upper_bound, centers_of_triangle, lower_bound)
    % initialize
    sub_upper = [upper_bound; upper_bound];
    sub_lower = [lower_bound; lower_bound];
    % set the boundary by given split node
    switch mod(split_node,3)
        % split by x
        case 0
            sub_upper(1,1) = mean(centers_of_triangle(:,1));
            sub_lower(2,1) = mean(centers_of_triangle(:,1));
        % split by y
        case 1
            sub_upper(1,2) = mean(centers_of_triangle(:,2));
            sub_lower(2,2) = mean(centers_of_triangle(:,2));
        % split by z
        case 2
            sub_upper(1,3) = mean(centers_of_triangle(:,3));
            sub_lower(2,3) = mean(centers_of_triangle(:,3));
    end
end

function [sub_centers, sub_index] = kd_subtree_centers...
            (upper_bound, lower_bound, center_of_triangle, index_of_triangles)
    % given the boundary of box
    % return the centers/index that belong to it
    log_vector = ones(size(center_of_triangle,1), 1);
    for i=1:3
        lower_log_vector = center_of_triangle(:,i) >= lower_bound(i);
        upper_log_vector = center_of_triangle(:,i) <= upper_bound(i);
        log_vector = log_vector & lower_log_vector;
        log_vector = log_vector & upper_log_vector;
    end
    
    sub_centers = center_of_triangle(log_vector,:);
    sub_index = index_of_triangles(log_vector);
end




















