classdef octree_object < handle
    properties
        split_point
        upper
        lower
        centers
        index
        child
        depth
    end
    
    methods
        function this = octree_object...
                (upper_bound,lower_bound,center_of_triangle,index_of_triangle)
            mid_point = 1/2*(upper_bound + lower_bound);
            % assigning essential properties
            this.split_point = mid_point;
            this.upper = upper_bound;
            this.lower = lower_bound;
            this.centers = center_of_triangle;
            this.index = index_of_triangle;
            this.depth = 1;
            
            % limiting the size of each box under 7 points
            if size(this.centers, 1) < 7
                return;
            end
            
            % recursion and build the subtree  
            count = 1;
            max_depth = 0;
            for box_index = 1:8
                [sub_upper, sub_lower] = compute_sub_bound...
                        (upper_bound, lower_bound, box_index, center_of_triangle);
                [sub_tri_centers, sub_tri_index] = compute_sub_centers...
                    (sub_upper, sub_lower, center_of_triangle, index_of_triangle);
                
                if size(sub_tri_centers,1) > 0 
                    sub_tree = octree_object...
                        (sub_upper, sub_lower, sub_tri_centers, sub_tri_index);                        
                    this.child{count} = sub_tree;

                    if this.child{count}.depth > max_depth
                        max_depth = this.child{count}.depth;
                    end
                    
                    count = count + 1;
                end
            end
            this.depth = this.depth + max_depth;
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

function [sub_upper, sub_lower] = compute_sub_bound...
    (upper_bound, lower_bound, index, center_of_triangle)
    
    % return the child node's boundary by specific index
    % mid_point = 1/2*(upper_bound + lower_bound);
    mid_point = mean(center_of_triangle);
    if ismember(index, [5,6,7,8]) 
        i=1;
    else 
        i=0;
    end
    if ismember(index, [3,4,7,8])
        j=1;
    else
        j=0;
    end
    if ismember(index, [2,4,6,8])
        k=1;
    else
        k=0;
    end
    
    sub_lower(1) = lower_bound(1) + i*(mid_point(1)-lower_bound(1));
    sub_upper(1) = mid_point(1) + i*(upper_bound(1)-mid_point(1));

    sub_lower(2) = lower_bound(2) + j*(mid_point(2)-lower_bound(2));
    sub_upper(2) = mid_point(2) + j*(upper_bound(2)-mid_point(2));

    sub_lower(3) = lower_bound(3) + k*(mid_point(3)-lower_bound(3));
    sub_upper(3) = mid_point(3) + k*(upper_bound(3)-mid_point(3));
                
end

function [sub_centers, sub_index] = compute_sub_centers...
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









