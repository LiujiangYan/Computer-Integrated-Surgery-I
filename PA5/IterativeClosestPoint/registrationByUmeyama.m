function F = registrationByUmeyama(P, p)
    up = mean(p);
    uP = mean(P);
    sigma_p = p - repmat(up, size(p,1), 1);
    sigma_P = P - repmat(up, size(P,1), 1);
    
    sigma = 1/size(p,1)*sigma_P'*sigma_p;
    [U,~,V] = svd(sigma);
    
    S = eye(3);
    if det(U)*det(V) < 0 || det(sigma) < 0
        S(3,3) = -1;
    end
    
    R = U*S*V';
    t = uP' - R*up';
    
    F = eye(4);
    F(1:3,1:3) = R;
    F(1:3,4) = t;
end