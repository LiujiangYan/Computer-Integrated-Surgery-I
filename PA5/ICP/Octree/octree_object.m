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
                (upper_bound,lower_bound,centers_of_triangle,index_of_triangle)
            mid_point = 1/2*(upper_bound + lower_bound);
            % assigning essential properties
            this.split_point = mid_point;
            this.upper = upper_bound;
            this.lower = lower_bound;
            this.centers = centers_of_triangle;
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
                [sub_upper, sub_lower] = compute_subtree_bound...
                        (upper_bound, lower_bound, box_index);
                [sub_tri_centers, sub_tri_index] = compute_subtree_centers...
                    (sub_upper, sub_lower, centers_of_triangle, index_of_triangle);
                
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














