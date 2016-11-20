function B = fiducials_in_EM...
                    (NG, NB, G, C, pivot, g_1st_frame, qmax, qmin)
    % record the position of fiducial points with respect to EM tracker
    B = zeros(NB,3);
    
    % correct the distorted point
    G_expected = distortion_correct(G, C, qmax, qmin);

    % get the homogeneous representation of pivot value
    g_pivot = pivot(1:3);
    g_pivot(4) = 1;
    
    % loop each data frame
    for n=1:NB
        % get the EM markers' position to EM tracker and local frame
        startpoint = (n-1)*NG + 1;
        endpoint = n*NG;
        G = G_expected(startpoint:endpoint,:);
        % compute the transformation
        FG = registration(G, g_1st_frame);
        
        % get the fiducial point with respect to EM tracker
        B_pivot = FG*g_pivot;
        B(n,:) = B_pivot(1:3)';
    end
end