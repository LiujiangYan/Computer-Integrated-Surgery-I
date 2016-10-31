function [C, qmax, qmin] = distortion_matrix_compute(C_distorted, C_expected)
    % scale the distorted data into [0,1]
    % record the maximum, minimum value for future undistortion
    [u, qmax, qmin] = scale_to_box(C_distorted);
    % compute the Berstein Matrix of scaled distorted data
    F = BernsteinMat(u);
    % solve the least sqaure problem and get the distortion matrix
    C = linsolve(F,C_expected);
end