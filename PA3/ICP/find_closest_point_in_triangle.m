function closest_point_in_triangle = find_closest_point_in_triangle(s, triangle)
    % get the three vertexes of triangle
    p = triangle(1:3)';
    q = triangle(4:6)';
    r = triangle(7:9)';
    
    % get the parameter by solving least square problem
    parameter = linsolve([q-p,r-p],(s-p));
    lambda = parameter(1);
    mu = parameter(2);

    c = p+lambda*(q-p)+mu*(r-p);
    
    % if the closest point lies inside the triangle
    if lambda>=0 && mu>=0 && lambda+mu<=1
        closest_point_in_triangle = c;
        return;
    end
    
    % lies in p ~ r
    if lambda<0
        lambda_ = dot(c-r,p-r)/dot(p-r,p-r);
        lambda_star = max(0, min(lambda_,1));
        closest_point_in_triangle = r+lambda_star*(p-r);
        return;
    % lies in p ~ q
    elseif mu<0
        lambda_ = dot(c-p,q-p)/dot(q-p,q-p);
        lambda_star = max(0, min(lambda_,1));
        closest_point_in_triangle = p+lambda_star*(q-p);
        return;
    % lies in r ~ q
    elseif lambda+mu>1
        lambda_ = dot(c-q,r-q)/dot(r-q,r-q);
        lambda_star = max(0, min(lambda_,1));
        closest_point_in_triangle = q+lambda_star*(r-q);
        return;
    end
    
end