function c_expected = c_expected_value(D, d, A, a, c)
    % perform 3D point set to 3D point set registration
    F_AC = registration(A, a);
    F_AD = registration(D, d);
    
    % perform composition rule
    F_DC = F_AD\F_AC;
    
    % write c in homogeneous representation and compute C expected
    c(:,4) = 1;
    c_expected = F_DC*c';
    c_expected = c_expected(1:3,:)';
end