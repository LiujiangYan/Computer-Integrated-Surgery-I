function Fform = registration(P, p)
    % 3D point set to 3D point set registration
    % Fa = A -> solve linear system At=b
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
end