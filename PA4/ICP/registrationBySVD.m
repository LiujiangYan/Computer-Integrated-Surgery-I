function [Fform,residual] = registrationBySVD(p, q)

    % Fform*p = q;
    
    n = size(p, 1);
    m = size(q, 1);

    % Find data centroid and deviations from centroid
    pmean = sum(p,1)/n;
    p2 = p - repmat(pmean, n, 1);

    qmean = sum(q,1)/m;
    q2 = q - repmat(qmean, m, 1);

    % Covariance matrix
    C = p2'*q2; 

    [U,~,V] = svd(C); 

    % Handle the reflection case
    R = V*diag([1 1 sign(det(U*V'))])*U';

    % Compute the translation
    T = qmean' - R*pmean';
    
    % return the homogeneous form
    Fform = eye(4);
    Fform(1:3,1:3) = R;
    Fform(1:3,4) = T;
    
    % residual error
    p(:,4) = 1; p = p';
    q(:,4) = 1; q = q';
    residual = sum(sum((Fform*p-q).^2, 1).^1/2);
end