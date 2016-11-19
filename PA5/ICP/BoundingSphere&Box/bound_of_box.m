function [L_box, U_box] = bound_of_box(triangle_set)
    % lower boundary for each triangle of given triangle set
    L_box(:,1) = min(triangle_set(:,[1 4 7]), [] , 2);
    L_box(:,2) = min(triangle_set(:,[2 5 8]), [] , 2);
    L_box(:,3) = min(triangle_set(:,[3 6 9]), [] , 2);
    
    % upper boundary for each triangle of given triangle set
    U_box(:,1) = max(triangle_set(:,[1 4 7]), [] , 2);
    U_box(:,2) = max(triangle_set(:,[2 5 8]), [] , 2);
    U_box(:,3) = max(triangle_set(:,[3 6 9]), [] , 2);
end