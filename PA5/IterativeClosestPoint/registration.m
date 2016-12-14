function [Fform, residual] = registration(P, p)
    % 3D point set to 3D point set registration
    % Fp = P -> solve linear system At=b
    A = [];
    b = [];
    for i=1:length(p)
        subA = [p(i,1) p(i,2) p(i,3) 1 0 0 0 0 0 0 0 0;
                0 0 0 0 p(i,1) p(i,2) p(i,3) 1 0 0 0 0;
                0 0 0 0 0 0 0 0 p(i,1) p(i,2) p(i,3) 1];
        subb = [P(i,1); P(i,2); P(i,3)];
        A = [A; subA];
        b = [b; subb];
    end
    % solve the least square
    h = linsolve(A,b);
    Ffrom = reshape(h,4,3);
    Fform = [Ffrom'; 0 0 0 1];
    
%     R = Fform(1:3, 1:3);
%     Fform(1:3,1:3) = makeRrigid(R);
    
    p(:,4) = 1; p = p';
    P(:,4) = 1; P = P';
    residual = sum(sum((Fform*p-P).^2, 1).^1/2);
end

function rigidR = makeRrigid(R)
    [U, ~, V] = svd(R);
    rigidR = U*V';
end