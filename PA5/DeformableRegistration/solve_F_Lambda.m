function [dF, Lambda] = solve_F_Lambda(s_set, c_set, Q)
    A = [];
    b = reshape((s_set - c_set)', size(s_set,1)*3, 1);
    for i = 1:size(s_set,1)
        A = [A; [hat(s_set(i,:)) -eye(3) Q(3*(i-1)+1:3*i,:)]];
    end
    H = linsolve(A, b);
    dF = deltaFreg(H(1:3), H(4:6));
    Lambda = H(7:12);
end

function dF = deltaFreg(a, t)
    R = rotationByAlpha(a);
    dF = eye(4);
    dF(1:3,1:3) = R;
    dF(1:3,4) = t;
end

function R = rotationByAlpha(alpha)
    w = alpha/norm(alpha);
    theta = norm(alpha);
    w_hat = hat(w);
    R = eye(3) + w_hat*sin(theta) + w_hat^2*(1-cos(theta));
end

function m_hat = hat(m)
    m_hat = [0    -m(3) m(2)
             m(3) 0    -m(1);
            -m(2) m(1)  0];
end