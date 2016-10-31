function G_expected = distortion_correct(G, C, qmax, qmin)
    % scale the measured data to [0,1]
    % with experimental distorted data's maximum and minimum value
    G_norm = zeros(size(G));
    for i=1:length(G)
        G_norm(i,:) = (G(i,:)-qmin)./(qmax-qmin);
    end
    
    % get the Bernstein matrix of normalized distorted data
    F = BernsteinMat(G_norm);
    % apply the distortion correction matrix to get the expected value
    G_expected = F*C;
end