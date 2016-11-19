function [radius, center] = radius_center_of_sphere(triangle_set)
    radius = zeros(size(triangle_set,1), 1);
    center = zeros(size(triangle_set,1), 3);
    
    for index = 1:size(triangle_set,1)
        % get a vertices by original order
        a = triangle_set(index, 1:3);
        b = triangle_set(index, 4:6);
        c = triangle_set(index, 7:9);
        
        % adjust the order by length
        if norm(b-c) > norm(a-b)
            if norm(b-c) > norm(a-c)
                [a, c] = deal(c, a);
            else
                [b, c] = deal(c, b);
            end
        elseif norm(a-c) > norm(a-b)
            [b, c] = deal(c, b);
        end
        
        % check if the order is wrong, make sure a-b is the longest
        if norm(a-b) < norm(b-c) || norm(a-b) < norm(a-c)
            disp('failed');
            break;
        end
        
        f = (a+b)/2;
        u = a - f;
        v = c - f;
        d = cross(cross(u, v), u);
        
        gamma = (norm(v)^2 - norm(u)^2)/(2*dot(d, v-u));
        if gamma < 0
            lambda = 0;
        else
            lambda = gamma;
        end
        
        q = f + lambda*d;
        r = norm(q-a);
        
        center(index,:) = q;
        radius(index) = r;
    end
end