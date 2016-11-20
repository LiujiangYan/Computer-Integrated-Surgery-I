function [u, qmax, qmin] = scale_to_box(q)
    % get the maximum and minimum value of each column (x, y, z)
    qmax = max(q);
    qmin = min(q);
    
    % scale each row into [0,1]
    u = zeros(size(q));
    for i=1:length(q)
        u(i,:) = (q(i,:) - qmin)./(qmax - qmin);
    end
end