function [sub_upper, sub_lower] = compute_subtree_bound...
    (upper_bound, lower_bound, index)
    
    % return the child node's boundary by specific index
    mid_point = 1/2*(upper_bound + lower_bound);
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