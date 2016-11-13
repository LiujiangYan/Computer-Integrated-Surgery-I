function closest_point_in_triangle = find_closest_point_in_triangle(s, triangle)
    p = triangle(1:3)';
    q = triangle(4:6)';
    r = triangle(7:9)';
    parameter = [q-p,r-p]\(s-p);
    lambda = parameter(1);
    mu = parameter(2);

    c = p+lambda*(q-p)+mu*(r-p);
    
    if lambda>=0 && mu>=0 && lambda+mu<=1
        closest_point_in_triangle = c;
    end
    
    if lambda<0
        lambda_ = dot(c-r,p-r)/dot(p-r,p-r);
        lambda_star = max(0, min(lambda_,1));
        closest_point_in_triangle = r+lambda_star*(p-r);
    elseif mu<0
        lambda_ = dot(c-p,q-p)/dot(q-p,q-p);
        lambda_star = max(0, min(lambda_,1));
        closest_point_in_triangle = p+lambda_star*(q-p);
    elseif lambda+mu>1
        lambda_ = dot(c-q,r-q)/dot(r-q,r-q);
        lambda_star = max(0, min(lambda_,1));
        closest_point_in_triangle = q+lambda_star*(r-q);
    end
    
end